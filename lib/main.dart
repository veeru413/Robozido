import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:robozido/line_follower.dart';
import 'package:robozido/manual.dart';
import 'package:robozido/modes.dart';
import 'package:robozido/obs_avoider.dart';

import 'Rounded_Buttons.dart';

void main() {
  runApp(RoboCellApp());
}

class RoboCellApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        Modes.id: (context) => Modes(),
        Manual.id: (context) => Manual(),
        ObsAvoider.id: (context) => ObsAvoider(),
        LineFollower.id: (context) => LineFollower(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _popupDisplayed = false; // Tracks if the pop-up has been shown

  @override
  void initState() {
    super.initState();
    // Lock orientation to portrait when this page is loaded
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  static const colorizeColors = [
    Colors.white,
    Colors.black,
    Colors.grey,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 35.0,
    fontWeight: FontWeight.w900,
  );


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              'images/background_image.jpeg',
              fit: BoxFit.cover,
            ),
            // Main Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Club Logo
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 400,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const SizedBox(height: 10),
                // Event Name
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'ROBOZIDO',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ],
                  isRepeatingAnimation: true,
                ),
                const SizedBox(height: 40),
                // Button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.shade700.withOpacity(0.7),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_popupDisplayed) {
                        setState(() {
                          _popupDisplayed = true;
                        });
                        _showConfirmationDialog1(context);
                      } else {
                        Navigator.pushNamed(context, Modes.id);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(300),
                      ),
                      backgroundColor: Colors.yellow,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Let's Get Started",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
                  'Important',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Make sure you are connected to NODEMCU before proceeding.',
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
                        width: 25,
                        length: 16,
                        text: 'Okay',
                        colors: Colors.yellow,
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, Modes.id);
                        },
                        text_color: Colors.black,
                      ),
                    ),
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
