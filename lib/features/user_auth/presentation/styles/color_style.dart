import 'package:flutter/material.dart';

class Customgradients {
  static const LinearGradient iconGradient = LinearGradient(
    begin: Alignment(-1.0, -1.0),
    end: Alignment(1.0, 1.0),
    colors: [Color(0xFF044E42), Color(0xFF1A685B), Color(0xFF3A8175)],

    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardAccountGradient = LinearGradient(
    begin: Alignment(-1.0, -1.0),
    end: Alignment(1.0, 1.0),
    colors: [Color(0xFF00D4FF), Color(0xFF06D6A0), Color(0xFF06D6A0)],
    stops: [0.0, 0.67, 1.0],
  );
}
