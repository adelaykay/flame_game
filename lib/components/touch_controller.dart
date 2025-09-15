import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_game/my_game.dart';

class TouchController extends PositionComponent
    with HasGameReference<MyGame>, TapCallbacks, DragCallbacks {

  Vector2? _startDragPosition;
  double _fireCooldown = 0.2;
  double _elapsedFireTime = 0.0;

  @override
  FutureOr<void> onLoad() {
    size = game.size;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // auto-fire
      _elapsedFireTime += dt;
      if (_elapsedFireTime >= _fireCooldown) {
        game.player.startShooting();
        _elapsedFireTime = 0.0;
      }

  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
      _startDragPosition = event.canvasPosition.clone();

  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_startDragPosition != null) {
      final dx = event.canvasDelta.x;  // Change in x position (horizontal movement)
      final dy = event.canvasDelta.y;  // Change in y position (vertical movement)

      // Apply delta to move the player
      game.player.position.x += dx;
      game.player.position.y += dy;

      // Update start position to current position for continuous movement
      _startDragPosition = event.canvasEndPosition.clone();
    }
  }



  @override
  void onDragEnd(DragEndEvent event) {
    _startDragPosition = null;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    _startDragPosition = null;
  }
}
