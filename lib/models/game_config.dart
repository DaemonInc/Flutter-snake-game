import 'package:flame/extensions.dart';

class GameConfig {
  const GameConfig({
    required this.snakeStartLength,
    required double gameSpeed,
    required this.gridSize,
  }) : _gameSpeed = gameSpeed;

  factory GameConfig.portrait() {
    return const GameConfig(
      snakeStartLength: 3,
      gameSpeed: 3,
      gridSize: Size(7, 10),
    );
  }

  factory GameConfig.landscape() {
    return const GameConfig(
      snakeStartLength: 4,
      gameSpeed: 3,
      gridSize: Size(12, 8),
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
