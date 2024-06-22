import 'dart:math';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_game/enums/game_overlays.dart';
import 'package:flutter_snake_game/services/game_service.dart';
import 'package:flutter_snake_game/widgets/game_ui.dart';
import 'package:gap/gap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.setOrientation(DeviceOrientation.portraitUp);
  runApp(const MainGame());
}

class MainGame extends StatelessWidget {
  const MainGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: const BoxDecoration(color: Color(0xFFE5E5E5)),
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = min(constraints.maxWidth, constraints.maxHeight);
            final direction = constraints.biggest.aspectRatio > 1
                ? Axis.horizontal
                : Axis.vertical;
            return Flex(
              direction: direction,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: size,
                          maxHeight: size,
                        ),
                        child: GameWidget.controlled(
                          gameFactory: () => GameService.instance,
                          loadingBuilder: (_) => const Center(
                            child: CircularProgressIndicator(
                              color: Colors.greenAccent,
                            ),
                          ),
                          overlayBuilderMap: GameOverlays.overlayBuilderMap,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                GameUi(
                  direction: direction == Axis.vertical
                      ? Axis.horizontal
                      : Axis.vertical,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
