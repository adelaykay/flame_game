import 'dart:async';
import 'dart:math';

import 'package:flame/effects.dart';
import 'package:flame_game/components/audio_manager.dart';
import 'package:flame_game/components/pickup.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_game/components/asteroid.dart';
import 'package:flame_game/components/player.dart';
import 'package:flame_game/components/shoot_button.dart';

import 'components/star.dart';
import 'components/touch_controller.dart';

class MyGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection, TapCallbacks {
  late Player player;
  // late JoystickComponent joystick;
  late SpawnComponent _asteroidSpawner;
  late SpawnComponent _pickupSpawner;
  final Random _random = Random();
  // late ShootButton _shootButton;
  int _score = 0;
  late TextComponent _scoreDisplay;
  final List<String> playerColors = ['blue', 'red', 'green', 'purple'];
  int playercolorIndex = 0;
  late final AudioManager audioManager;

  @override
  FutureOr<void> onLoad() async {
    await Flame.device.fullScreen();
    await Flame.device.setPortrait();

    // initialize the audio manager
    audioManager = AudioManager();
    await add(audioManager);
    audioManager.playMusic();

    _createStars();

    // debugMode = true;

    return super.onLoad();
  }

  void startGame() async {
    // await _createJoystick();
    await _createPlayer();
    add(TouchController());
    // _createShootButton();
    _createAsteroidSpawner();
    _createPickupSpawner();
    _createScoreDisplay();
  }

  Future<void> _createPlayer() async {
    player = Player()
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y * 0.8);
    add(player);
  }
  //
  // Future<void> _createJoystick() async {
  //   joystick = JoystickComponent(
  //     knob: SpriteComponent(
  //       sprite: await loadSprite('joystick_knob.png'),
  //       size: Vector2.all(50),
  //     ),
  //     background: SpriteComponent(
  //         sprite: await loadSprite('joystick_background.png'),
  //         size: Vector2.all(100)),
  //   )
  //     ..anchor = Anchor.bottomLeft
  //     ..position = Vector2(20, size.y - 20)
  //     ..priority = 10;
  //   add(joystick);
  // }

  void _createAsteroidSpawner() {
    _asteroidSpawner = SpawnComponent.periodRange(
      factory: (index) => Asteroid(position: _generateSpawnPosition()),
      minPeriod: 1.5,
      maxPeriod: 2.2,
      selfPositioning: true,
    );
    add(_asteroidSpawner);
  }

  void _createPickupSpawner() {
    _pickupSpawner = SpawnComponent.periodRange(
      factory: (index) => Pickup(
        position: _generateSpawnPosition(),
        pickupType:
            PickupType.values[_random.nextInt(PickupType.values.length)],
      ),
      minPeriod: 5.0,
      maxPeriod: 10.0,
      selfPositioning: true,
    );
    add(_pickupSpawner);
  }

  Vector2 _generateSpawnPosition() {
    final double x = 10 + _random.nextDouble() * (size.x - 10 * 2);
    return Vector2(x, -100);
  }

  // void _createShootButton() {
  //   _shootButton = ShootButton()
  //     ..anchor = Anchor.bottomRight
  //     ..position = Vector2(size.x - 20, size.y - 20)
  //     ..priority = 10;
  //   add(_shootButton);
  // }

  void _createScoreDisplay() {
    _score = 0;

    _scoreDisplay = TextComponent(
      text: '0',
      anchor: Anchor.topCenter,
      position: Vector2(size.x / 2, 40),
      priority: 10,
      textRenderer: TextPaint(
        style: const TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 2.0,
                offset: Offset(2, 2),
              )
            ]),
      ),
    );
    add(_scoreDisplay);
  }

  void incrementScore(int amount) {
    _score += amount;
    _scoreDisplay.text = '$_score';

    final ScaleEffect popEffect = ScaleEffect.to(
        Vector2.all(1.2),
        EffectController(
          duration: 0.05,
          alternate: true,
          curve: Curves.easeInOut,
        ));
    _scoreDisplay.add(popEffect);
  }

  void _createStars(){
    for (int i = 0; i < 100; i++) {
      add(Star()..priority = -10);
    }
  }

  void playerDied(){
    overlays.add('GameOver');
    pauseEngine();
  }

  void restartGame(){
    // remove all asteroids and pickups in the game
    children.whereType<PositionComponent>().forEach((component){
      if (component is Asteroid || component is Pickup) {
        remove(component);
      }
    });

    // reset the asteroid and pickup spawners
    _asteroidSpawner.timer.start();
    _pickupSpawner.timer.start();

    // reset the score to 0
    _score = 0;
    _scoreDisplay.text = '0';

    // create a new player sprite
    _createPlayer();

    // resume flame game engine
    resumeEngine();
  }

  void quitGame(){
    // remove everything except stars
    children.whereType<PositionComponent>().forEach((component){
      if (component is! Star) {
        remove(component);
      }
    });

    remove(_asteroidSpawner);
    remove(_pickupSpawner);

    // show the title ovelay
    overlays.add('Title');

    resumeEngine();
  }
}
