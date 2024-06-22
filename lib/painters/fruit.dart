import 'package:flutter/material.dart';
import 'package:flutter_snake_game/services/game_service.dart';

class Fruit extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fruitPosition = GameService.instance.fruitPosition;
    if (fruitPosition == null) return;

    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final segmentSize = Size(
      size.width / GameService.instance.config.gridSize.width,
      size.height / GameService.instance.config.gridSize.height,
    );

    canvas.drawCircle(
      Offset(
        (fruitPosition.x + 0.5) * segmentSize.width,
        (fruitPosition.y + 0.5) * segmentSize.height,
      ),
      segmentSize.shortestSide * 0.4,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
