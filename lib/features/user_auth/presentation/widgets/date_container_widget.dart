import 'package:flutter/material.dart';

class DateContainerWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool readOnly;
  final VoidCallback? onTap;

  const DateContainerWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF06D6A0),
              width: 1.8,
            ),
            borderRadius: BorderRadius.circular(12)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF06D6A0),
              width: 1.8,
            ),
            borderRadius: BorderRadius.circular(12)
          ),
          border: InputBorder.none,
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}