import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static Future<void> playClickSound() async {
    final player = AudioPlayer();

    await player.play(AssetSource('sounds/click-sound.mp3'), mode: PlayerMode.lowLatency);

    player.onPlayerComplete.listen((event) {
      player.dispose();
    });
  }
}