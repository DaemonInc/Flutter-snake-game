import 'package:flutter/material.dart';
import 'package:flutter_snake_game/services/score_service.dart';
import 'package:flutter_snake_game/widgets/overlay_menu.dart';
import 'package:flutter_snake_game/services/game_service.dart';
import 'package:gap/gap.dart';

class GameOverMenu extends StatelessWidget {
  const GameOverMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OverlayMenu(
        title: 'Game Over',
        content: [
          Text('Score: ${ScoreService.instance.score.value}'),
          const Gap(16),
          ElevatedButton(
            onPressed: () =>
                GameService.instance.startGame(GameService.instance.config),
            child: const Text(
              'Restart Game',
              textAlign: TextAlign.center,
              textWidthBasis: TextWidthBasis.longestLine,
            ),
          ),
        ],
      ),
    );
  }
}
