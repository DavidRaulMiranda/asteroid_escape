import 'dart:ffi';
import 'dart:io';

import 'package:asteroid_escape/audio_compo.dart';
import 'package:async/async.dart';

import 'package:asteroid_escape/operations.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

bool _DebugMode = false;
bool _GamePause = false;
bool _GameOver = true;
bool _Inmortal = true;
bool _LightOn = true;

double _ScreenWidth = 0;
double _ScreenHeight = 0;
double _AccelerometerTilt = 0;
double _AccelerometerTiltY = 0;

int distance = 0;
int numMiss = 5;
int maxNumMiss = 5;
double difficultyMod = 0;
int Score = 0;
int missileReloadTime = 20;

//events
TriggerAcction exitApp = TriggerAcction();

TriggerAcction pressedPlay = TriggerAcction();
TriggerAcction pressedRestart = TriggerAcction();
TriggerAcction pressedContinue = TriggerAcction();

TriggerAcction pauseGame = TriggerAcction();
TriggerAcction gameOver = TriggerAcction();
TriggerAcction fireMissile = TriggerAcction();

class p7_addtext extends FlameGame with HasCollisionDetection, HasTappables {
  Timer meteorTimer = Timer(0.7, repeat: true);
  Timer tracerTimer = Timer(0.3, repeat: true);
  Timer smallTracer = Timer(0.7, repeat: true);
  Timer DiffUp = Timer(100, repeat: true);
  Timer ScorreTicker = Timer(0.1, repeat: true);

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
    AudioPlayerComponent.PreloadTracks();
    AudioPlayerComponent.initBackgroundMusic();
    AudioPlayerComponent.bgmMenu();
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
      _AccelerometerTiltY = event.y;
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

    MenuOptExit optExit = MenuOptExit(await loadSprite("menu1s.png"));
    MenuOptPlay optPlay = MenuOptPlay(await loadSprite("menu1s.png"));
    MenuOptRestart optRestart = MenuOptRestart(await loadSprite("menu1s.png"));
    MenuOptContinue optContinue =
        MenuOptContinue(await loadSprite("menu1s.png"));
    optRestart.priority = 0;
    optContinue.priority = 0;

    optPlay.flipHorizontallyAroundCenter();
    optRestart.flipHorizontallyAroundCenter();
    add(optExit);
    add(optPlay);
    add(optRestart);
    add(optContinue);
    TextStyle style = TextStyle(color: BasicPalette.green.color);
    TextPaint regular = TextPaint(style: style);
    TextComponent scoreLabel = TextComponent();
    scoreLabel
      ..textRenderer = regular
      ..priority = 900
      ..text = "".padLeft(10, '0')
      ..anchor = Anchor.topRight
      ..size = Vector2(100, 100)
      ..x = _ScreenWidth - 10
      ..y = 30;

    style = TextStyle(color: BasicPalette.green.color, fontSize: 28);
    regular = TextPaint(style: style);
    TextComponent lblExit = TextComponent();
    lblExit
      ..textRenderer = regular
      ..priority = 900
      ..text = "EXIT"
      ..anchor = Anchor.center
      ..x = _ScreenWidth / 1.6
      ..y = _ScreenHeight / 2.93;
    TextComponent lblPlay = TextComponent();
    lblPlay
      ..textRenderer = regular
      ..priority = 900
      ..text = "PLAY"
      ..anchor = Anchor.center
      ..x = _ScreenWidth / 2.6
      ..y = _ScreenHeight / 1.9;
    TextComponent lblRestart = TextComponent();
    lblRestart
      ..textRenderer = regular
      ..priority = 0
      ..text = "RESSET RUN"
      ..anchor = Anchor.center
      ..x = _ScreenWidth / 2.6
      ..y = _ScreenHeight / 1.9;
    TextComponent lblContinue = TextComponent();
    lblContinue
      ..textRenderer = regular
      ..priority = 0
      ..text = "CONTINUE"
      ..anchor = Anchor.center
      ..x = _ScreenWidth / 1.6
      ..y = _ScreenHeight / 1.41;

    TextComponent lbldiff = TextComponent();
    lbldiff
      ..textRenderer = regular
      ..priority = 300
      ..text = ""
      ..anchor = Anchor.center
      ..x = _ScreenWidth / 4
      ..y = _ScreenHeight / 4;
    add(lbldiff);

    add(scoreLabel);
    add(lblExit);
    add(lblPlay);
    add(lblRestart);
    add(lblContinue);
    Spaceship spaceship = Spaceship(await loadSprite("Ship.png"));
    //add(spaceship);

