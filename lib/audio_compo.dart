import 'package:flame_audio/flame_audio.dart';

class AudioPlayerComponent {
  static void PreloadTracks() async {
    await FlameAudio.audioCache.loadAll([
      'alarms_stolen.mp3',
      'click_stolen.mp3',
      'destroyed_small.mp3',
      'destroyed2.mp3'
    ]);
  }

  static void small_explosion() {
    FlameAudio.play('destroyed_small.mp3');
  }

  static void large_explosion() {
    FlameAudio.play('destroyed2.mp3');
  }
}
