import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Snake extends CustomPainter {
  Snake({
    required this.segments,
    required this.segmentSize,
  }) : assert(segments.length > 1, 'Snake must have at least 2 segments') {
    _direction = (segments.elementAt(1) - (segments.first));
  }

  final Iterable<Vector2> segments;
  final Size segmentSize;

  late Vector2 _direction;

  /// Moves the snake by one segment in its current direction
  void move() {
    _direction = (segments.elementAt(1) - (segments.first));
    for (int i = segments.length - 1; i > 0; i--) {
      segments.elementAt(i).setFrom(segments.elementAt(i - 1));
    }
    segments
        .elementAt(0)
        .setFrom(segments.elementAt(0) + _direction.inverted());
  }

  /// Checks if the snake is out of bounds
  bool _checkOutOfBounds(Size bounds) {
    final head = segments.first;
    return head.x < 0 ||
        head.x >= bounds.width ||
        head.y < 0 ||
        head.y >= bounds.height;
  }

  /// Checks if the snake has collided with itself
  /// (i.e. if the head is in the same position as any other segment)
  bool _checkSelfCollision() {
    final head = segments.first;
    for (int i = 1; i < segments.length; i++) {
      if (head == segments.elementAt(i)) {
        return true;
      }
    }
    return false;
  }

  /// Checks if the snake is alive
  bool checkAlive(Size bounds) {
    return !_checkOutOfBounds(bounds) && !_checkSelfCollision();
  }

  void reset() {}

  @override
  void paint(Canvas canvas, Size size) {
    assert(segments.length > 1, 'Snake must have at least 2 segments');
    final bodyPaint = Paint()
      ..strokeWidth = min(segmentSize.width, segmentSize.height) * 0.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..color = Colors.green;

    Path bodyPath = Path()
      ..moveTo(
        (segments.first.x + 0.5) * segmentSize.width,
        (segments.first.y + 0.5) * segmentSize.height,
      );

    for (int i = 0; i < segments.length; i++) {
      final segment = segments.elementAt(i);

      if (i != 0 && i < segments.length - 1) {
        _direction = (segments.elementAt(i + 1) - segments.elementAt(i - 1));
        _direction *= 1 / _direction.length2;
      } else if (i == segments.length - 1) {
        _direction = (segments.elementAt(i) - segments.elementAt(i - 1));
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
