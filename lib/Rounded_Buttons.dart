import 'package:flutter/material.dart';

class RoundedButton1 extends StatelessWidget {
  final Color colors;
  final Color text_color;
  final String text;
  final VoidCallback onPressed;
  final double length ;
  final double width;

  RoundedButton1({super.key, required this.text, required this.colors, required this.onPressed, required this.length, required this.width,required this.text_color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: length),
      child: Material(
        elevation: 5.0,
        color: colors,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: width,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              color: text_color,
            ),
          ),
        ),
      ),
    );
  }
}
