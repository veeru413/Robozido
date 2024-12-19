import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robozido/Rounded_Buttons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robozido/manual.dart';
import 'package:robozido/obs_avoider.dart';
import 'package:robozido/line_follower.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Modes extends StatefulWidget {
  static const String id = "modes";


  @override
  State<Modes> createState() => _ModesState();
}

class _ModesState extends State<Modes> {
  WebSocketChannel? channel;  // WebSocket channel
  int _clickCount = 0;
  String mode = 'ST';  // Default to stop mode
  bool isManualModeActive = false;
  bool isLineFollowerModeActive = false;
  bool isObstacleAvoidanceModeActive = false;

  // Server URL (change to your NodeMCU IP address and port if needed)
  String serverUrl = 'ws://192.168.4.1:81';  // WebSocket server URL

  @override
  void initState() {
    super.initState();
    // Lock orientation to portrait when this page is loaded
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // Connect to WebSocket
    channel = WebSocketChannel.connect(Uri.parse(serverUrl));

  }
  // Function to send mode change command to ESP8266
  // Function to send mode change command to ESP8266
  Future<void> sendCommand(String command) async {
    if (channel != null) {
      // Send command via WebSocket
      channel?.sink.add(command);
      print('Command sent: $command');

      // You can also listen for a response from the server (if needed)
      channel?.stream.listen((response) {
        print('Received from server: $response');
      });
    } else {
      print('WebSocket channel is not connected');
    }
  }

  void toggleMode(String selectedMode) {
    setState(() {
      mode = selectedMode;
      isManualModeActive = selectedMode == 'm';
      isLineFollowerModeActive = selectedMode == 'l';
      isObstacleAvoidanceModeActive = selectedMode == 'o';
    });

    sendCommand(selectedMode);  // Send the selected mode command to ESP8266
  }
  void _resetClickCount() {
    setState(() {
      _clickCount = 0; // Reset the count to zero
    });
  }

  void _onModesTextClicked() {
    setState(() {
      _clickCount++;
    });
    if (_clickCount >= 10) {
      // Navigate to the Easter egg page when clicked 10 times
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EasterEggPage(
            resetClickCount: _resetClickCount, // Pass the reset callback
          ),
        ),
      );
    }
  }
  @override
  void dispose() {
    channel?.sink.close();  // Close WebSocket when the page is disposed
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'images/background_image.jpeg',
            fit: BoxFit.cover,
          ),
          // SafeArea to keep content in safe boundary
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _buildTopCard1(
                        child: Hero(
                          tag: 'logo',
                          child: SizedBox(
                            height: 50,
                            child: Image.asset('images/logo.png'),
                          ),
                        ),
                      ),
                    ),
                    _buildTopCard(
                      child: GestureDetector(
                        onTap: _onModesTextClicked, // Handle tap on MODES text
                        child: Padding(
                          padding: EdgeInsets.only(left: 45, right: 45),
                          child: Text(
                            "MODES",
                            style: GoogleFonts.electrolize(
                              fontSize: 28.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: Colors.black54,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: IconButton(
                            icon:
                            const Icon(Icons.logout, color: Colors.yellow),
                            onPressed: () {
                              _showConfirmationDialog1(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Bottom Cards 4, 5, 6
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          DiagonalCard(
                            imagePath: 'images/manual.jpeg',
                            text: 'Manual Mode',
                            onTap: () {
                              sendCommand('m');
                              Navigator.pushNamed(context, Manual.id);
                            },
                            heroTag: 'manual', // Added Hero tag for Manual Mode
                          ),
                          DiagonalCard(
                            imagePath: 'images/obs_avoiding.jpeg',
                            text: 'Obstacle Avoider',
                            onTap: () {
                              //toggleMode('o');
                              Navigator.pushNamed(context, ObsAvoider.id);
                            },
                            heroTag: 'obstacle', // Added Hero tag for Obstacle Avoider
                          ),
                          DiagonalCard(
                            imagePath: 'images/line_follower.jpeg',
                            text: 'Line Follower',
                            onTap: () {
                              //toggleMode('l');
                              Navigator.pushNamed(context, LineFollower.id);
                            },
                            heroTag: 'line_follower', // Added Hero tag for Line Follower
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCard({required Widget child}) {
    return Card(
      color: Colors.black54,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }

  Widget _buildTopCard1({required Widget child}) {
    return Card(
      color: Colors.black54,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: child,
      ),
    );
  }

// Bottom Cards 4, 5, 6 (Diagonal Split Cards)
}

void _showConfirmationDialog1(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black54,
    builder: (BuildContext context) {
      return Center(
        child: Card(
          color: Colors.grey[800]?.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirmation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Are you sure you wanna Exit?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RoundedButton1(
                        width: 50,
                        length: 16,
                        text: 'No',
                        colors: Colors.yellow,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text_color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: RoundedButton1(
                        width: 50,
                        length: 16,
                        text: 'Yes',
                        colors: Colors.grey,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        text_color: Colors.white,
                        // Close the dialog
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
class EasterEggPage extends StatelessWidget {
  final VoidCallback resetClickCount;

  // Constructor to accept the reset callback
  const EasterEggPage({Key? key, required this.resetClickCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'images/background_image.jpeg',
            fit: BoxFit.cover,
          ),
          // Center content with a Card
          Center(
            child: Card(
              color: Colors.black.withOpacity(0.8),
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Easter Egg Heading in Cursive
                    AnimatedDefaultTextStyle(
                      style: TextStyle(
                        fontFamily: 'Cursive', // Cursive font style
                        fontSize: 40.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                      duration: Duration(milliseconds: 150),
                      child: Text('EASTER EGG🥚'),
                    ),
                    SizedBox(height: 20),
                    // Updated Introductory Message
                    Text(
                      'Hey, there! 🌟\n\nI’m Veerendra, the sole creator of this app, and congratulations on finding the Easter egg! 🙌\n\nYour discovery truly reflects the passion and love you have for this app, and it fills me with joy. 💛\n\nJust keep loving ROBOCELL and this app, and with that, it’s me signing off. 🚀\n\n#ROBOCELL27 Created with love ~ 20th Dec 2024 ✨',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontFamily: 'Roboto', // Plain font for the text body
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    // Go back button
                    ElevatedButton(
                      onPressed: () {
                        resetClickCount(); // Reset the count when going back
                        Navigator.pop(context);
                      },
                      child: Text("Go Back", style: TextStyle(fontSize: 18.0)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class DiagonalCard extends StatelessWidget {
  final String imagePath; // Background Image
  final String text; // Card Text
  final VoidCallback onTap; // Button Functionality
  final String heroTag; // Hero tag for each image

  const DiagonalCard({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.onTap,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath), // Full image as background
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Diagonal Opaque Overlay
            ClipPath(
              clipper: DiagonalClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // Opaque color
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            // Hero Widget for animation
            Hero(
              tag: heroTag,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    text,
                    style: GoogleFonts.lexend(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Clipper for Diagonal Design
class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height); // Bottom-left
    path.lineTo(size.width, size.height * 0.75); // Bottom-right diagonal point
    path.lineTo(size.width, 0); // Top-right
    path.close(); // Back to Top-left
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
