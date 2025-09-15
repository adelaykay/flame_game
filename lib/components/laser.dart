import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_game/components/asteroid.dart';
import 'package:flame_game/my_game.dart';

class Laser extends SpriteComponent with HasGameReference<MyGame>, CollisionCallbacks {
  Laser({required super.position, super.angle = 0.0})
      : super(
          anchor: Anchor.center,
          priority: -1,
        );

  @override
  FutureOr<void> onLoad() async {
    sprite = await game.loadSprite('laser.png');

    size *= 0.25;

    add(RectangleHitbox()..collisionType = CollisionType.active);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // position.y -= 500 * dt;

    position+= Vector2(sin(angle), -cos(angle)) * 500 * dt;
    // remove laser from game if it goes above the top of the screen
    if (position.y < -size.y / 2) {
      removeFromParent();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Asteroid) {
      removeFromParent();
      other.takeDamage();
    }
  }


}
