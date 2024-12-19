import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:robozido/Rounded_Buttons.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ObsAvoider extends StatefulWidget {
  static const String id = "obs_avoider";

  @override
  State<ObsAvoider> createState() => _ObsAvoiderState();
}

class _ObsAvoiderState extends State<ObsAvoider> {
  String serverUrl = 'ws://192.168.4.1:81';  // WebSocket URL

  WebSocketChannel? channel;  // WebSocket channel

  @override
  void initState() {
    super.initState();
    // Lock orientation to portrait when this page is loaded
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Connect to the WebSocket server when the page is loaded
    channel = WebSocketChannel.connect(Uri.parse(serverUrl));
  }

  bool isRunning = false; // State variable for START/STOP

  // Send command through WebSocket
  void sendCommand(String command) {
    if (channel != null) {
      channel!.sink.add(command);
      print('Command sent: $command');
    } else {
      print('Error: WebSocket not connected');
    }
  }

  // Toggle START/STOP
  void _toggleStartStop() {
    setState(() {
      isRunning = !isRunning; // Toggle state

      if (isRunning) {
        // Send command to start obstacle avoidance mode
        sendCommand('o');  // 'o' for Obstacle Avoidance Mode
      } else {
        // Send STOP command
        sendCommand('ST');  // 'ST' for Stop Mode
      }
    });
  }

  @override
  void dispose() {
    // Close the WebSocket connection when the page is disposed
    channel?.sink.close();
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
          SafeArea(
            child: ListView(
              children: [
                Column(
                  children: [
                    // Top Row
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
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              "OBS AVOIDING",
                              style: GoogleFonts.electrolize(
                                fontSize: 25.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildTopCard1(
                            child: IconButton(
                              icon: const Icon(Icons.logout,
                                  color: Colors.yellow),
                              onPressed: () {
                                sendCommand('ST');
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Card Below First Row
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      child: Hero(
                        tag: 'obstacle',
                        child: Image.asset(
                          'images/obs_avoiding.jpeg',
                          fit: BoxFit.cover, // Adjust the fit to cover the available space
                          height: 580,  // Set a fixed height for the image
                          width: double.infinity,  // Make it fill the width
                        ),
                      ),
                    ),
                    // Rounded Button BELOW the Card
                    RoundedButton1(
                      colors: isRunning ? Colors.red : Colors.green,
                      text_color: Colors.white,
                      text: isRunning ? "STOP" : "START",
                      onPressed: _toggleStartStop,
                      length: 16,
                      width: 300,
                    ),
                  ],
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
}
