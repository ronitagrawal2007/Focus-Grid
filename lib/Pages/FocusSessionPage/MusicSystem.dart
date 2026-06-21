import 'dart:async'; // 1. Import dart:async to use StreamSubscription
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicSystem extends StatefulWidget {
  const MusicSystem({super.key});

  @override
  State<MusicSystem> createState() => _MusicSystemState();
}

class _MusicSystemState extends State<MusicSystem> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  // 2. Create a variable to hold the stream subscription
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    // 3. Assign the listener to the subscription variable
    _playerStateSubscription = audioPlayer.onPlayerStateChanged.listen((
      PlayerState state,
    ) {
      if (mounted) {
        // 4. Check if the widget is still in the tree before calling setState
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  Future<void> playMusic() async {
    try {
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.play(AssetSource('bg.mp3'));
    } catch (error) {
      debugPrint('Music play failed: $error');
    }
  }

  Future<void> stopMusic() async {
    try {
      await audioPlayer.stop();
    } catch (error) {
      debugPrint('Music stop failed: $error');
    }
  }

  @override
  void dispose() {
    // 5. Cancel the subscription first to prevent memory leaks and crashes
    _playerStateSubscription?.cancel();
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isPlaying ? stopMusic : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(
              'Stop Music',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: _isPlaying ? null : playMusic,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              _isPlaying ? 'Playing...' : 'Start Music',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
