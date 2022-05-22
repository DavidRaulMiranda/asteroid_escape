import 'package:async/async.dart';

import 'package:asteroid_escape/operations.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

class Test_colision extends FlameGame {
//LIB
  math.Random randomX = math.Random();
  math.Random randomY = math.Random();

  Timer meteorTimer = Timer(1, repeat: true);

//ASSET
  SpriteComponent ship = SpriteComponent();
  SpriteComponent planet = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  Asteroid asteroid = Asteroid();

//ASSET LIST
  List<Asteroid> listAsteroid = [];
  List<SpriteComponent> listTracer = [];

  bool gamePaused = false;
  double tilt = 0;
  double setSize = 100;
  double popSpeed = 1;
  final double Shipsize = 75;
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
    //load periodic;

    meteorTimer.onTick = () async {
      setSize = operations.RandomDouble(20, 80);
      Asteroid asteroid = Asteroid();
      asteroid
        ..sprite = await loadSprite(operations.RnadomAsteroid())
        ..size = Vector2(setSize, setSize)
        ..x = operations.RandomDouble(0, screenWidth - setSize)
        ..y = 30;

      add(asteroid);
      listAsteroid.add(asteroid);
    };

    planet
      ..sprite = await loadSprite("Target.png")
      ..size = Vector2(PlanetSize, PlanetSize)
      ..x = screenWidth / 2 - PlanetSize / 2
      ..y = screenHeight / 8 - PlanetSize / 2;

    add(planet);

    meteorTimer.start();
  }

  //update
  @override
  void update(double dt) {
    super.update(dt);
    //timers
    meteorTimer.update(dt);
    planet.y += 1;
    if (!gamePaused) {
      moveShip(dt, ship, screenWidth, tilt);
      moveMeteor(listAsteroid, dt);
    }
  }
}

void moveShip(
    double dt, SpriteComponent ship, double screenWidth, double tilt) {
  double shipWidth = ship.size[0];
  double posX = ship.x;
  double newPosX;
  //if (tilt.abs() > 1) {
  newPosX = ship.x + tilt * -2;

  if (newPosX > 0 && newPosX + shipWidth < screenWidth) {
    ship.x = newPosX;
  }
  //}
}

void moveMeteor(List<Asteroid> listAsteroid, double dt) {
  if (listAsteroid.isNotEmpty) {
    for (Asteroid asteroid in listAsteroid) {
      asteroid.y += 300 * dt / (asteroid.size[0] / 10);
    }
  }
}

//classes
class Asteroid extends SpriteComponent {}

class Spaceship extends SpriteComponent {}
