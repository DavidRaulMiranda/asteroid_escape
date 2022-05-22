import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:asteroid_escape/operations.dart';
/*
class Asteroid extends SpriteComponent with Hitbox, Collidable {
  // colision
  Asteroid(Sprite sprite) {
    this.sprite = sprite;
    size = Vector2(100.0, 100.0);
    anchor = Anchor.center;
    position = Vector2(100.0, 50.0);
    addShape(RectangleHitbox());
  }
}*/

class Ship extends SpriteComponent {
  Ship(Sprite sprite) {
    this.sprite = sprite;
    size = Vector2(100.0, 100.0);
    anchor = Anchor.center;
    position = Vector2(100.0, 50.0);
  }
}

class Missile extends SpriteComponent {
  Missile(Sprite sprite) {
    this.sprite = sprite;
    size = Vector2(100.0, 100.0);
    anchor = Anchor.center;
    position = Vector2(100.0, 50.0);
  }
}

//non trace
class Trace extends SpriteComponent {
  Trace(Sprite sprite) {
    this.sprite = sprite;
    size = Vector2(100.0, 100.0);
    anchor = Anchor.center;
    position = Vector2(100.0, 50.0);
  }
}

//sprites v2:
class SpaceShip2 extends SpriteComponent {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  SpaceShip2() : super(size: Vector2.all(16));

  Future<void> onLoad() async {
    sprite = await Sprite.load('Ship.png');
    anchor = Anchor.center;
    size = Vector2(60, 60);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // We don't need to set the position in the constructor, we can set it directly here since it will
    // be called once before the first time it is rendered.
    position = gameSize / 2;
  }
}

class Meteorite extends SpriteComponent {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  Meteorite() : super(size: Vector2.all(16));

  Future<void> onLoad() async {
    sprite = await Sprite.load('Ship.png');
    anchor = Anchor.center;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // We don't need to set the position in the constructor, we can set it directly here since it will
    // be called once before the first time it is rendered.
    position = gameSize / 2;
  }
}

class Tracer extends SpriteComponent {
  late int b;
  // creates a component that renders the crate.png sprite, with size 16 x 16
  Tracer() : super(size: Vector2.all(16));

  Future<void> onLoad() async {
    sprite = await Sprite.load('TraceBlue.png');
    anchor = Anchor.center;
    size = Vector2(2, operations.RandomIntVal(0, 40).toDouble());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // We don't need to set the position in the constructor, we can set it directly here since it will
    // be called once before the first time it is rendered.
    // position = gameSize / 2;
    position = Vector2(
        operations.RandomIntVal(0, gameSize.x.toInt()).toDouble(),
        operations.RandomIntVal(0, gameSize.y.toInt()).toDouble());
    /*
    b = gameSize.x.round();
    position = Vector2(0, operations.RandomIntVal(0, b).toDouble());*/
  }
}
