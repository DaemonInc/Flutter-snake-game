import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_game/components/drag_input_detector.dart';
import 'package:flutter_snake_game/enums/game_overlays.dart';
import 'package:flutter_snake_game/extensions/int_extensions.dart';
import 'package:flutter_snake_game/mixins/boardsize_mixin.dart';
import 'package:flutter_snake_game/models/game_config.dart';
import 'package:flutter_snake_game/painters/background_grid.dart';
import 'package:flutter_snake_game/painters/fruit.dart';
import 'package:flutter_snake_game/painters/snake.dart';
import 'package:flutter_snake_game/services/input_service.dart';
import 'package:flutter_snake_game/services/score_service.dart';

/// The main game service
class GameService extends FlameGame
    with SingleGameInstance, KeyboardEvents, BoardSize {
  GameService._();

  final _inputService = InputService.instance;
  final _scoreService = ScoreService.instance;

  static GameService? _instance;
  static GameService get instance {
    _instance ??= GameService._();
    return _instance!;
  }

  GameConfig? _config;
  @override
  GameConfig get config {
    _config ??= GameConfig.small();
    return _config!;
  }

  late GridBackground _background = GridBackground(gridSize: config.gridSize);
  late Fruit _fruit = Fruit(
    gridSize: config.gridSize,
    getFruitPosition: () => fruitPosition,
  );

  late Snake _snake;

  Vector2? _fruitPosition;
  Vector2? get fruitPosition => _fruitPosition;

  double _timeSinceLastMove = 0;

  bool _isGameOver = false;

  bool _isDead = false;
  bool get isDead => _isDead;

  int get score => _scoreService.score.value;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  FutureOr<void> onLoad() async {
    await FlameAudio.audioCache.loadAll(['game_over.mp3', 'eat.mp3']);
    add(DragInputDetector(onDragEnd: _inputService.handleDragInput));
    pauseEngine();
    overlays.add(GameOverlays.startGameMenu.name);

    _initGameElements();

    return super.onLoad();
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

  @override
  void render(Canvas canvas) {
    canvas.translate(centerOffset.dx, centerOffset.dy);
    _background.paint(canvas, boardSize);
    _fruit.paint(canvas, boardSize);
    _snake.render(
      canvas,
      boardSize,
      _timeSinceLastMove / config.moveStep,
    );
    super.render(canvas);
  }

  @override
  void update(double dt) {
    _timeSinceLastMove += dt;
    if (_timeSinceLastMove < config.moveStep) {
      return;
    }
    _timeSinceLastMove = _timeSinceLastMove % config.moveStep;

    _moveSnake();
    _checkGameOver();

    super.update(dt);
  }

  void _checkGameOver() {
    if (!_snake.checkAlive()) {
      Future.delayed(Duration(
        milliseconds: (0.5 * config.moveStep * 1000).toInt(),
      )).then((_) {
        _isDead = true;
        gameOver();
      });
    }
  }

  void _moveSnake() {
    final didEat = _snake.move(
      _fruitPosition,
      _inputService.currentDirection,
    );
    if (didEat) {
      _scoreService.increment();
      FlameAudio.play('eat.mp3', volume: 0.2);
      _fruitPosition = null;
      _spawnFruit();
    }
  }

  void pauseGame() {
    if (paused || _isGameOver) return;
    pauseEngine();
    overlays.add(GameOverlays.pauseMenu.name);
  }

  void resumeGame() {
    if (!paused || _isGameOver) return;
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

  AudioPlayer? _gameOverAudio;

  /// Ends the game
  Future<void> gameOver() async {
    _isGameOver = true;
    pauseEngine();
    _gameOverAudio?.stop();
    if (isDead) {
      _gameOverAudio = await FlameAudio.play('game_over.mp3', volume: 0.3);
    }
    overlays.add(GameOverlays.gameOverMenu.name);
  }

  void startGame([GameConfig? config]) {
    if (config != null) {
      _config = config;
      _background = GridBackground(gridSize: config.gridSize);
    }
    _reset();
    resumeEngine();
  }

  void _reset() {
    _inputService.reset();
    _scoreService.reset();

    _gameOverAudio?.stop();
    _isDead = false;
    _isGameOver = false;
    _timeSinceLastMove = 0;
    _fruitPosition = null;

    overlays.removeAll(GameOverlays.values.map((e) => e.name).toList());
    _initGameElements();
  }

  void _initGameElements() {
    _initSnake();
    _initFruit();
  }

  void _initSnake() {
    final start = Vector2(
      (config.gridSize.width ~/ 2).toDouble(),
      (config.gridSize.height ~/ 2).toDouble() -
          (config.snakeStartLength ~/ 2).toDouble(),
    );
    final segments = Queue.of([
      for (int i = 0; i < config.snakeStartLength; i++)
        start + Vector2(0, i.toDouble()),
    ]);

    _snake = Snake(
      segments: segments,
      gridSize: config.gridSize,
      isDead: () => isDead,
    );
  }

  void _initFruit() {
    _fruitPosition = null;
    _fruit = Fruit(
      gridSize: config.gridSize,
      getFruitPosition: () => fruitPosition,
    );
    _spawnFruit();
  }

  final _random = Random();
  void _spawnFruit() {
    if (_fruitPosition != null) return;

    final totalSize = config.gridSize.width * config.gridSize.height;
    final remainingSize = totalSize - _snake.segments.length;

    if (remainingSize <= 0) {
      gameOver();
      return;
    }

    int cellNr = _random.nextInt(remainingSize.toInt());
    Vector2 fruitPosition = cellNr.toVector2(config.gridSize.width);

    while (_snake.segments.contains(fruitPosition)) {
      cellNr = (cellNr + 1) % totalSize.toInt();
      fruitPosition = (cellNr).toVector2(config.gridSize.width);
    }

    _fruitPosition = fruitPosition;
  }
}
