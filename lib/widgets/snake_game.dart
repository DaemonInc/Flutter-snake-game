import 'dart:async';
import 'dart:collection';

import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter_snake_game/models/game_config.dart';
import 'package:flutter_snake_game/painters/background_grid.dart';
import 'package:flutter_snake_game/painters/snake.dart';

class SnakeGame extends FlameGame with SingleGameInstance {
  SnakeGame({
    required this.config,
    required this.boardSize,
  });

  final GameConfig config;
  final Size boardSize;

  final snake = Queue<Offset>();

  @override
  Color backgroundColor() => const Color(0x00000000);

  late final _background = GridBackground(gridSize: config.gridSize);
  late final Snake _snake;

  double _timeSinceLastMove = 0;

  @override
  FutureOr<void> onLoad() {
    final start = (config.gridSize ~/ 2).toVector2() -
        Vector2(0, (config.snakeStartLength ~/ 2).toDouble());
    final segments = [
      for (int i = 0; i < config.snakeStartLength; i++)
        start + Vector2(0, i.toDouble()),
    ];

    final segmentSize = Size(
      boardSize.width / config.gridSize.width,
      boardSize.height / config.gridSize.height,
    );

    _snake = Snake(segments: segments, segmentSize: segmentSize);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    _background.paint(canvas, boardSize);
    _snake.paint(canvas, boardSize);
    super.render(canvas);
  }

  @override
  void update(double dt) {
    _timeSinceLastMove += dt;
    if (_timeSinceLastMove < config.moveStep) {
      return;
    }

    _timeSinceLastMove = _timeSinceLastMove % config.moveStep;

    _snake.move();
    final alive = _snake.checkAlive(boardSize);
    print('Snake is alive: $alive');
    super.update(dt);
  }
}
