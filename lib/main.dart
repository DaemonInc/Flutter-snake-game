import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_game/enums/game_overlays.dart';
import 'package:flutter_snake_game/models/game_config.dart';
import 'package:flutter_snake_game/widgets/background_grid.dart';
import 'package:flutter_snake_game/widgets/snake_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setOrientation(DeviceOrientation.portraitUp);
  runApp(const MainGame());
}

class MainGame extends StatelessWidget {
  const MainGame({super.key});

  final config = const GameConfig(
    gridSize: Offset(20, 20),
    snakeStartLength: 3,
    gameSpeed: 1.0,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0xFFE5E5E5)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = min(constraints.maxWidth, constraints.maxHeight);

          return Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size,
                maxHeight: size,
              ),
              // padding: const EdgeInsets.all(8.0),
              child: GameWidget.controlled(
                gameFactory: () => SnakeGame(
                  config: config,
                  boardSize: Offset(size, size),
                ),
                backgroundBuilder: (context) => SizedBox.expand(
                  child: CustomPaint(
                    painter: GridBackground(gridSize: config.gridSize),
                  ),
                ),
                loadingBuilder: (_) => const Center(
                  child: CircularProgressIndicator(
                    color: Colors.greenAccent,
                  ),
                ),
                overlayBuilderMap: {
                  GameOverlays.pauseMenu.name: (context, game) =>
                      const MenuWrap(
                        child: Text('Pause Menu'),
                      ),
                  GameOverlays.gameOverMenu.name: (context, game) =>
                      const MenuWrap(
                        child: Text('Game over Menu'),
                      ),
                },
              ),
            ),
          );
        },
      ),
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
