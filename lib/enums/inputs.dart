import 'package:flutter/services.dart';

enum Inputs {
  up,
  down,
  left,
  right,
  pause,
  ;

  static Inputs? getInput(LogicalKeyboardKey input) {
    if (input == LogicalKeyboardKey.escape ||
        input == LogicalKeyboardKey.keyP) {
      return Inputs.pause;
    }

    if (input == LogicalKeyboardKey.arrowUp ||
        input == LogicalKeyboardKey.keyW) {
      return Inputs.up;
    }

    if (input == LogicalKeyboardKey.arrowDown ||
        input == LogicalKeyboardKey.keyS) {
      return Inputs.down;
    }

    if (input == LogicalKeyboardKey.arrowLeft ||
        input == LogicalKeyboardKey.keyA) {
      return Inputs.left;
    }

    if (input == LogicalKeyboardKey.arrowRight ||
        input == LogicalKeyboardKey.keyD) {
      return Inputs.right;
    }

    return null;
  }
}
