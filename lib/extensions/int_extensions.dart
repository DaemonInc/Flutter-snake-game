import 'package:flame/extensions.dart';

extension IntExtensions on int {
  /// Converts an integer to a [Vector2] coordinate
  Vector2 toVector2(double maxWidth) =>
      Vector2(this % maxWidth, (this ~/ maxWidth).toDouble());
}
