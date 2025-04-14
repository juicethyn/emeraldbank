import 'package:flutter/material.dart';

class HomeTextButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final double horizontalPadding;
  final Color backgroundColor;
  final Color textColor;
  
  const HomeTextButtonWidget({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.horizontalPadding = 30.0, // Default padding
    this.backgroundColor = const Color(0xFFD9D9D9), // Default background color
    this.textColor = Colors.black, // Default text color
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
            onPressed: () {
              onPressed();
            },
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)
              )
            ), 
            child: Text(buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600 
            )
            )
          );
  }
}