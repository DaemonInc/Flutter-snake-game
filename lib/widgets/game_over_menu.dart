import 'package:flutter/material.dart';
import 'package:flutter_snake_game/widgets/overlay_menu.dart';
import 'package:gap/gap.dart';

class GameOverMenu extends StatelessWidget {
  const GameOverMenu({
    super.key,
    required int score,
    required void Function() restart,
  })  : _score = score,
        _restart = restart;

  final int _score;
  final void Function() _restart;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OverlayMenu(
        title: 'Game Over',
        content: [
          Text('Score: $_score'),
          const Gap(16),
          ElevatedButton(
            onPressed: _restart,
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
