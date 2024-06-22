import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter_snake_game/services/input_service.dart';

class DragInputDetector extends PositionComponent with DragCallbacks {
  DragInputDetector({
    required InputService inputService,
  })  : _inputService = inputService,
        super(anchor: Anchor.center);

  final InputService _inputService;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
    position = size / 2;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    _inputService.handleDragInput(event.velocity);
    super.onDragEnd(event);
  }
}
