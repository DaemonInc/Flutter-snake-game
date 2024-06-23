import 'package:flutter/material.dart';
import 'package:flutter_snake_game/widgets/game_over_menu.dart';
import 'package:flutter_snake_game/widgets/pause_game_menu.dart';
import 'package:flutter_snake_game/widgets/start_game_menu.dart';
import 'package:flutter_snake_game/services/game_service.dart';

enum GameOverlays {
  startGameMenu,
  pauseMenu,
  gameOverMenu,
  ;

  static Map<String, Widget Function(BuildContext, GameService)>
      get overlayBuilderMap => {
            GameOverlays.startGameMenu.name: (context, game) => StartGameMenu(
                  startGame: game.startGame,
                ),
            GameOverlays.pauseMenu.name: (context, game) => PauseGameMenu(
                  onResume: game.resumeGame,
                  onRestart: game.startGame,
                ),
            GameOverlays.gameOverMenu.name: (context, game) => GameOverMenu(
                  score: game.score,
                  restart: game.startGame,
                ),
          };
}
