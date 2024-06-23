import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_game/enums/direction.dart';
import 'package:flutter_snake_game/enums/inputs.dart';
import 'package:flutter_snake_game/extensions/vector2_extensions.dart';
import 'package:flutter_snake_game/services/game_service.dart';

/// Handles user input for the game
class InputService {
  InputService._();

  late final _gameService = GameService.instance;

  static InputService? _instance;
  static InputService get instance {
    _instance ??= InputService._();
    return _instance!;
  }

  Direction? _currentDirection;
  /// The last direction input received
  Direction? get currentDirection => _currentDirection;

  /// Resets the service to its initial state
  void reset() {
    _currentDirection = null;
  }

  /// Handles keyboard input, returning whether the event was handled
  KeyEventResult? handleKeyInput(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return null;

    final input = Inputs.getInput(keysPressed.last);

    if (input == null) return null;

    handleInput(input);
    return KeyEventResult.handled;
  }

  /// Handles directional drag input
  void handleDragInput(Vector2 velocity) {
    _currentDirection = velocity.asDirection;
  }

  /// Handles a given game input
  void handleInput(Inputs input) {
    switch (input) {
      case Inputs.up:
        _currentDirection = Direction.up;
        break;
      case Inputs.down:
        _currentDirection = Direction.down;
        break;
      case Inputs.left:
        _currentDirection = Direction.left;
        break;
      case Inputs.right:
        _currentDirection = Direction.right;
        break;
      case Inputs.pause:
        _gameService.togglePause();
        break;
    }
  }
}
