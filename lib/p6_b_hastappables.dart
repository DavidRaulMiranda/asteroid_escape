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
bool _GameOver = false;
bool _Inmortal = true;
bool _LightOn = true;

double _ScreenWidth = 0;
double _ScreenHeight = 0;
double _AccelerometerTilt = 0;

int distance = 0;
int numMiss = 5;
int maxNumMiss = 5;

//events

TriggerAcction explosion = TriggerAcction();
TriggerAcction startGame = TriggerAcction();
TriggerAcction exitApp = TriggerAcction();

TriggerAcction pauseGame = TriggerAcction();
TriggerAcction gameOver = TriggerAcction();
TriggerAcction fireMissile = TriggerAcction();

class Game_Hastappables extends FlameGame
    with HasCollisionDetection, HasTappables {
  Timer meteorTimer = Timer(1, repeat: true);

  TextPaint textPaint = TextPaint(
      style: const TextStyle(
          fontSize: 30,
          color: Color.fromARGB(1, 0, 130, 0))); //EurostyleExt , fontFamily:''

//ASSET
  SpriteComponent topbar = SpriteComponent();
  SpriteComponent notif = SpriteComponent();
  SpriteComponent pauseButtonHolder = SpriteComponent();
  SpriteComponent buttonLight = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  SpriteComponent missileIcon = SpriteComponent();
  SpriteComponent missLed1 = SpriteComponent();
  SpriteComponent missLed2 = SpriteComponent();
  SpriteComponent missLed3 = SpriteComponent();
  SpriteComponent missLed4 = SpriteComponent();
  SpriteComponent missLed5 = SpriteComponent();
  SpriteComponent missLed6 = SpriteComponent();
  SpriteComponent menuBackgrond = SpriteComponent();

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

    //ICONS
    var missile = await images.load("missile.png");
    var exit = await images.load("missile.png");
    var quit = await images.load("missile.png");

    //STREAM

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
    pauseButtonHolder
      ..sprite = await loadSprite("pauseButtonHolder.png")
      ..priority = 100
      ..anchor = Anchor.topLeft
      ..x = 0
      ..y = 28
      ..size = Vector2(200, 70);
    add(pauseButtonHolder);
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
    // missileIcon
    //   ..sprite = await loadSprite("iconMissile.png")
    //   ..priority = 200
    //   ..anchor = Anchor.topLeft
    //   ..x = _ScreenWidth / 3
    //   ..y = 35
    //   ..size = Vector2(10, 10);
    // add(missileIcon);
    missLed1
      ..sprite = await loadSprite("btnON.png")
      ..priority = 200
      ..anchor = Anchor.topLeft
      ..x = _ScreenWidth / 2.5
      ..y = 35
      ..size = Vector2(10, 10);
    add(missLed1);
    missLed2
      ..sprite = await loadSprite("btnON.png")
      ..priority = 200
      ..anchor = Anchor.topLeft
      ..x = _ScreenWidth / 2.5 + 10
      ..y = 35
      ..size = Vector2(10, 10);
    add(missLed2);
    missLed3
      ..sprite = await loadSprite("btnON.png")
      ..priority = 200
      ..anchor = Anchor.topLeft
      ..x = _ScreenWidth / 2.5 + 20
      ..y = 35
      ..size = Vector2(10, 10);
    add(missLed3);
    missLed4
      ..sprite = await loadSprite("btnON.png")
      ..priority = 200
      ..anchor = Anchor.topLeft
      ..x = _ScreenWidth / 2.5 + 30
      ..y = 35
      ..size = Vector2(10, 10);
    add(missLed4);
    missLed5
      ..sprite = await loadSprite("btnON.png")
      ..priority = 200
      ..anchor = Anchor.topLeft
      ..x = _ScreenWidth / 2.5 + 40
      ..y = 35
      ..size = Vector2(10, 10);
    add(missLed5);

    ///////////////////////////
    ///   TOGGLE BY EVENT   ///
    ///////////////////////////
    add(background
      ..sprite = await loadSprite("background.jpg")
      ..size = size
      ..priority = 10);
    //event ---------------------------------------------------------------add event make class on tap if bn lit events
    add(buttonLight
      ..sprite = await loadSprite("btnON.png")
      ..priority = 101
      ..anchor = Anchor.topLeft
      ..x = 21
      ..y = 46.5
      ..size = Vector2(35, 35));

    PauseGameButton pauseButton =
        PauseGameButton(await loadSprite("pause.png"));
    add(pauseButton);

    MenuOptionARMR arm =
        MenuOptionARMR(await loadSprite("menu1.png"), _ScreenHeight / 2.5);

    MenuOptionARML arm2 =
        MenuOptionARML(await loadSprite("menu1.png"), _ScreenHeight / 1.7);
    arm2.flipHorizontallyAroundCenter();

    MenuOptionARMR arm3 =
        MenuOptionARMR(await loadSprite("menu1.png"), _ScreenHeight / 1.3);

    add(menuBackgrond
      ..sprite = await loadSprite("background.jpg")
      ..size = size
      ..priority = 10);
    add(arm);
    add(arm2);
    add(arm3);

    Spaceship spaceship = Spaceship(await loadSprite("Ship.png"));
    add(spaceship);
    meteorTimer.start();
    meteorTimer.onTick = () async {
      if (!_GamePause) {
        setSize = operations.RandomDouble(20, 80);
        Asteroid asteroid = Asteroid(
            Sprite(images.fromCache(StackAsteroid.SendToLast())), setSize);
        add(asteroid);
      }
    };
    fireMissile.trigger = () async {
      Missile missile =
          Missile(await loadSprite("missile.png"), spaceship.x, spaceship.y);
      add(missile);

      missileLed(false);

      gameOver.trigger = () async {
        if (_GameOver) {
          _GameOver = true;
          CleanGame();
        }
      };
    };
  }

  //update
  @override
  void update(double dt) {
    super.update(dt);
    if (!_GamePause || !_GameOver) {
      meteorTimer.update(dt);
    }
  }

  void missileLed(bool encender) {
    Sprite s;
    if (encender) {
      s = Sprite(images.fromCache("btnON.png"));
      numMiss += 1;
    } else {
      s = Sprite(images.fromCache("btnOFF.png"));
      Future.delayed(Duration(seconds: 15), () {
        missileLed(true);
      });
    }

    switch (numMiss) {
      case 6:
        missLed6.sprite = s;
        break;
      case 5:
        missLed5.sprite = s;
        break;
      case 4:
        missLed4.sprite = s;
        break;
      case 3:
        missLed3.sprite = s;
        break;
      case 2:
        missLed2.sprite = s;
        break;
      case 1:
        missLed1.sprite = s;
        break;
      default:
    }
    if (!encender) {
      numMiss -= 1;
    }
  }

  void CleanGame() {
    for (Component item in this.children.toList()) {
      print(item.runtimeType);
    }
    _GameOver = false;
    _GamePause = true;
  }

  void _PauseGame() {
    _GamePause = true;
  }

  void RestartGame() {}
  void DrawPauseMenu() {}
  void DrawDefeatmenu() {}
  void DrawMenu() {}
}

