import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_game/enums/game_overlays.dart';
import 'package:flutter_snake_game/services/game_service.dart';
import 'package:flutter_snake_game/services/score_service.dart';
import 'package:flutter_snake_game/widgets/game_ui.dart';
import 'package:gap/gap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainGame());
}

class MainGame extends StatelessWidget {
  MainGame({super.key});

  final _gameService = GameService.instance;
  final _scoreService = ScoreService.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: const BoxDecoration(color: Color(0xFFE5E5E5)),
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final direction = constraints.biggest.aspectRatio > 1
                ? Axis.horizontal
                : Axis.vertical;
            return Flex(
              direction: direction,
              children: [
                Expanded(
                  child: ClipRect(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: GameWidget.controlled(
                        gameFactory: () => _gameService,
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
                const Gap(16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GameUi(
                    pauseGame: _gameService.pauseGame,
                    score: _scoreService.score,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
