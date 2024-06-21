import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_snake_game/models/game_config.dart';

class SnakeGame extends FlameGame with SingleGameInstance {
  SnakeGame({
    required this.config,
    required this.boardSize,
  });

  final GameConfig config;
  final Offset boardSize;

  final snake = Queue<Offset>();

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  FutureOr<void> onLoad() {
    final start = config.gridSize ~/ 2 -
        Offset(0, (config.snakeStartLength ~/ 2).toDouble());

    for (int i = 0; i < config.snakeStartLength; i++) {
      snake.addLast(start + Offset(0, i.toDouble()));
    }

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final segmentSize = Size(
      boardSize.dx / config.gridSize.dx,
      boardSize.dy / config.gridSize.dy,
    );

    for (final segment in snake) {
      canvas.drawRect(
        Rect.fromLTWH(
          segment.dx * segmentSize.width,
          segment.dy * segmentSize.height,
          segmentSize.width,
          segmentSize.height,
        ),
        Paint()..color = Colors.green,
      );
    }
  }

  @override
  void update(double dt) {
    // TODO: implement update
  }
}
