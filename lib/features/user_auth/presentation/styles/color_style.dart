import 'package:flutter/material.dart';

class Customgradients {
  static const LinearGradient iconGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF044E42), Color(0xFF1A685B), Color(0xFF3A8175)],

    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardAccountGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D4FF), Color(0xFF06D6A0), Color(0xFF06D6A0)],
    stops: [0.0, 0.67, 1.0],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6D6A6B), Color(0xFF414F40), Color(0xFF1A1819)],
    stops: [0.14, 0.52, 0.89],
  );
}
