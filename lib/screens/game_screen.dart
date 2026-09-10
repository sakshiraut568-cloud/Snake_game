import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/game_board.dart';
import '../widgets/score_card.dart';
import '../widgets/direction_controls.dart';
import '../widgets/game_button.dart';
import '../models/snake.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameProvider>(context, listen: false).startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            
            // Handle Game Over navigation
            if (gameProvider.isGameOver) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const GameOverScreen())
                );
              });
            }

            return Stack(
              children: [
                Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ScoreCard(title: 'Score', value: '${gameProvider.score}'),
                          IconButton(
                            icon: const Icon(Icons.pause, color: Colors.white, size: 32),
                            onPressed: () {
                              gameProvider.pauseGame();
                            },
                          ),
                          ScoreCard(title: 'Best', value: '${gameProvider.bestScore}', icon: Icons.emoji_events),
                        ],
                      ),
                    ),
                    
                    // Game Board
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GestureDetector(
                          onVerticalDragUpdate: settings.controlType == 'Swipe' ? (details) {
                            if (details.delta.dy > 0) gameProvider.changeDirection(Direction.down);
                            else if (details.delta.dy < 0) gameProvider.changeDirection(Direction.up);
                          } : null,
                          onHorizontalDragUpdate: settings.controlType == 'Swipe' ? (details) {
                            if (details.delta.dx > 0) gameProvider.changeDirection(Direction.right);
                            else if (details.delta.dx < 0) gameProvider.changeDirection(Direction.left);
                          } : null,
                          child: const Center(child: GameBoard()),
                        ),
                      ),
                    ),

                    // Optional Controls
                    if (settings.controlType == 'Buttons')
                      const Expanded(
                        flex: 3,
                        child: DirectionControls(),
                      )
                    else
                      const Expanded(flex: 1, child: SizedBox.shrink()),
                  ],
                ),

                // Pause Overlay
                if (gameProvider.isPaused)
                  Container(
                    color: Colors.black87,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryGreen, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Paused', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 32),
                            GameButton(
                              text: 'Resume',
                              icon: Icons.play_arrow,
                              onPressed: () => gameProvider.resumeGame(),
                            ),
                            const SizedBox(height: 16),
                            GameButton(
                              text: 'Restart',
                              icon: Icons.refresh,
                              isOutline: true,
                              onPressed: () {
                                gameProvider.startGame();
                              },
                            ),
                            const SizedBox(height: 16),
                            GameButton(
                              text: 'Home',
                              icon: Icons.home,
                              isOutline: true,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
