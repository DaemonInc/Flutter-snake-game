import 'package:flame/extensions.dart';

extension IntExtensions on int {
  Vector2 toVector2(Vector2 max) =>
      Vector2(this % max.x, (this ~/ max.x).toDouble());
}
