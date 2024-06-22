import 'package:flutter/material.dart';

class GameConfig {
  const GameConfig({
    required this.snakeStartLength,
    required double gameSpeed,
    required this.gridSize,
  }) : _gameSpeed = gameSpeed;

  final Size gridSize;
  final int snakeStartLength;
  final double _gameSpeed;

  double get aspectRatio => gridSize.width / gridSize.height;
  double get moveStep => 1 / _gameSpeed;
}