    meteorTimer.start();
    meteorTimer.pause();
    ScorreTicker.pause();
    DiffUp.start();
    DiffUp.pause();
    //GAME MENU EVENTS
    pressedPlay.trigger = () async {
      meteorTimer.resume();
      DiffUp.resume();
      ScorreTicker.resume();
      optExit.priority = 0;
      optPlay.priority = 0;
      lblPlay.priority = 0;
      lblExit.priority = 0;
      difficultyMod = 0;
      Score = 0;
      add(spaceship);
      _GameOver = false;
    };
    pressedRestart.trigger = () async {
      print("restart");
      CleanGame();
      meteorTimer.resume();
      ScorreTicker.resume();
      tracerTimer.resume();
      smallTracer.resume();
      DiffUp.resume();
      optRestart.priority = 0;
      optContinue.priority = 0;
      optExit.priority = 0;
      lblExit.priority = 0;
      lblRestart.priority = 0;
      lblContinue.priority = 0;
      difficultyMod = 0;
      Score = 0;
      _GamePause = false;
      scoreLabel.text = "".padLeft(10, '0');
    };
    pressedContinue.trigger = () async {
      print("Continue");
      meteorTimer.resume();
      ScorreTicker.resume();
      DiffUp.resume();
      tracerTimer.resume();
      smallTracer.resume();
      optRestart.priority = 0;
      optContinue.priority = 0;
      optExit.priority = 0;
      lblExit.priority = 0;
      lblRestart.priority = 0;
      lblContinue.priority = 0;
      _GamePause = false;
    };

    //GAME STOP EVENTS
    gameOver.trigger = () async {
      print("Clean &&  main menu");
      meteorTimer.pause();
      ScorreTicker.pause();
      DiffUp.pause();
      CleanGame();
      scoreLabel.text = "".padLeft(10, '0');
      optExit.priority = 100;
      optPlay.priority = 100;
      lblExit.priority = 200;
      lblPlay.priority = 200;
    };
    pauseGame.trigger = () async {
      print("pauseGame");
      meteorTimer.pause();
      ScorreTicker.pause();
      tracerTimer.pause();
      smallTracer.pause();
      DiffUp.pause();
      //show armas
      optExit.priority = 100;
      optRestart.priority = 100;
      optContinue.priority = 100;
      lblExit.priority = 200;
      lblRestart.priority = 200;
      lblContinue.priority = 200;
    };
    exitApp.trigger = () async {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    };
    tracerTimer.onTick = () async {
      setSize = operations.RandomDouble(30, 60);
      Tracer tracer =
          Tracer(Sprite(images.fromCache("TraceWhite.png")), setSize);
      add(tracer);
    };
    smallTracer.onTick = () async {
      TracerPoint tracer =
          TracerPoint(Sprite(images.fromCache("TraceWhite.png")));
      add(tracer);
    };
    //GAME EVENTS
    DiffUp.onTick = () async {
      if (difficultyMod <= 2) {
        //  difficultyMod += 1;
      }

      if (_DebugMode) {
        lbldiff.text = difficultyMod.toString();
      }
    };
    ScorreTicker.onTick = () async {
      Score += 1;
      scoreLabel.text = Score.toString().padLeft(10, '0');
    };
    meteorTimer.onTick = () async {
      print("GenMeteor");
      for (var i = 0; i < 1 + difficultyMod; i++) {
        setSize = operations.RandomDouble(20, 80);
        Asteroid asteroid = Asteroid(
          Sprite(images.fromCache(StackAsteroid.SendToLast())),
          setSize,
        );
        add(asteroid);
      }
    };
    fireMissile.trigger = () async {
      Missile missile =
          Missile(await loadSprite("missile.png"), spaceship.x, spaceship.y);
      add(missile);

      missileLed(false);
    };
  }

  //update
  @override
  void update(double dt) {
    super.update(dt);
    tracerTimer.update(dt);
    meteorTimer.update(dt);
    smallTracer.update(dt);

    DiffUp.update(dt);
    ScorreTicker.update(dt);
  }

  void missileLed(bool encender) {
    Sprite s;
    if (encender) {
      s = Sprite(images.fromCache("btnON.png"));
      numMiss += 1;
    } else {
      s = Sprite(images.fromCache("btnOFF.png"));
      Future.delayed(Duration(seconds: missileReloadTime), () {
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
      try {
        if (item.runtimeType == Asteroid) {
          item.removeFromParent();
        } else if (item.runtimeType == Missile) {
          item.removeFromParent();
        }
      } catch (e) {
        print("aaaaaaaaaaaaaaaaaaaaaa");
      }
    }
  }
}
//TEXT PRESSET

//classes
class MenuOptExit extends SpriteComponent with Tappable {
  MenuOptExit(Sprite img) {
    this.sprite = img;
    size = Vector2(700, 170);
    anchor = Anchor.centerRight;
    priority = 300;
    x = _ScreenWidth - 10;
    y = _ScreenHeight / 2.5;
  }
  @override
  bool onTapDown(TapDownInfo info) {
    try {
      if (_GamePause || _GameOver) {
        AudioPlayerComponent.menu();
        print("exit");
        //SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
        //SystemNavigator.pop();
        exit(0);
      }
      print("no exit");
      return true;
    } catch (error) {
      print("pause unable");
      return false;
    }
  }
}

class MenuOptPlay extends SpriteComponent with Tappable {
  MenuOptPlay(Sprite img) {
    this.sprite = img;
    size = Vector2(700, 170);
    anchor = Anchor.centerLeft;
    priority = 310;
    x = 10;
    y = _ScreenHeight / 1.7;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      if (_GameOver) {
        AudioPlayerComponent.menu();
        AudioPlayerComponent.bgmCombat1();
        print("start");
        pressedPlay.CallAction();
      }
      return true;
    } catch (error) {
      print("pause unable");
      return false;
    }
  }
}

