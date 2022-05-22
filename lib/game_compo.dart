import 'package:asteroid_escape/_sprites_compo.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'dart:math' as math;

class GameConfig {
  int missitleAmmo = 3;
  int time = 0;
  int SpawnFreq = 1;
  int items = 0;
  int health = 200;
  bool debug = true;
  bool inmortal = true;
  List<Tracer> tracers = [];
  double speedTracer = 0.050;
  int tracerNum = 8;
}

GameConfig conf = GameConfig();

class MyGame extends FlameGame with HasCollisionDetection {
//  Timer meteorSpawnTimer = Timer(1, repeat: true);
  Timer tracerSpawnTimer = Timer(1, repeat: true);
//  Timer planetSpawnTimer = Timer(1, repeat: true);

  var tracer;
  var ship;

  //var meteor = SpriteComponent();
  //deco
  //var planet = SpriteComponent();
  //var tracer = SpriteComponent();

  @override
  Color backgroundColor() => const Color(0xb2b2b2);

  @override
  Future<void> onLoad() async {
    ship;
    add(SpaceShip2());
    tracerSpawnTimer.onTick = () async {
      for (var i = 0; i < 3; i++) {
        tracer = new Tracer();
        tracer;
        add(Tracer());

        print("items= " + conf.tracers.length.toString());

        conf.tracers.add(tracer);
      }
    };
/*
    planet
      ..sprite = await loadSprite('Target.png')
      ..position = Vector2(200, 200)
      ..size = Vector2(60, 60);
    add(planet);*/
    //timers

    //  meteorSpawnTimer.start();
    tracerSpawnTimer.start();
    //  planetSpawnTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    print("running" + tracerSpawnTimer.isRunning().toString());
    tracerSpawnTimer.update(dt);
    UpdatePosition(dt);
    /*planet.angle += 0.25 * dt;
    planet.angle %= 2 * math.pi;*/
    if (ship != null) {
      ship.angle += 0.25 * dt;
      ship.angle %= 2 * math.pi;
    }
  }
}

//methods
void GeneraNouTracer() {
  for (var i = 0; i < conf.tracerNum; i++) {
    Tracer t = new Tracer();

    conf.tracers.add(t);
  }
}

void UpdatePosition(double dt) {
  conf.tracers.forEach((element) {
    print("bf: " + element.y.toString());
    element.y += dt * element.size.y;
    element.size = element.size * 2;
    print("af: " + element.y.toString());
    element.update(dt);
    /*
    element.y = element.y + conf.speedTracer * dt;
    print("pos" + element.y.toString());*/
  });
}
