import 'dart:collection';
import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_game/enums/direction.dart';
import 'package:flutter_snake_game/extensions/vector2_extensions.dart';
import 'package:flutter_snake_game/services/game_service.dart';
import 'package:flutter_snake_game/services/input_service.dart';

class Snake extends CustomPainter {
  Snake({
    required this.segments,
    required this.gridSize,
  }) : assert(segments.length > 1, 'Snake must have at least 2 segments') {
    _direction =
        (segments.elementAt(1) - (segments.first)).asDirection ?? Direction.up;
  }

  final Queue<Vector2> segments;
  final Size gridSize;

  late Direction _direction;

  /// Moves the snake by one segment in its current direction
  bool move(Vector2? fruitPosition) {
    final direction = InputService.instance.currentDirection;

    if (direction == null || direction == _direction.inverted) {
      _direction = ((segments.first) - segments.elementAt(1)).asDirection ??
          Direction.up;
    } else {
      _direction = direction;
    }

    for (int i = segments.length - 1; i > 0; i--) {
      segments.elementAt(i).setFrom(segments.elementAt(i - 1));
    }
    segments.first.setFrom(segments.first + _direction.vector);

    if ((segments.first) == fruitPosition) {
      segments.addLast(segments.last.clone());
      return true;
    }
    return false;
  }

  /// Checks if the snake is out of bounds
  bool _checkOutOfBounds() {
    final bounds = GameService.instance.config.gridSize;
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
  bool checkAlive() {
    return !_checkOutOfBounds() && !_checkSelfCollision();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final segmentSize = Size(
      size.width / gridSize.width,
      size.height / gridSize.height,
    );
    final bodyPaint = Paint()
      ..strokeWidth = min(segmentSize.width, segmentSize.height) * 0.7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.green;

    Path bodyPath = Path()
      ..moveTo(
        (segments.first.x + 0.5) * segmentSize.width,
        (segments.first.y + 0.5) * segmentSize.height,
      );

    bool shouldBend = false;

    for (int i = 0; i < segments.length; i++) {
      final segment = segments.elementAt(i);
      if (i < segments.length - 2) {
        final nextSegment = segments.elementAt(i + 1);
        final segmentPlusTwo = segments.elementAt(i + 2);
        final nextShouldBend =
            segment.x != segmentPlusTwo.x && segment.y != segmentPlusTwo.y;
        final inBetween = (segment + nextSegment) / 2;

        if (nextShouldBend && !shouldBend) {
          bodyPath.lineTo(
            (inBetween.x + 0.5) * segmentSize.width,
            (inBetween.y + 0.5) * segmentSize.height,
          );
        } else if (shouldBend) {
          bodyPath.conicTo(
            (segment.x + 0.5) * segmentSize.width,
            (segment.y + 0.5) * segmentSize.height,
            (inBetween.x + 0.5) * segmentSize.width,
            (inBetween.y + 0.5) * segmentSize.height,
            10,
          );
        } else {
          bodyPath.lineTo(
            (segment.x + 0.5) * segmentSize.width,
            (segment.y + 0.5) * segmentSize.height,
          );
        }
        shouldBend = nextShouldBend;
      } else if (i < segments.length - 1) {
        final nextSegment = segments.elementAt(i + 1);
        final inBetween = (segment + nextSegment) / 2;
        if (shouldBend) {
          bodyPath.conicTo(
            (segment.x + 0.5) * segmentSize.width,
            (segment.y + 0.5) * segmentSize.height,
            (inBetween.x + 0.5) * segmentSize.width,
            (inBetween.y + 0.5) * segmentSize.height,
            10,
          );
        } else {
          bodyPath.lineTo(
            (segment.x + 0.5) * segmentSize.width,
            (segment.y + 0.5) * segmentSize.height,
          );
        }
        shouldBend = false;
      } else {
        bodyPath.lineTo(
          (segment.x + 0.5) * segmentSize.width,
          (segment.y + 0.5) * segmentSize.height,
        );
      }
    }

    canvas.drawPath(bodyPath, bodyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
