import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_game/components/drag_input_detector.dart';
import 'package:flutter_snake_game/enums/game_overlays.dart';
import 'package:flutter_snake_game/models/game_config.dart';
import 'package:flutter_snake_game/painters/background_grid.dart';
import 'package:flutter_snake_game/painters/snake.dart';
import 'package:flutter_snake_game/services/input_service.dart';

class GameService extends FlameGame with SingleGameInstance, KeyboardEvents {
  GameService({
    required GameConfig config,
    required InputService inputService,
  })  : _config = config,
        _inputService = inputService {
    inputService.initialize(this);
  }

  final GameConfig _config;
  final InputService _inputService;

  late final _background = GridBackground(gridSize: _config.gridSize);
  late final Snake _snake;

  Size _boardSize = Size.zero;
  double _timeSinceLastMove = 0;
  bool _gameOver = false;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  void onGameResize(Vector2 size) {
    _boardSize = size.toSize();
    super.onGameResize(size);
  }

  @override
  FutureOr<void> onLoad() {
    add(DragInputDetector(inputService: _inputService));
    pauseEngine();
    overlays.add(GameOverlays.startGameMenu.name);

    final start = Vector2(
      (_config.gridSize.x ~/ 2).toDouble(),
      (_config.gridSize.y ~/ 2).toDouble() -
          (_config.snakeStartLength ~/ 2).toDouble(),
    );
    final segments = [
      for (int i = 0; i < _config.snakeStartLength; i++)
        start + Vector2(0, i.toDouble()),
    ];

    _snake = Snake(segments: segments, gridSize: _config.gridSize);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _background.paint(canvas, _boardSize);
    _snake.paint(canvas, _boardSize);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    _timeSinceLastMove += dt;
    if (_timeSinceLastMove < _config.moveStep) {
      return;
    }

    _timeSinceLastMove = _timeSinceLastMove % _config.moveStep;

    _snake.move(_inputService.currentDirection);
    if (!_snake.checkAlive(_boardSize)) gameOver();

    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final result = _inputService.handleKeyInput(event, keysPressed);
    if (result != null) {
      return result;
    }
    return super.onKeyEvent(event, keysPressed);
  }

}
