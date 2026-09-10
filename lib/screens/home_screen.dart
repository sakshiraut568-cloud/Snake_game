import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/game_button.dart';
import 'game_screen.dart';
import 'high_scores_screen.dart';
import 'shop_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.catching_pokemon, size: 80, color: AppColors.primaryGreen),
              const SizedBox(height: 16),
              const Text(
                'SNAKE GAME',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.textWhite),
              ),
              const SizedBox(height: 8),
              Consumer<GameProvider>(
                builder: (context, gameProvider, child) {
                  return Text(
                    'Best Score: ${gameProvider.bestScore}',
                    style: const TextStyle(fontSize: 20, color: AppColors.goldCoin),
                  );
                },
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: 250,
                child: GameButton(
                  text: 'Play',
                  icon: Icons.play_arrow,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GameScreen()));
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 250,
                child: GameButton(
                  text: 'High Scores',
                  icon: Icons.emoji_events,
                  isOutline: true,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HighScoresScreen()));
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 250,
                child: GameButton(
                  text: 'Shop',
                  icon: Icons.shopping_cart,
                  isOutline: true,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShopScreen()));
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 250,
                child: GameButton(
                  text: 'Settings',
                  icon: Icons.settings,
                  isOutline: true,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
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
