import 'package:flutter/material.dart';
import 'package:flutter_snake_game/widgets/overlay_menu.dart';
import 'package:flutter_snake_game/services/game_service.dart';

class PauseGameMenu extends StatelessWidget {
  const PauseGameMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OverlayMenu(
        title: 'Pause Menu',
        content: [
          ElevatedButton(
            onPressed: () =>
                GameService.instance.startGame(GameService.instance.config),
            child: const Text('Restart Game'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => GameService.instance.resumeGame(),
            child: const Text('Resume Game'),
          ),
        ],
      ),
    );
  }
}
