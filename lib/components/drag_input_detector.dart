import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_snake_game/services/input_service.dart';

/// Handles drag input and sends it to the [InputService]
class DragInputDetector extends PositionComponent with DragCallbacks {
  DragInputDetector({
    required void Function(Vector2 velocity) onDragEnd,
  })  : _onDragEnd = onDragEnd,
        super(anchor: Anchor.center);

  final void Function(Vector2 velocity) _onDragEnd;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    position = size / 2;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _onDragEnd(event.velocity);
    super.onDragEnd(event);
  }
}
