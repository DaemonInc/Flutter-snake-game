import 'package:flame/extensions.dart';

class GameConfig {
  const GameConfig({
    required this.snakeStartLength,
    required double gameSpeed,
    required this.gridSize,
  }) : _gameSpeed = gameSpeed;

  factory GameConfig.small() {
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

  /// The size of the game grid
  final Size gridSize;
  /// The starting length of the snake
  final int snakeStartLength;
  final double _gameSpeed;

  /// The aspect ratio of the game grid
  double get aspectRatio => gridSize.aspectRatio;
  /// Time in seconds between each move
  double get moveStep => 1 / _gameSpeed;
}
