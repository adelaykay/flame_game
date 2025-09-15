import 'dart:math';
import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_game/components/explosion.dart';
import 'package:flame_game/my_game.dart';
import 'package:flutter/animation.dart';

class Asteroid extends SpriteComponent with HasGameReference<MyGame> {
  final Random _random = Random();
  static const double _maxSize = 120;
  late Vector2 _velocity;
  final Vector2 _originalVelocity = Vector2.zero();
  late double _spinSpeed;
  final double _maxHealth = 3;
  late double _health;
  bool _isKnockBackApplied = false;

  Asteroid({required super.position, double size = _maxSize})
      : super(
          size: Vector2.all(size),
          anchor: Anchor.center,
          priority: -1,
        ) {
    _velocity = _generateVelocity();
    _originalVelocity.setFrom(_velocity);
    _spinSpeed = _random.nextDouble() * 1.5 - 0.75;
    _health = size / _maxSize * _maxHealth;

    add(CircleHitbox(collisionType: CollisionType.passive));
  }

  @override
  FutureOr<void> onLoad() async {
    final int imageNum = _random.nextInt(3) + 1;
    sprite = await game.loadSprite('asteroid$imageNum.png');

    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += _velocity * dt;

    _handleScreenBounds();

    angle += _spinSpeed * dt;
    super.update(dt);
  }

  Vector2 _generateVelocity() {
    final double forceFactor = _maxSize / size.x;

    return Vector2(
          _random.nextDouble() * 120 - 60,
          100 + _random.nextDouble() * 50,
        ) *
        forceFactor;
  }

  void _handleScreenBounds() {
    // remove the asteroid from the game if it goes below the bottom
    if (position.y > game.size.y + size.y / 2) {
      removeFromParent();
    }

    // asteroids bounce off the left and right edges

  }

  void takeDamage() {
    game.audioManager.playHitSound();
    _health--;

    if (_health <= 0) {
      game.incrementScore(2);
      removeFromParent();
      _createExplosion();
      _splitAsteroid();
    } else {
      _flashWhite();
      _applyKnockBack();
      game.incrementScore(1);
    }
  }

  void _flashWhite() {
    final ColorEffect flashEffect = ColorEffect(
      const Color.fromRGBO(255, 255, 255, 1.0),
      EffectController(
        duration: 0.1,
        alternate: true,
        curve: Curves.easeInOut,
      ),
    );
    add(flashEffect);
  }

  void _applyKnockBack() {
    if (_isKnockBackApplied) {
      return;
    }
    _isKnockBackApplied = true;
    _velocity.setZero();
    final MoveByEffect knockBackEffect = MoveByEffect(
      Vector2(0, -20),
      EffectController(
        duration: 0.1,
      ),
      onComplete: _restoreVelocity,
    );
    add(knockBackEffect);
  }

  void _restoreVelocity() {
    _velocity.setFrom(_originalVelocity);
    _isKnockBackApplied = false;
  }

  void _createExplosion() {
    final Explosion explosion = Explosion(
      position: position.clone(),
      explosionType: ExplosionType.dust,
      explosionSize: size.x,
    );
    game.add(explosion);
  }

  void _splitAsteroid() {
    if (size.x <= _maxSize / 3 ) return;

    for ( int i = 0; i < 3; i++){
      final Asteroid fragment = Asteroid(position: position.clone(), size: size.x - _maxSize / 3);
    game.add(fragment);
    }
  }
}
