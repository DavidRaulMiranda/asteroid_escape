import 'dart:math';
import 'package:flame/components.dart';

//generate random numbers
class operations {
  static int RandomIntVal(int min, int max) {
    Random random = Random();
    return min + random.nextInt(max - min);
  }

  static double RandomDouble(double min, double max) {
    Random r = Random();
    return r.nextDouble() * (max - min) + min;
  }

  static String RnadomAsteroid() {
    List<String> asteroidTextures = ["Asteroid1.png", "Asteroid2.png"];
    int num = RandomIntVal(0, asteroidTextures.length);
    print(num);
    return asteroidTextures[num];
  }

  static Vector2 RandomSquareDimm(double min, double max) {
    double dimm = RandomDouble(min, max);
    return Vector2(dimm, dimm);
  }
}
