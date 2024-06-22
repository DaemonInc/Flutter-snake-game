import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Snake extends CustomPainter {
  Snake({
    required this.segments,
    required this.segmentSize,
  });

  final Iterable<Vector2> segments;
  final Size segmentSize;

  @override
  void paint(Canvas canvas, Size size) {
    assert(segments.length > 1, 'Snake must have at least 2 segments');
    final bodyPaint = Paint()
      ..strokeWidth = min(segmentSize.width, segmentSize.height) * 0.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..color = Colors.green;

    Vector2 direction = (segments.elementAt(1) - (segments.first));

    Path bodyPath = Path()
      ..moveTo(
        (segments.first.x + 0.5) * segmentSize.width,
        (segments.first.y + 0.5) * segmentSize.height,
      );

    for (int i = 0; i < segments.length; i++) {
      final segment = segments.elementAt(i);

      if (i != 0 && i < segments.length - 1) {
        direction = (segments.elementAt(i + 1) - segments.elementAt(i - 1));
        direction *= 1 / direction.length2;
      } else if (i == segments.length - 1) {
        direction = (segments.elementAt(i) - segments.elementAt(i - 1));
      }

      bodyPath.lineTo(
        (segment.x + 0.5) * segmentSize.width,
        (segment.y + 0.5) * segmentSize.height,
      );
    }

    canvas.drawPath(bodyPath, bodyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
