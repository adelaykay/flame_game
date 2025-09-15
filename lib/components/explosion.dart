import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame_game/my_game.dart';

enum ExplosionType { dust, smoke, fire }

class Explosion extends PositionComponent with HasGameReference<MyGame> {
  final ExplosionType explosionType;
  final double explosionSize;
  final Random _random = Random();

  Explosion({
    required super.position,
    required this.explosionType,
    required this.explosionSize,
  });

  @override
  FutureOr<void> onLoad() {
    final int num = 1 + _random.nextInt(2);
    game.audioManager.playExplodeSound(num);
    _createFlash();
    _createParticles();

    add(RemoveEffect(delay: 1.0));

    return super.onLoad();
  }

  void _createFlash() {
    final CircleComponent flash = CircleComponent(
      radius: explosionSize * 0.6,
      paint: Paint()..color = const Color.fromRGBO(255, 255, 255, 1.0),
      anchor: Anchor.center,
    );

    final OpacityEffect fadeOutEffect = OpacityEffect.fadeOut(
      EffectController(duration: 0.3),
    );

    flash.add(fadeOutEffect);
    add(flash);
  }

  List<Color> _generateColors() {
    switch (explosionType) {
      case ExplosionType.dust:
        return [
          // three shades of brown
          const Color.fromRGBO(78, 46, 22, 0.5),
          const Color.fromRGBO(135, 85, 49, 0.5),
          const Color.fromRGBO(182, 127, 88, 0.5),
        ];
      case ExplosionType.smoke:
        return [
          // three shades of black
          const Color.fromRGBO(53, 53, 53, 0.5),
          const Color.fromRGBO(90, 90, 90, 0.5),
          const Color.fromRGBO(143, 143, 143, 0.5),
        ];
      case ExplosionType.fire:
        return [
          // three shades of orange
          const Color.fromRGBO(250, 173, 79, 1.0),
          const Color.fromRGBO(251, 207, 101, 1.0),
          const Color.fromRGBO(251, 225, 81, 1.0),
        ];
    }
  }

  void _createParticles() {
    final List<Color> colors = _generateColors();

    final ParticleSystemComponent particles = ParticleSystemComponent(
      particle: Particle.generate(
        generator: (index) {
          return MovingParticle(
            child: CircleParticle(
              paint: Paint()
                ..color = colors[_random.nextInt(colors.length)].withValues(
                  alpha: 0.4 + _random.nextDouble() * 0.4,
                ),
              radius: explosionSize * (0.1 + _random.nextDouble() * 0.05),
            ),
            to: Vector2(
              (_random.nextDouble() - 0.5) * explosionSize * 2,
              (_random.nextDouble() - 0.5) * explosionSize * 2,
            ),
            lifespan: 0.5 + _random.nextDouble() * 0.5,
          );
        },
        count: 8 + _random.nextInt(5),
      ),
    );

    add(particles);
  }
}
