import 'dart:collection';
import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_game/enums/direction.dart';
import 'package:flutter_snake_game/extensions/vector2_extensions.dart';
import 'package:flutter_snake_game/services/game_service.dart';
import 'package:flutter_snake_game/services/input_service.dart';

/// A snake that can move around the screen
class Snake extends CustomPainter {
  Snake({
    required this.segments,
    required this.gridSize,
  }) : assert(segments.length > 1, 'Snake must have at least 2 segments') {
    _direction = (segments.first - segments.elementAt(1)).asDirection;
    _previousTailPosition = segments.last.clone() - _direction.vector2;
  }

  final Queue<Vector2> segments;
  final Size gridSize;

  late Direction _direction;

  final List<Vector2> _fruit = [];

  double _stepPercentage = 0;
  Size _segmentSize = Size.zero;
  late Vector2 _previousTailPosition;

  final _bodyWidth = 0.7;

  late final _bodyPaint = Paint()
    ..strokeWidth = min(_segmentSize.width, _segmentSize.height) * _bodyWidth
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..color = Colors.green;
  final _eyesPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.red;
  late final _deadEyesPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = min(_segmentSize.width, _segmentSize.height) * 0.04
    ..color = Colors.red;

  /// Moves the snake by one segment in its current direction
  bool move(Vector2? fruitPosition) {
    _previousTailPosition = segments.last.clone();
    final direction = InputService.instance.currentDirection;

    if (direction == null || direction == _direction.inverted) {
      _direction = (segments.first - segments.elementAt(1)).asDirection;
    } else {
      _direction = direction;
    }

    for (int i = segments.length - 1; i > 0; i--) {
      segments.elementAt(i).setFrom(segments.elementAt(i - 1));
    }
    segments.first.setFrom(segments.first + _direction.vector2);

    bool didEat = false;

    if (fruitPosition != null && segments.first == fruitPosition) {
      _fruit.add(fruitPosition);
      segments.addLast(segments.last.clone());
      didEat = true;
    }

    _fruit.removeWhere((fruit) => !segments.contains(fruit));

    return didEat;
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

  /// Paints the snake to the canvas
  ///
  /// The [canvas] is the canvas to paint on
  ///
  /// The [size] is the size of the game board
  ///
  /// The [stepPercentage] is a value between 0 and 1 that represents the
  /// percentage of time passed until the next move
  void render(Canvas canvas, Size size, double stepPercentage) {
    _stepPercentage = stepPercentage;
    _segmentSize = Size(
      size.width / gridSize.width,
      size.height / gridSize.height,
    );
    paint(canvas, size);
  }

  @override
  @protected
  void paint(Canvas canvas, Size size) {
    _drawBody(canvas);
    _drawFruit(canvas);
    _drawEyes(canvas);
  }

  void _drawBody(Canvas canvas) {
    final start = _getOffset(segments.first);
    Path bodyPath = Path()..moveTo(start.dx, start.dy);

    bool shouldBend = false;

    for (int i = 0; i < segments.length; i++) {
      final segment = segments.elementAt(i);
      final segmentType = i == 0
          ? _SegmentType.head
          : i == segments.length - 1
              ? _SegmentType.tail
              : _SegmentType.body;

      bool nextShouldBend = false;

      if (i == segments.length - 1) {
        final direction = (segments.elementAt(i - 1) - segment).asDirection;
        _drawStraight(
          segment,
          direction,
          segmentType,
          bodyPath,
        );
        break;
      }

      final nextSegment = segments.elementAt(i + 1);
      final direction = (segment - nextSegment).asDirection;

      if (i < segments.length - 2) {
        final segmentPlusTwo = segments.elementAt(i + 2);
        nextShouldBend =
            segment.x != segmentPlusTwo.x && segment.y != segmentPlusTwo.y;
      }

      if (shouldBend) {
        _drawBend(
          bodyPath,
          segment,
        );
      } else {
        _drawStraight(
          segment,
          direction,
          segmentType,
          bodyPath,
        );
      }

      shouldBend = nextShouldBend;
    }

    canvas.drawPath(bodyPath, _bodyPaint);
  }

  void _drawStraight(
    Vector2 segment,
    Direction direction,
    _SegmentType segmentType,
    Path bodyPath,
  ) {
    Vector2 end = segment;

    switch (segmentType) {
      case _SegmentType.head:
        end = segment - direction.vector2;
        final start = end.clone();
        start.lerp(segment, _stepPercentage);
        final startOffset = _getOffset(start);
        bodyPath.moveTo(
          startOffset.dx,
          startOffset.dy,
        );
        break;
      case _SegmentType.body:
        if (segment == segments.last) return;
        end = segment - direction.vector2;
        break;
      case _SegmentType.tail:
        final tailStart = _getOffset(segment);
        bodyPath.lineTo(
          tailStart.dx,
          tailStart.dy,
        );
        if (segment == _previousTailPosition) {
          return;
        } else {
          direction = (_previousTailPosition - segment).asDirection;
        }

        bodyPath.moveTo(tailStart.dx, tailStart.dy);
        end = segment + direction.vector2;
        end.lerp(segment, _stepPercentage);
        break;
    }

    final endOffset = _getOffset(end);

    bodyPath.lineTo(
      endOffset.dx,
      endOffset.dy,
    );
  }

  void _drawBend(
    Path bodyPath,
    Vector2 currentSegment,
  ) {
    final center = _getOffset(currentSegment);
    bodyPath.lineTo(center.dx, center.dy);
    bodyPath.moveTo(center.dx, center.dy);
  }

  void _drawFruit(Canvas canvas) {
    final fruitPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red.withOpacity(0.7);

    for (final fruit in _fruit) {
      if (segments.first == fruit) continue;
      canvas.drawCircle(
        Offset(
          (fruit.x + 0.5) * _segmentSize.width,
          (fruit.y + 0.5) * _segmentSize.height,
        ),
        min(_segmentSize.width, _segmentSize.height) * 0.25,
        fruitPaint,
      );
    }
  }

  void _drawEyes(Canvas canvas) {
    final horizontal =
        _direction == Direction.left || _direction == Direction.right;

    final position = segments.first - _direction.vector2;
    position.lerp(segments.first, _stepPercentage);

    final isDead = GameService.instance.isDead;

    final leftEye = _getOffset(position) +
        Offset(
          (horizontal ? 0 : _bodyWidth * 0.2) * _segmentSize.width,
          (!horizontal ? 0 : _bodyWidth * 0.2) * _segmentSize.height,
        );
    final rightEye = _getOffset(position) +
        Offset(
          (horizontal ? 0 : _bodyWidth * -0.2) * _segmentSize.width,
          (!horizontal ? 0 : _bodyWidth * -0.2) * _segmentSize.height,
        );

    if (isDead) {
      final eyeSize = min(_segmentSize.width, _segmentSize.height) * 0.06;
      final eyePath = Path();

      eyePath
        ..moveTo(
          leftEye.dx + eyeSize,
          leftEye.dy + eyeSize,
        )
        ..lineTo(
          leftEye.dx - eyeSize,
          leftEye.dy - eyeSize,
        )
        ..moveTo(
          leftEye.dx - eyeSize,
          leftEye.dy + eyeSize,
        )
        ..lineTo(
          leftEye.dx + eyeSize,
          leftEye.dy - eyeSize,
        );

      eyePath
        ..moveTo(
          rightEye.dx + eyeSize,
          rightEye.dy + eyeSize,
        )
        ..lineTo(
          rightEye.dx - eyeSize,
          rightEye.dy - eyeSize,
        )
        ..moveTo(
          rightEye.dx - eyeSize,
          rightEye.dy + eyeSize,
        )
        ..lineTo(
          rightEye.dx + eyeSize,
          rightEye.dy - eyeSize,
        );

      canvas.drawPath(eyePath, _deadEyesPaint);
    } else {
      final eyeSize = min(_segmentSize.width, _segmentSize.height) * 0.08;
      canvas.drawCircle(
        leftEye,
        eyeSize,
        _eyesPaint,
      );
      canvas.drawCircle(
        rightEye,
        eyeSize,
        _eyesPaint,
      );
    }
  }

  Offset _getOffset(Vector2 position) {
    return Offset(
      (position.x + 0.5) * _segmentSize.width,
      (position.y + 0.5) * _segmentSize.height,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

enum _SegmentType { head, body, tail }
