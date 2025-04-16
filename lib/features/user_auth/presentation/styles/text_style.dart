import 'package:flutter/material.dart';

class FormStyles {
  static const TextStyle labelStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1a1819),
  );

  static final TextStyle hintStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1a1819).withAlpha(102),
  );

  static const TextStyle sectionHeaderStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1a1819),
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1a1819),
  );

  static const TextStyle submitFormButtonLabel = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static InputDecoration textFieldDecoration({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintStyle: hintStyle,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),

      // Default Border - Unfocused
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

      // Focused Border
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: const Color(0xFF044E42).withAlpha(200),
          width: 2.0,
        ),
      ),

      // Default Error Border - can customize later
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
    );
  }
}
