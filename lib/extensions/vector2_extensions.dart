import 'package:flame/extensions.dart';
import 'package:flutter_snake_game/enums/direction.dart';

extension Vector2Extensions on Vector2 {
  /// Converts a [Vector2] to a [Direction]
  /// Defaults to [Direction.up] if the vector is zero
  Direction get asDirection {
    if (length == 0) return Direction.up;

    final dotUp = normalized().dot(Direction.up.vector2);

    if (dotUp >= 0.5) {
      return Direction.up;
    } else if (dotUp <= -0.5) {
      return Direction.down;
    }

    final dotRight = dot(Vector2(1, 0));

    return dotRight >= 0.5 ? Direction.right : Direction.left;
  }
}
