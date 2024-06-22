import 'package:flame/extensions.dart';

class GameConfig {
  const GameConfig({
    required this.snakeStartLength,
    required double gameSpeed,
    required this.gridSize,
  }) : _gameSpeed = gameSpeed;

  final Vector2 gridSize;
  final int snakeStartLength;
  final double _gameSpeed;

  double get aspectRatio => gridSize.r;
  double get moveStep => 1 / _gameSpeed;
}
