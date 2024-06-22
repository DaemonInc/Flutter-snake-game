import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_game/enums/direction.dart';
import 'package:flutter_snake_game/extensions/vector2_extensions.dart';

class Snake extends CustomPainter {
  Snake({
    required this.segments,
    required this.gridSize,
  }) : assert(segments.length > 1, 'Snake must have at least 2 segments') {
    _direction =
        (segments.elementAt(1) - (segments.first)).asDirection ?? Direction.up;
  }

  final Iterable<Vector2> segments;
  final Vector2 gridSize;

  late Direction _direction;

  /// Moves the snake by one segment in its current direction
  void move([Direction? direction]) {
    if (direction == null || direction == _direction.inverted) {
      _direction = ((segments.first) - segments.elementAt(1)).asDirection ??
          Direction.up;
    } else {
      _direction = direction;
    }

    for (int i = segments.length - 1; i > 0; i--) {
      segments.elementAt(i).setFrom(segments.elementAt(i - 1));
    }
    segments.elementAt(0).setFrom(segments.elementAt(0) + _direction.vector);
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

  @override
  void paint(Canvas canvas, Size size) {
    final segmentSize = Size(
      size.width / gridSize.x,
      size.height / gridSize.y,
    );
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
