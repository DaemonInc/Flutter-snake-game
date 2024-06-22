import 'package:flame/extensions.dart';

extension IntExtensions on int {
  Vector2 toVector2(double maxWidth) =>
      Vector2(this % maxWidth, (this ~/ maxWidth).toDouble());
}
