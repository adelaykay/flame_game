import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_game/my_game.dart';
import 'package:flutter/widgets.dart';

class Star extends CircleComponent with HasGameReference<MyGame> {
  final Random _random = Random();
  final int _maxSize = 3;
  late double _speed;

  @override
  Future<void> onLoad() {
    size = Vector2.all(1.0 + _random.nextInt(_maxSize));
    position = Vector2(
      _random.nextDouble() * game.size.x,
      _random.nextDouble() * game.size.y,
    );
    _speed = size.x * (40 + _random.nextInt(10));

    paint.color = Color.fromRGBO(255, 255, 255, size.x /_maxSize);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += _speed * dt;

    // if it reaches the bottom move to random x position at top
    if (position.y > game.size.y) {
      position.x = _random.nextDouble() * game.size.x;
      position.y = -size.y;
    }
  }
}
