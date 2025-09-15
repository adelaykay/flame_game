import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioManager extends Component {
  bool musicEnabled = true;
  bool soundsEnabled = true;

  final List<String> _sounds = [
    'click.ogg',
    'collect.ogg',
    'explode1.ogg',
    'explode2.ogg',
    'fire.ogg',
    'hit.ogg',
    'laser.ogg',
    'start.ogg',
    'music.mp3',
  ];

  late AudioPool laserSound;
  late AudioPool explosion1Sound;
  late AudioPool explosion2Sound;
  late AudioPool hitSound;
  late AudioPool bombSound;

  @override
  FutureOr<void> onLoad() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(_sounds);

    laserSound = await FlameAudio.createPool(
      'laser.ogg',
      minPlayers: 3,
      maxPlayers: 6,
    );

    explosion1Sound = await FlameAudio.createPool(
      'explode1.ogg',
      minPlayers: 2,
      maxPlayers: 4,
    );
    explosion2Sound = await FlameAudio.createPool(
      'explode1.ogg',
      minPlayers: 2,
      maxPlayers: 4,
    );

    bombSound = await FlameAudio.createPool(
      'fire.ogg',
      minPlayers: 2,
      maxPlayers: 4,
    );

    hitSound = await FlameAudio.createPool(
      'hit.ogg',
      maxPlayers: 10,
      minPlayers: 5,
    );

    return super.onLoad();
  }

  @override
  void onRemove() {
    laserSound.dispose();
    explosion1Sound.dispose();
    explosion2Sound.dispose();
    hitSound.dispose();
    super.onRemove();
  }

  void playMusic() {
    if (musicEnabled) {
      FlameAudio.bgm.play('music.mp3');
    }
  }

  void stopMusic() {
    FlameAudio.bgm.stop();
  }

  void playSound(String soundName) {
    if (soundsEnabled) {
      FlameAudio.play(soundName);
    }
  }

  void playLaserSound() async {
    if(soundsEnabled){
      await laserSound.start();
    }
  }

  void playBombSound() async {
    if (soundsEnabled) {
      await bombSound.start();
    }
  }

  void playExplodeSound(num) async {
    if (soundsEnabled) {
      if (num == 1) {
        await explosion1Sound.start();
      } else {
        explosion2Sound.start();
      }
    }
  }

  void playHitSound() async {
    if (soundsEnabled) {
      await hitSound.start();
    }
  }

  void toggleMusic(){
    musicEnabled = !musicEnabled;
    if (musicEnabled) {
      playMusic();
    } else {
      stopMusic();
    }
  }

  void toggleSounds(){
    soundsEnabled = !soundsEnabled;
  }
}
