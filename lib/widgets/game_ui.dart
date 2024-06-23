import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class GameUi extends StatelessWidget {
  const GameUi({
    super.key,
    required ValueListenable<int> score,
    required void Function() pauseGame,
  })  : _score = score,
        _pauseGame = pauseGame;

  final ValueListenable<int> _score;
  final void Function() _pauseGame;

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
            valueListenable: _score,
            builder: (context, score, child) => Text(
              'Score: $score',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const Gap(
            16,
            crossAxisExtent: 16,
          ),
          ElevatedButton(
            onPressed: _pauseGame,
            child: const Text('Pause'),
          ),
        ],
      ),
    );
  }
}
