import 'package:flutter/material.dart';
import 'package:flutter_snake_game/services/game_service.dart';
import 'package:flutter_snake_game/services/score_service.dart';
import 'package:gap/gap.dart';

class GameUi extends StatelessWidget {
  const GameUi({
    super.key,
    required this.direction,
  });

  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: direction == Axis.vertical ? 200 : 0,
        minHeight: direction == Axis.horizontal ? 100 : 0,
      ),
      child: Flex(
        direction: direction,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ValueListenableBuilder(
            valueListenable: ScoreService.instance.score,
            builder: (context, value, child) => Text(
              'Score: $value',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const Gap(16),
          ElevatedButton(
            onPressed: GameService.instance.pauseGame,
            child: const Text('Pause'),
          ),
        ],
      ),
    );
  }
}
