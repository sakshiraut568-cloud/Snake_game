import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/game_button.dart';
import 'game_screen.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game Over',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Better luck next time!',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Your Score', style: TextStyle(color: Colors.white70)),
                      Text('${gameProvider.score}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.emoji_events, color: AppColors.goldCoin),
                          SizedBox(width: 4),
                          Text('Best Score', style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                      Text('${gameProvider.bestScore}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Food Collected: ${gameProvider.foodCollected}', style: const TextStyle(color: AppColors.primaryGreen, fontSize: 16)),
              const SizedBox(height: 48),
              SizedBox(
                width: 250,
                child: GameButton(
                  text: 'Play Again',
                  icon: Icons.refresh,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const GameScreen()));
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 250,
                child: GameButton(
                  text: 'Home',
                  icon: Icons.home,
                  isOutline: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
