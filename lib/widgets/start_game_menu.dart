import 'package:flutter/material.dart';
import 'package:flutter_snake_game/widgets/overlay_menu.dart';

class StartGameMenu extends StatelessWidget {
  const StartGameMenu({
    super.key,
    required void Function() startGame,
  }) : _startGame = startGame;

  final void Function() _startGame;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OverlayMenu(
        title: 'Start Game Menu',
        content: [
          ElevatedButton(
            onPressed: _startGame,
            child: const Text('Start Game'),
          ),
        ],
      ),
    );
  }
}