class MenuOptRestart extends SpriteComponent with Tappable {
  MenuOptRestart(Sprite img) {
    this.sprite = img;
    size = Vector2(700, 170);
    anchor = Anchor.centerLeft;
    priority = 310;
    x = 10;
    y = _ScreenHeight / 1.7;
  }
  @override
  bool onTapDown(TapDownInfo info) {
    try {
      print("restart");
      if (_GamePause) {
        AudioPlayerComponent.menu();
        AudioPlayerComponent.bgmCombat1();

        if (pressedRestart._running) {
          pressedRestart.CallAction();
        } else {
          AudioPlayerComponent.error();
        }
      }
      return true;
    } catch (error) {
      print("pause unable");
      return false;
    }
  }
}

class MenuOptContinue extends SpriteComponent with Tappable {
  MenuOptContinue(Sprite img) {
    this.sprite = img;
    size = Vector2(700, 170);
    anchor = Anchor.centerRight;
    priority = 300;
    x = _ScreenWidth - 10;
    y = _ScreenHeight / 1.3;
  }
  @override
  bool onTapDown(TapDownInfo info) {
    try {
      if (_GamePause) {
        AudioPlayerComponent.menu();
        AudioPlayerComponent.bgmCombat2();
        print("continue2");
        pressedContinue.CallAction();
      }
      return true;
    } catch (error) {
      print("pause unable");
      return false;
    }
  }
}

class PauseGameButton extends SpriteComponent with Tappable {
  PauseGameButton(Sprite img) {
    this.sprite = img;
    size = Vector2(35, 35);
    priority = 200;
    anchor = Anchor.topLeft;
    x = 21.5;
    y = 47.5;
    setAlpha(100);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      if (!_GameOver && !_GamePause) {
        AudioPlayerComponent.menu();
        AudioPlayerComponent.bgmPause();
        _GamePause = true;
        pauseGame.CallAction();
      } else {
        AudioPlayerComponent.error();
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
    } else if (other is Missile) {
      other.removeFromParent();
    } else if (other is Tracer && other.y > _ScreenHeight) {
      other.removeFromParent();
    } else if (other is TracerPoint) {
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
    y = _ScreenHeight - 75 / 2 - 20;
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

    if (!_GamePause) {
      double shipWidth = this.size[0];
      double posX = this.x;
      double posY = this.y;
      double newPosX, newPosY;
      //if (tilt.abs() > 1) {
      newPosX = this.x + _AccelerometerTilt * -2;
      newPosY = this.y + _AccelerometerTiltY * 2;

      if (newPosX - shipWidth / 2 > 0 &&
          newPosX + shipWidth / 2 < _ScreenWidth) {
        this.x = newPosX;
      }
      if (newPosY - shipWidth / 2 > 30 &&
          newPosY + shipWidth / 2 < _ScreenHeight) {
        this.y = newPosY;
      }
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Asteroid) {
      AudioPlayerComponent.large_explosion();
      gameOver.CallAction();
      _GameOver = true;
      AudioPlayerComponent.bgmMenu();
      this.removeFromParent();
    } else if (other is Asteroid) {}
  }

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      print("fire");
      if (numMiss > 0 && !_GameOver && !_GamePause) {
        AudioPlayerComponent.missileLaunch();
        fireMissile.CallAction();
      } else {}

      return true;
    } catch (error) {
      print("fire unable");
      return false;
    }
  }
}

class TracerPoint extends SpriteComponent with CollisionCallbacks {
  TracerPoint(Sprite sprite) {
    this.sprite = sprite;
    priority = 20;
    setAlpha(200);
    anchor = Anchor.center;
    size = Vector2(2, 2);
    x = operations.RandomDouble(0, _ScreenWidth);
    y = 30;
  }
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_GamePause) {
      this.y += dt * 20;
    }
  }
}

class Tracer extends SpriteComponent with CollisionCallbacks {
  Tracer(Sprite sprite, double setSize) {
    this.sprite = sprite;
    priority = 20;
    setAlpha(100);
    anchor = Anchor.center;
    size = Vector2(2, setSize);
    x = operations.RandomDouble(0, _ScreenWidth);
    y = -2 * setSize;
  }
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_GamePause) {
      this.y += dt * math.pow(this.size[1], 3) / 100;
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
    size = Vector2(20, 50);
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
      this.y += -200 * dt;
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Asteroid) {
      AudioPlayerComponent.small_explosion();
      other.removeFromParent();
      this.removeFromParent();
    }
  }
}

//PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE////PAUSE//
/*
class PauseGame extends SpriteComponent with Tappable {
  PauseGame(Sprite sprite) {
    this.sprite = sprite;
    priority = 150;
    size = Vector2(100, 20);
    anchor = Anchor.center;
    x = 30;
    y = 30;
  }
  @override
  bool onTapDown(TapDownInfo info) {
    try {
      pauseGame.CallAction();

      return true;
    } catch (error) {
      return false;
    }
  }
}*/

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
