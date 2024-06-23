import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Paints a fruit
class Fruit extends CustomPainter {
  Fruit({
    required this.gridSize,
    required this.getFruitPosition,
  });

  final Size gridSize;
  final Vector2? Function() getFruitPosition;

  @override
  void paint(Canvas canvas, Size size) {
    final fruitPosition = getFruitPosition();
    if (fruitPosition == null) return;

    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final segmentSize = Size(
      size.width / gridSize.width,
      size.height / gridSize.height,
    );

    canvas.drawCircle(
      Offset(
        (fruitPosition.x + 0.5) * segmentSize.width,
        (fruitPosition.y + 0.5) * segmentSize.height,
      ),
      segmentSize.shortestSide * 0.3,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
