import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_game/enums/game_overlays.dart';
import 'package:flutter_snake_game/widgets/snake_game.dart';

void main() {
  runApp(const MainGame());
}

class MainGame extends StatelessWidget {
  const MainGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget.controlled(
      gameFactory: SnakeGame.new,
      loadingBuilder: (_) => const Center(
        child: CircularProgressIndicator(
          color: Colors.greenAccent,
        ),
      ),
      overlayBuilderMap: {
        GameOverlays.pauseMenu.name: (context, game) => const MenuWrap(
              child: Text('Pause Menu'),
            ),
        GameOverlays.gameOverMenu.name: (context, game) => const MenuWrap(
              child: Text('Game over Menu'),
            ),
      },
    );
  }
}

class MenuWrap extends StatelessWidget {
  const MenuWrap({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.75),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: child,
      ),
    );
  }
}
