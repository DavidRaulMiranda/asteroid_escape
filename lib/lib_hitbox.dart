import 'package:flame/game.dart';

//recalculate hitbox so is smaller and centered
class hitboxRedux {
  static double CalculaRadi(Vector2 dimm, double ratio) {
    return dimm[0] / 2 * ratio;
  }

  static Vector2 HitboxPosition(Vector2 dimm, double ratio) {
    double dispalce = dimm[0] / 2 - CalculaRadi(dimm, ratio);
    return Vector2(dispalce, dispalce);
  }
}
