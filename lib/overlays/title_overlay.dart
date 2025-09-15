import 'package:flame_game/my_game.dart';
import 'package:flutter/material.dart';

class TitleOverlay extends StatefulWidget {
  final MyGame game;
  const TitleOverlay({super.key, required this.game});

  @override
  State<TitleOverlay> createState() => _TitleOverlayState();
}

class _TitleOverlayState extends State<TitleOverlay> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 0), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final String playercolor =
        widget.game.playerColors[widget.game.playercolorIndex];

    return AnimatedOpacity(
        onEnd: () {
          if (_opacity == 0.0) {
            widget.game.overlays.remove('Title');
          }
        },
        opacity: _opacity,
        duration: const Duration(milliseconds: 500),
        child: Container(
          color: Colors.black.withAlpha(150),
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(height: 60),
              SizedBox(
                width: 270,
                child: Image.asset('assets/images/title.png'),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.game.audioManager.playSound('click.ogg');
                      setState(() {
                        widget.game.playercolorIndex =
                            (widget.game.playercolorIndex -
                                    1 +
                                    widget.game.playerColors.length) %
                                widget.game.playerColors.length;
                      });
                    },
                    child: Transform.flip(
                      flipX: true,
                      child: SizedBox(
                        width: 30,
                        child: Image.asset('assets/images/arrow_button.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 30),
                    child: SizedBox(
                      width: 100,
                      child: Image.asset(
                        'assets/images/player_${playercolor}_off.png',
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.game.audioManager.playSound('click.ogg');
                      setState(() {
                        widget.game.playercolorIndex =
                            (widget.game.playercolorIndex + 1) %
                                widget.game.playerColors.length;
                      });
                    },
                    child: SizedBox(
                      width: 30,
                      child: Image.asset('assets/images/arrow_button.png'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  widget.game.audioManager.playSound('start.ogg');
                  widget.game.startGame();
                  setState(() {
                    _opacity = 0.0;
                  });
                },
                child: SizedBox(
                  width: 200,
                  child: Image.asset('assets/images/start_button.png'),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                widget.game.audioManager.toggleMusic();
                              });
                            },
                            icon: Icon(
                              widget.game.audioManager.musicEnabled
                                  ? Icons.music_note_rounded
                                  : Icons.music_off_rounded,
                              color: widget.game.audioManager.musicEnabled
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                widget.game.audioManager.toggleSounds();
                              });
                              setState(() {

                              });
                            },
                            icon: Icon(
                              widget.game.audioManager.soundsEnabled
                                  ? Icons.volume_up_rounded
                                  : Icons.volume_off_rounded,
                              color: widget.game.audioManager.soundsEnabled
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
