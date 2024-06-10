import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:school_account/main.dart';

class SenderMessageItem extends StatefulWidget {
  final String messageContent;
  final String time;
  final String? voice;
  final bool isSeen;


  SenderMessageItem({
    required this.messageContent,
    required this.time,
    required this.voice,
    required this.isSeen,
  });

  @override
  _SenderMessageItemState createState() => _SenderMessageItemState();
}

class _SenderMessageItemState extends State<SenderMessageItem> {
  FlutterSoundPlayer? _player;
  bool _isPlaying = false;


  @override
  void initState() {
    super.initState();
    _player = FlutterSoundPlayer();
    _player?.openPlayer().then((value) {
      _player?.setSubscriptionDuration(Duration(milliseconds: 100));
      _player?.onProgress?.listen((event) {
        if (event != null && event.position >= event.duration) {
          setState(() {
            _isPlaying = false;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _player?.closePlayer();
    _player = null;
    super.dispose();
  }

  void _playPause() async {
    if (_isPlaying) {
      await _player?.stopPlayer();
    } else {
      await _player?.startPlayer(
        fromURI: widget.voice,
        codec: Codec.aacMP4,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: (sharedpref?.getString('lang') == 'ar')
          ? Alignment.topLeft
          : Alignment.topRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IntrinsicWidth(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF771F98),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.voice != null)
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      color: Colors.white,
                      onPressed: _playPause,
                    ),
                  Expanded(
                    child: Text(
                      widget.messageContent,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.83,
                        fontFamily: 'Poppins-Regular',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          Container(
            width: 80,
            height: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.5),
              color: const Color(0xFFF1F1F1),
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.time,
                  style: const TextStyle(
                    color: Color(0xFF8C8C8C),
                    fontSize: 9,
                    fontFamily: 'Poppins-Regular',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Image.asset(
                  'assets/images/icon _checkmark circle_.png',
                  height: 20,
                  width: 23,
                  color: widget.isSeen ? const Color(0xFF7EBD4C) : const Color(0xFF1877F2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}