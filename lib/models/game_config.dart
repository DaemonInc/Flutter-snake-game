import 'package:flutter/material.dart';

class GameConfig {
  const GameConfig({
    required this.snakeStartLength,
    required this.gameSpeed,
    required this.gridSize,
  });

  final Size gridSize;
  final int snakeStartLength;
  final double gameSpeed;

  double get aspectRatio => gridSize.width / gridSize.height;
}
