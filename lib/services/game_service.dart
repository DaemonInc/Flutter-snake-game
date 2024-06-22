import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_game/components/drag_input_detector.dart';
import 'package:flutter_snake_game/enums/game_overlays.dart';
import 'package:flutter_snake_game/extensions/int_extensions.dart';
import 'package:flutter_snake_game/models/game_config.dart';
import 'package:flutter_snake_game/painters/background_grid.dart';
import 'package:flutter_snake_game/painters/fruit.dart';
import 'package:flutter_snake_game/painters/snake.dart';
import 'package:flutter_snake_game/services/input_service.dart';

class GameService extends FlameGame with SingleGameInstance, KeyboardEvents {
  GameService._();

  static GameService? _instance;
  static GameService get instance {
    _instance ??= GameService._();
    return _instance!;
  }

  GameConfig? _config;
  GameConfig get config {
    _config ??= GameConfig.easy();
    return _config!;
  }

  final _random = Random();

  final GridBackground _background = GridBackground();
  final Fruit _fruit = Fruit();

  late Snake _snake;

  Vector2? _fruitPosition;
  Vector2? get fruitPosition => _fruitPosition;

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
    add(DragInputDetector());
    pauseEngine();
    overlays.add(GameOverlays.startGameMenu.name);

    _initGameElements();

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _background.paint(canvas, _boardSize);
    _fruit.paint(canvas, _boardSize);
    _snake.paint(canvas, _boardSize);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    _timeSinceLastMove += dt;
    if (_timeSinceLastMove < config.moveStep) {
      return;
    }

    _timeSinceLastMove = _timeSinceLastMove % config.moveStep;

    final didEat = _snake.move(_fruitPosition);
    if (didEat) {
      _fruitPosition = null;
      _spawnFruit();
    }
    if (!_snake.checkAlive()) gameOver();

    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final result = InputService.instance.handleKeyInput(event, keysPressed);
    if (result != null) {
      return result;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void pauseGame() {
    if (paused || _gameOver) return;
    pauseEngine();
    overlays.add(GameOverlays.pauseMenu.name);
  }

  void resumeGame() {
    if (!paused || _gameOver) return;
    resumeEngine();
    overlays.removeAll(GameOverlays.values.map((e) => e.name).toList());
  }

  void togglePause() {
    if (paused) {
      resumeGame();
    } else {
      pauseGame();
    }
  }

  void gameOver() {
    _gameOver = true;
    pauseEngine();
    overlays.add(GameOverlays.gameOverMenu.name);
  }

  void startGame(GameConfig config) {
    _reset();
    resumeEngine();
    overlays.removeAll(GameOverlays.values.map((e) => e.name).toList());
  }

  void _reset() {
    InputService.instance.reset();
    _gameOver = false;
    _timeSinceLastMove = 0;
    _fruitPosition = null;
    _initGameElements();
  }

  void _initGameElements() {
    _initSnake();
    _spawnFruit();
  }

  void _initSnake() {
    final start = Vector2(
      (config.gridSize.x ~/ 2).toDouble(),
      (config.gridSize.y ~/ 2).toDouble() -
          (config.snakeStartLength ~/ 2).toDouble(),
    );
    final segments = Queue.of([
      for (int i = 0; i < config.snakeStartLength; i++)
        start + Vector2(0, i.toDouble()),
    ]);

    _snake = Snake(segments: segments, gridSize: config.gridSize);
  }

  void _spawnFruit() {
    if (_fruitPosition != null) return;

    final totalSize = config.gridSize.x * config.gridSize.y;
    final remainingSize = totalSize -_snake.segments.length;

    if (remainingSize <= 0) {
      gameOver();
      return;
    }

    int cellNr =  _random.nextInt(remainingSize.toInt());
    Vector2 fruitPosition = cellNr.toVector2(config.gridSize);

    while (_snake.segments.contains(fruitPosition)) {
      cellNr = (cellNr + 1) % totalSize.toInt();
      fruitPosition = (cellNr).toVector2(config.gridSize);
    }

    _fruitPosition = fruitPosition;
  }
}
