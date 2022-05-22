import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

class Test_accelerometer extends FlameGame {
  SpriteComponent ship = SpriteComponent();
  SpriteComponent planet = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  //gyro

  double tilt = 0;
  final double Shipsize = 100;
  final double PlanetSize = 100;
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    //
    accelerometerEvents.listen((AccelerometerEvent event) {
      //print(event);
      tilt = event.x;
    });
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
    moveTest(dt, ship, screenWidth, tilt);
    /*
    accelerometerEvents.listen((AccelerometerEvent event) {
      print(event);
      tilt = event.x;
    });*/
  }
}

void moveTest(
    double dt, SpriteComponent ship, double screenWidth, double tilt) {
  double shipWidth = ship.size[0];
  double posX = ship.x;
  double newPosX;
  if (tilt.abs() > 1) {
    newPosX = ship.x + tilt * -2;

    if (newPosX > 0 && newPosX + shipWidth < screenWidth) {
      ship.x = newPosX;
    }
  }
}
