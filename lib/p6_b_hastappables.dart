import 'dart:ffi';

import 'package:async/async.dart';

import 'package:asteroid_escape/operations.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

bool _DebugMode = true;
bool _GamePause = false;
bool _Inmortal = true;
bool _LightOn = true;

double _ScreenWidth = 0;
double _ScreenHeight = 0;
double _AccelerometerTilt = 0;

int rockets = 5;
int maxRockets = 5;

//events
TriggerAcction fireMissile = TriggerAcction();

class Game_Hastappables extends FlameGame
    with HasCollisionDetection, HasTappables {
  //HasTappables
  //HasTappables
//LIB
  math.Random randomX = math.Random();
  math.Random randomY = math.Random();

  Timer meteorTimer = Timer(1, repeat: true);
  Timer RearmTime = Timer(5, repeat: false);

  TextPaint textPaint = TextPaint(
      style: const TextStyle(
          fontSize: 30,
          color: Color.fromARGB(1, 0, 130, 0))); //EurostyleExt , fontFamily:''

//ASSET
  SpriteComponent topbar = SpriteComponent();
  SpriteComponent notif = SpriteComponent();
  SpriteComponent pauseButton = SpriteComponent();
  SpriteComponent buttonLight = SpriteComponent();
  SpriteComponent background = SpriteComponent();

  double setSize = 100;
  double popSpeed = 1;

  double screenWidth = 0;
  double screenHeight = 0;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    //GETVAR //setvar
    _GamePause = false;
    _ScreenWidth = size[0];
    _ScreenHeight = size[1];
    //PREPARE COMPONENTS
    final StackAsteroid = Stack<String>();
    var asteroid1 = await images.load("Asteroid1.png");
    var asteroid2 = await images.load("Asteroid2.png");
    StackAsteroid.push("Asteroid1.png");
    StackAsteroid.push("Asteroid2.png");

    final StackTracer = Stack<String>();
    var tacer1 = await images.load("TraceBlue.png");
    var tacer2 = await images.load("TraceRed.png");
    var tacer3 = await images.load("TraceWhite.png");
    StackTracer.push("TraceBlue.png");
    StackTracer.push("TraceRed.png");
    StackTracer.push("TraceWhite.png");

    //var ship = await images.load("Ship.png");
    var menu1 = await images.load("menu1.png");
    var menu2 = await images.load("menu2.png");

    var buttonOn = await images.load("btnOFF.png");
    var buttonOff = await images.load("btnON.png");

    var missile = await images.load("missile.png");

    //STREAM
    meteorTimer.start();
    accelerometerEvents.listen((AccelerometerEvent event) {
      //<unsubscribe on close, set global values to default on close/exit
      //print(event);
      _AccelerometerTilt = event.x;
    });
    ScreenHitboxControll s = ScreenHitboxControll();
    add(s);

    ///////////////////////////
    ///      FIXED GUI      ///
    ///////////////////////////
    pauseButton
      ..sprite = await loadSprite("pauseButtonHolder.png")
      ..priority = 100
      ..anchor = Anchor.topLeft
      ..x = 0
      ..y = 28
      ..size = Vector2(200, 70);

    add(pauseButton);
    topbar
      ..sprite = await loadSprite("topDecoration.png")
      ..priority = 99
      ..anchor = Anchor.topLeft
      ..x = 0
      ..y = 28
      ..size = Vector2(_ScreenWidth, 30);
    add(topbar);
    notif
      ..sprite = await loadSprite("topDecoration.png")
      ..priority = 98
      ..anchor = Anchor.topLeft
      ..x = 0
      ..y = 0
      ..size = Vector2(_ScreenWidth, 30);
    add(notif);

    ///////////////////////////
    ///   TOGGLE BY EVENT   ///
    ///////////////////////////
    add(background
      ..sprite = await loadSprite("background.jpg")
      ..size = size);
    //event ---------------------------------------------------------------add event make class on tap if bn lit events
    add(buttonLight);
    buttonLight
      ..sprite = await loadSprite("btnON.png")
      ..priority = 101
      ..anchor = Anchor.topLeft
      ..x = 21
      ..y = 46.5
      ..size = Vector2(35, 35);

    ///////////////////////////
    ///      MENUS          ///
    ///////////////////////////

    //create list of menu items  tigger a hide() method to dissapear, method to remove all items  of type??

    //GAME PAUSE MENU

    //MAIN MENU

    //SCOREOARD

    //SETTINGS

    ///////////////////////////
    ///   GAME ITEMS        ///----------------------------------ADD CLEAR CONFITIONAL IN GAME TO TERMINATE AL GAME OBJECTS (METEOR MISSILE, ASTEROID TRACER)
    ///////////////////////////

    Spaceship spaceship = Spaceship(await loadSprite("Ship.png"));
    add(spaceship);
    /*
    Spaceship spaceship =
        Spaceship(Sprite(images.fromCache("Asteroid1.png"))); //Ship.png
    add(spaceship);*/
    /* Spaceship spaceship2 = Spaceship(await loadSprite("Target.png"));
    add(spaceship2);*/

    //PERIODIC
    //METEORITE
    meteorTimer.onTick = () async {
      if (!_GamePause) {
        setSize = operations.RandomDouble(20, 80);
        Asteroid asteroid2 = Asteroid(
            Sprite(images.fromCache(StackAsteroid.SendToLast())), setSize);
        add(asteroid2);
      }
    };
    //Event based
    //MISSILE-------------------------------------------event
    fireMissile.trigger = () async {
      print("vvvvvvvvvvvvvvvvvvvv");
    };
    Missile m = Missile(await loadSprite("Ship.png"), 50, 50);
    add(m);
  }

  //update
  @override
  void update(double dt) {
    super.update(dt);
    meteorTimer.update(dt);

    //  moveShip(dt, ship, screenWidth, _GlovalTilt);
  }

  /*
    @override
  void render(Canvas canvas) {}*/

}

