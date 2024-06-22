import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_game/enums/game_overlays.dart';
import 'package:flutter_snake_game/models/game_config.dart';
import 'package:flutter_snake_game/services/game_service.dart';
import 'package:flutter_snake_game/services/input_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setOrientation(DeviceOrientation.portraitUp);
  runApp(MainGame());
}

class MainGame extends StatelessWidget {
  MainGame({super.key});

  final config = GameConfig(
    gridSize: Vector2(20, 20),
    snakeStartLength: 3,
    gameSpeed: 2.0,
  );

  final inputService = InputService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFE5E5E5)),
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = min(constraints.maxWidth, constraints.maxHeight);
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: size,
                maxHeight: size,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GameWidget.controlled(
                    gameFactory: () => GameService(
                      config: config,
                      inputService: inputService,
                    ),
                    loadingBuilder: (_) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                      ),
                    ),
                    overlayBuilderMap: GameOverlays.overlayBuilderMap,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
