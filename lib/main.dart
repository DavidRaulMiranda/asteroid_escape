//tests
import 'package:asteroid_escape/p1test_addSprite.dart';
import 'package:asteroid_escape/p2_test_move_acceleromeer.dart';
//
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'game_compo.dart';
import 'p3_test_spawn.dart';
import 'sprites_compo.dart';

void main() {
  final myGame = Test_spawn();
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}
