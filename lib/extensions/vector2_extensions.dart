import 'package:flame/extensions.dart';
import 'package:flutter_snake_game/enums/direction.dart';

extension Vector2Extensions on Vector2 {
  Direction? get asDirection {
    if (length == 0) return null;

    final dotUp = normalized().dot(Direction.up.vector);

    if (dotUp >= 0.5) {
      return Direction.up;
    } else if (dotUp <= -0.5) {
      return Direction.down;
    }

    final dotRight = dot(Vector2(1, 0));

    if (dotRight >= 0.5) {
      return Direction.right;
    } else if (dotRight <= -0.5) {
      return Direction.left;
    }

    return null;
  }
}
