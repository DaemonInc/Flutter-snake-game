import 'package:flame/extensions.dart';

enum Direction {
  up,
  down,
  left,
  right,
  ;

  Vector2 get vector {
    switch (this) {
      case Direction.up:
        return Vector2(0, -1);
      case Direction.down:
        return Vector2(0, 1);
      case Direction.left:
        return Vector2(-1, 0);
      case Direction.right:
        return Vector2(1, 0);
    }
  }

  Direction get inverted {
    switch (this) {
      case Direction.up:
        return Direction.down;
      case Direction.down:
        return Direction.up;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
    }
  }
}
