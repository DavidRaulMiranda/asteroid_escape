//tests
import 'package:asteroid_escape/p1test_addSprite.dart';
import 'package:asteroid_escape/p2_test_move_acceleromeer.dart';
import 'package:asteroid_escape/p5_menus_text_buttons.dart';
import 'p3_test_spawn.dart';
import 'p4_test_colision.dart';
//
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'game_compo.dart';
import '_sprites_compo.dart';

void main() {
  final myGame = Test_Menus2();
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}
