import 'package:flutter/material.dart';
import 'package:flutter_snake_game/widgets/overlay_menu.dart';

class PauseGameMenu extends StatelessWidget {
  const PauseGameMenu({
    super.key,
    required void Function() onResume,
    required void Function() onRestart,
  })  : _restart = onRestart,
        _resume = onResume;

  final void Function() _restart;
  final void Function() _resume;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OverlayMenu(
        title: 'Pause Menu',
        content: [
          ElevatedButton(
            onPressed: _restart,
            child: const Text('Restart Game'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resume,
            child: const Text('Resume Game'),
          ),
        ],
      ),
    );
  }
}
