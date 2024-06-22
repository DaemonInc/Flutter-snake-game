import 'package:flame/extensions.dart';

class GameConfig {
  const GameConfig({
    required this.snakeStartLength,
    required double gameSpeed,
    required this.gridSize,
  }) : _gameSpeed = gameSpeed;

  factory GameConfig.normal() {
    return GameConfig(
      snakeStartLength: 5,
      gameSpeed: 2,
      gridSize: Vector2(15, 15),
    );
  }

  final Vector2 gridSize;
  final int snakeStartLength;
  final double _gameSpeed;

  double get aspectRatio => gridSize.r;
  double get moveStep => 1 / _gameSpeed;
}
