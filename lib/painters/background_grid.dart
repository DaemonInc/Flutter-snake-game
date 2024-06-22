import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class GridBackground extends CustomPainter {
  GridBackground({required this.gridSize});

  final Vector2 gridSize;

  @override
  void paint(Canvas canvas, Size size) {
    final border = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final gridLines = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        size.toRect(),
        const Radius.circular(6),
      ),
      border,
    );

    for (int index = 1; index < gridSize.x; index++) {
      final x = size.width * (index / gridSize.x);
      final p1 = Offset(x, 0);
      final p2 = Offset(x, size.height);

      canvas.drawLine(p1, p2, gridLines);
    }

    for (int index = 1; index < gridSize.y; index++) {
      final y = size.height * (index / gridSize.y);
      final p1 = Offset(0, y);
      final p2 = Offset(size.width, y);

      canvas.drawLine(p1, p2, gridLines);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
