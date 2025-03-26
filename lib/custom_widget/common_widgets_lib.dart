import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double textFontSize;

  const CustomButton({required this.text, required this.onPressed, super.key,
    this.color = const Color(0xFFFFFFFF),
    this.textColor = Colors.black,
    this.textFontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: textFontSize),
      ),
    );
  }
}
