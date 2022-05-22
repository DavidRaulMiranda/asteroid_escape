import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

bool direction = false;

class Test_AddSprite extends FlameGame {
  SpriteComponent ship = SpriteComponent();
  SpriteComponent planet = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  final double Shipsize = 100;
  final double PlanetSize = 100;
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    //size
    screenWidth = size[0];
    screenHeight = size[1];
    print("load assets");
    //background
    add(background
      ..sprite = await loadSprite("background.jpg")
      ..size = size);
    //load once
    ship
      ..sprite = await loadSprite("Ship.png")
      ..size = Vector2(Shipsize, Shipsize)
      ..x = screenWidth / 2 - Shipsize / 2
      ..y = screenHeight - Shipsize;

    add(ship);
    //
    planet
      ..sprite = await loadSprite("Target.png")
      ..size = Vector2(PlanetSize, PlanetSize)
      ..x = screenWidth / 2 - PlanetSize / 2
      ..y = screenHeight / 8 - PlanetSize / 2;

    add(planet);
  }

  //update
  @override
  void update(double dt) {
    super.update(dt);
    planet.y += 1;
    moveTest(dt, ship, screenWidth);
  }
}

void moveTest(double dt, SpriteComponent ship, double screenWidth) {
  double shipRaddi = ship.size[0] / 2;
  double posX = ship.x;
  if (posX < 0 || screenWidth - 2 * shipRaddi < (posX)) {
    direction = !direction;
    print(posX + 2 * shipRaddi);
    print("border");
  }
  if (direction) {
    ship.x += 1;
  } else {
    ship.x -= 1;
  }
}