//classes
class ScreenHitboxControll extends ScreenHitbox {
  @override
  void onCollisionEnd(PositionComponent other) {
    if (other is Asteroid &&
        (other.y > _ScreenHeight || other.x < 0 || other.x > _ScreenWidth)) {
      other.removeFromParent();
    } else if (other is Missile && other.y < 0) {
      other.removeFromParent();
    }
  }
}

//SPACESHIP////SPACESHIP////SPACESHIP////SPACESHIP////SPACESHIP////SPACESHIP////SPACESHIP////SPACESHIP////SPACESHIP//
class Spaceship extends SpriteComponent with CollisionCallbacks, Tappable {
  //Tappable
  Spaceship(Sprite img) {
    this.sprite = img;
    size = Vector2(75, 75);
    priority = 50;
    anchor = Anchor.center;
    x = operations.RandomDouble(0 + 75 / 2, _ScreenWidth - 75 / 2);
    y = _ScreenHeight - 75 / 2;
    debugMode = _DebugMode;
  }
  Future<void> onLoad() async {
    add(CircleHitbox()); //radius: size[0] / 2 - size[0] / 10   <<NO PRIORITY
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_GamePause) {
      double shipWidth = this.size[0];
      double posX = this.x;
      double newPosX;
      //if (tilt.abs() > 1) {
      newPosX = this.x + _AccelerometerTilt * -2;

      if (newPosX - shipWidth / 2 > 0 &&
          newPosX + shipWidth / 2 < _ScreenWidth) {
        this.x = newPosX;
      }
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Asteroid) {
      _GamePause = true;
    } else if (other is Asteroid) {}
  }

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      print("fire");
      fireMissile.CallAction();
      return true;
    } catch (error) {
      return false;
    }
  }
}

//ASTEROID////ASTEROID////ASTEROID////ASTEROID////ASTEROID////ASTEROID////ASTEROID////ASTEROID////ASTEROID////ASTEROID//
class Asteroid extends SpriteComponent with CollisionCallbacks {
  Asteroid(Sprite sprite, double setSize) {
    this.sprite = sprite;
    priority = 49;
    size = Vector2(setSize, setSize);
    anchor = Anchor.center;
    x = operations.RandomDouble(0 + setSize / 2, _ScreenWidth - setSize / 2);
    y = -2 * setSize;
    debugMode = _DebugMode;
  }
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_GamePause) {
      this.y += 300 * dt / (this.size[0] / 10);
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Asteroid && other.size[0] < this.size[0]) {
      //other.removeFromParent();
    } else if (other is Asteroid) {}
  }
}

//MISSILE////MISSILE////MISSILE////MISSILE////MISSILE////MISSILE////MISSILE////MISSILE////MISSILE////MISSILE//
class Missile extends SpriteComponent with CollisionCallbacks {
  Missile(Sprite sprite, double spawnPosX, double spawnPosY) {
    this.sprite = sprite;
    priority = 51;
    size = Vector2(75, 75);
    anchor = Anchor.center;
    x = spawnPosX;
    y = spawnPosY;
    debugMode = _DebugMode;
  }
  Future<void> onLoad() async {
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_GamePause) {
      this.y += -10 * dt;
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Asteroid) {
      other.removeFromParent();
    }
  }
}

//explosion
//PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE//
//

//arm1
//arm2
//arm scoreboard

//animated sprites cover (3..2..1.0 para el jeugo) app logo para menu y lanzar

//tracer

//Men
//
///other
class Stack<E> {
  final _list = <E>[];

  void push(E value) => _list.add(value);

  E pop() => _list.removeLast();

  E get peek => _list.first;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();

  @override
  E SendToLast() {
    E value = _list.first;
    _list.add(value);
    _list.removeAt(0);
    return value;
  }
}

class TriggerAcction {
  VoidCallback? trigger;
  bool _running;
  TriggerAcction({this.trigger, bool autoStart = true}) : _running = autoStart;
  void CallAction() {
    if (_running) {
      trigger?.call();
    }
  }

  bool isRunning() => _running;
  void Stop() {
    _running = false;
  }

  void Start() {
    _running = true;
  }
}
