//Game
import 'package:asteroid_escape/Core_Game.dart';

//

import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

void main() {
  //lock screen in vertical mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final myGame = AsteroidEvadeGame();
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}
