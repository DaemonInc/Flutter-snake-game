import 'package:flame/extensions.dart';

class GameConfig {
  const GameConfig({
    required this.snakeStartLength,
    required double gameSpeed,
    required this.gridSize,
  }) : _gameSpeed = gameSpeed;

  factory GameConfig.easy() {
    return const GameConfig(
      snakeStartLength: 3,
      gameSpeed: 2,
      gridSize: Size(7, 5),
    );
  }

  factory GameConfig.normal() {
    return const GameConfig(
      snakeStartLength: 5,
      gameSpeed: 3,
      gridSize: Size(15, 15),
    );
  }

  final Size gridSize;
  final int snakeStartLength;
  final double _gameSpeed;

  double get aspectRatio => gridSize.aspectRatio;
  double get moveStep => 1 / _gameSpeed;
}
