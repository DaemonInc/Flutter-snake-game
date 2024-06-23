import 'package:flutter/material.dart';
import 'package:flutter_snake_game/services/game_service.dart';
import 'package:flutter_snake_game/services/score_service.dart';
import 'package:gap/gap.dart';

class GameUi extends StatelessWidget {
  const GameUi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 200,
        minHeight: 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          ValueListenableBuilder(
            valueListenable: ScoreService.instance.score,
            builder: (context, value, child) => Text(
              'Score: $value',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const Gap(
            16,
            crossAxisExtent: 16,
          ),
          ElevatedButton(
            onPressed: GameService.instance.pauseGame,
            child: const Text('Pause'),
          ),
        ],
      ),
    );
  }
}
