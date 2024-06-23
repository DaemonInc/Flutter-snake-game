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

  final List<Vector2> _fruit = [];

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

    if (fruitPosition != null && segments.first == fruitPosition) {
      _fruit.add(fruitPosition);
      segments.addLast(segments.last.clone());
      return true;
    }

    _fruit.removeWhere((fruit) => !segments.contains(fruit));

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
    _drawBody(canvas, segmentSize);
    _drawFruit(canvas, segmentSize);
    _drawEyes(canvas, segmentSize);
  }

  void _drawBody(Canvas canvas, Size segmentSize) {
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
          final previousSegment = segments.elementAt(i - 1);
          _drawBend(
            bodyPath,
            previousSegment,
            segment,
            nextSegment,
            segmentSize,
          );
        } else {
          bodyPath.lineTo(
            (segment.x + 0.5) * segmentSize.width,
            (segment.y + 0.5) * segmentSize.height,
          );
        }
        shouldBend = nextShouldBend;
      } else if (i < segments.length - 1) {
        if (shouldBend) {
          final nextSegment = segments.elementAt(i + 1);
          final previousSegment = segments.elementAt(i - 1);
          _drawBend(
            bodyPath,
            previousSegment,
            segment,
            nextSegment,
            segmentSize,
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

  void _drawBend(
    Path bodyPath,
    Vector2 previousSegment,
    Vector2 currentSegment,
    Vector2 nextSegment,
    Size segmentSize,
  ) {
    final currentPosition = (previousSegment + currentSegment) / 2;
    currentPosition.lerp(currentSegment, 0.2);

    bodyPath.lineTo(
      (currentPosition.x + 0.5) * segmentSize.width,
      (currentPosition.y + 0.5) * segmentSize.height,
    );

    final endPosition = (nextSegment + currentSegment) / 2;
    endPosition.lerp(currentSegment, 0.2);

    final endOffset = Offset(
      (endPosition.x + 0.5) * segmentSize.width,
      (endPosition.y + 0.5) * segmentSize.height,
    );

    final clockwise = previousSegment.y < currentSegment.y &&
            nextSegment.x < currentSegment.x ||
        previousSegment.x > currentSegment.x &&
            nextSegment.y < currentSegment.y ||
        previousSegment.y > currentSegment.y &&
            nextSegment.x > currentSegment.x ||
        previousSegment.x < currentSegment.x &&
            nextSegment.y > currentSegment.y;

    bodyPath.arcToPoint(
      endOffset,
      radius: Radius.circular(segmentSize.width * 0.4),
      largeArc: false,
      clockwise: clockwise,
    );
  }

  void _drawFruit(Canvas canvas, Size segmentSize) {
    final fruitPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.redAccent;

    for (final fruit in _fruit) {
      if (segments.first == fruit || segments.last == fruit) continue;
      canvas.drawCircle(
        Offset(
          (fruit.x + 0.5) * segmentSize.width,
          (fruit.y + 0.5) * segmentSize.height,
        ),
        min(segmentSize.width, segmentSize.height) * 0.25,
        fruitPaint,
      );
    }
  }

  void _drawEyes(Canvas canvas, Size segmentSize) {
    final eyes = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;
    final horizontal =
        _direction == Direction.left || _direction == Direction.right;

    canvas.drawCircle(
      Offset(
        (segments.first.x + (horizontal ? 0.5 : 0.35)) * segmentSize.width,
        (segments.first.y + (!horizontal ? 0.5 : 0.35)) * segmentSize.height,
      ),
      min(segmentSize.width, segmentSize.height) * 0.15 / 2,
      eyes,
    );
    canvas.drawCircle(
      Offset(
        (segments.first.x + (horizontal ? 0.5 : 0.65)) * segmentSize.width,
        (segments.first.y + (!horizontal ? 0.5 : 0.65)) * segmentSize.height,
      ),
      min(segmentSize.width, segmentSize.height) * 0.15 / 2,
      eyes,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
