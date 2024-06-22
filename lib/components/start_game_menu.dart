import 'package:flutter/material.dart';
import 'package:flutter_snake_game/components/overlay_menu_wrap.dart';
import 'package:flutter_snake_game/models/game_config.dart';
import 'package:flutter_snake_game/services/game_service.dart';

class StartGameMenu extends StatelessWidget {
  const StartGameMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OverlayMenuWrap(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Start Game Menu',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                GameService.instance.startGame(GameConfig.normal());
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}
