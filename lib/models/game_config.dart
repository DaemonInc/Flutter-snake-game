import 'package:flutter/material.dart';

class GameConfig {
  const GameConfig({
    required this.snakeStartLength,
    required this.gameSpeed,
    required this.gridSize,
  });

  final Offset gridSize;
  final int snakeStartLength;
  final double gameSpeed;

  double get aspectRatio => gridSize.dx / gridSize.dy;
}