//classes
class MenuOptionARMR extends SpriteComponent with Tappable {
  MenuOptionARMR(Sprite img, double spawnPosY) {
    this.sprite = img;
    size = Vector2(700, 170);
    priority = 0;
    anchor = Anchor.center;
    x = -20;
    y = spawnPosY;
  }
}

class MenuOptionARML extends SpriteComponent with Tappable {
  MenuOptionARML(Sprite img, double spawnPosY) {
    this.sprite = img;
    size = Vector2(700, 170);
    priority = 0;
    anchor = Anchor.center;
    x = _ScreenWidth + 20;
    y = spawnPosY;
  }
}

class PauseGameButton extends SpriteComponent with Tappable {
  PauseGameButton(Sprite img) {
    this.sprite = img;
    size = Vector2(35, 35);
    priority = 2;
    anchor = Anchor.topLeft;
    x = 21.5;
    y = 47.5;
    setAlpha(100);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      if (numMiss > 0 && !_GameOver && !_GamePause) {
        _GamePause = true;
        pauseGame.CallAction();
      }
      return true;
    } catch (error) {
      print("pause unable");
      return false;
    }
  }
}

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
    add(CircleHitbox(
        radius: hitboxRedux.CalculaRadi(this.size, 0.7),
        position: hitboxRedux.HitboxPosition(this.size,
            0.7))); //radius: size[0] / 2 - size[0] / 10   <<NO PRIORITY
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_GamePause && !_GameOver) {
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
      gameOver.CallAction();
      _GameOver = true;
    } else if (other is Asteroid) {}
  }

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      print("fire");
      if (numMiss > 0 && !_GameOver && !_GamePause) {
        fireMissile.CallAction();
      } else {}

      return true;
    } catch (error) {
      print("fire unable");
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
    add(CircleHitbox(
        radius: hitboxRedux.CalculaRadi(this.size, 0.8),
        position: hitboxRedux.HitboxPosition(this.size, 0.7)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_GamePause && !_GameOver) {
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
    size = Vector2(10, 50);
    anchor = Anchor.center;
    x = spawnPosX;
    y = spawnPosY;
    debugMode = _DebugMode;
  }
  Future<void> onLoad() async {
    add(CircleHitbox(
        radius: hitboxRedux.CalculaRadi(this.size, 1.5),
        position: hitboxRedux.HitboxPosition(this.size, 1.5)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_GamePause && !_GameOver) {
      this.y += -100 * dt;
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Asteroid) {
      other.removeFromParent();
      this.removeFromParent();
    }
  }
}

//PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE//
class PauseGame extends SpriteComponent with Tappable {
  PauseGame(Sprite sprite) {
    this.sprite = sprite;
    priority = 150;
    size = Vector2(20, 20);
    anchor = Anchor.center;
    x = 30;
    y = 30;
  }
  @override
  bool onTapDown(TapDownInfo info) {
    try {
      print(pauseGame);
      if (pauseGame.isRunning()) {
        pauseGame.CallAction();
      }
      return true;
    } catch (error) {
      return false;
    }
  }
}

class MenuOpt1 extends SpriteComponent with Tappable {}

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

class TriggerAcctionPosition {
  Function(Vector2)? trigger;
  bool _running;
  TriggerAcctionPosition({this.trigger, bool autoStart = true})
      : _running = autoStart;
  void CallActionAt(Vector2 vector) {
    if (_running) {
      trigger?.call(vector);
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

class hitboxRedux {
  static double CalculaRadi(Vector2 dimm, double ratio) {
    return dimm[0] / 2 * ratio;
  }

  static Vector2 HitboxPosition(Vector2 dimm, double ratio) {
    double dispalce = dimm[0] / 2 - CalculaRadi(dimm, ratio);
    return Vector2(dispalce, dispalce);
  }
}
