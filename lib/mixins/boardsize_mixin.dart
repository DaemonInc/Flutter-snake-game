import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_snake_game/models/game_config.dart';

mixin BoardSize on Component {
  late Size _boardSize;
  /// The size of the board
  Size get boardSize => _boardSize;

  Offset _centerOffset = Offset.zero;
  /// The offset to center the board on the screen
  Offset get centerOffset => _centerOffset;

  GameConfig get config;

  @override
  void onGameResize(Vector2 size) {
    final cellSize =
        min(size.x / config.gridSize.width, size.y / config.gridSize.height);
    _boardSize = Size(
        cellSize * config.gridSize.width, cellSize * config.gridSize.height);
    _centerOffset = Offset(
      (size.x - _boardSize.width) / 2,
      (size.y - _boardSize.height) / 2,
    );
    super.onGameResize(size);
  }
}
