import 'package:flame_audio/flame_audio.dart';

//app audio triggers and loader
class AudioPlayerComponent {
  static void PreloadTracks() async {
    await FlameAudio.audioCache.loadAll([
      'alarms_stolen.mp3',
      'click_stolen.mp3',
      'destroyed_small.mp3',
      'destroyed2.mp3'
    ]);
  }

  //effect
  static void menu() {
    FlameAudio.play('click_stolen.mp3', volume: .25);
  }

  static void error() {
    FlameAudio.play('error_ping_stolen.mp3');
  }

  static void small_explosion() {
    FlameAudio.play('destroyed_small.mp3');
  }

  static void large_explosion() {
    FlameAudio.play('destroyed2.mp3');
  }

  static void missileLaunch() {
    FlameAudio.play("missile2.mp3", volume: .25);
  }

  //loop
  static void initBackgroundMusic() {
    FlameAudio.bgm
        .loadAll(["combat.mp3", "combat2.mp3", "meuSong.mp3", "pause.mp3"]);
  }

  static void bgmMenu() {
    FlameAudio.bgm.play('meuSong.mp3', volume: .25);
    //FlameAudio.bgm.play('bgm/world-map.mp3', volume: .25);
  }

  static void bgmCombat1() {
    FlameAudio.bgm.play('combat.mp3', volume: .10);
  }

  static void bgmCombat2() {
    FlameAudio.bgm.play('combat2.mp3', volume: .10);
  }

  static void bgmPause() {
    FlameAudio.bgm.play('pause.mp3');
  }

  //bgm
}
