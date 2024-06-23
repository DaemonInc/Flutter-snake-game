import 'package:flutter/material.dart';
import 'package:flutter_snake_game/widgets/overlay_menu.dart';
import 'package:flutter_snake_game/models/game_config.dart';
import 'package:flutter_snake_game/services/game_service.dart';

class StartGameMenu extends StatelessWidget {
  const StartGameMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OverlayMenu(
        title: 'Start Game Menu',
        content: [
          ElevatedButton(
            onPressed: () {
              GameService.instance.startGame(GameConfig.easy());
            },
            child: const Text('Start Game'),
          ),
        ],
      ),
    );
  }
}
