import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/app_colors.dart';
import 'package:intl/intl.dart';

class HighScoresScreen extends StatelessWidget {
  const HighScoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('High Scores'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false).clearHighScores();
            },
          )
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          final scores = gameProvider.highScores;

          if (scores.isEmpty) {
            return const Center(child: Text('No scores yet!', style: TextStyle(color: Colors.white70, fontSize: 18)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final score = scores[index];
              final date = DateTime.parse(score.date);
              final formattedDate = DateFormat('MMM dd, yyyy - HH:mm').format(date);

              return Card(
                color: index == 0 ? AppColors.primaryGreen.withOpacity(0.2) : Colors.white10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Text('#${index + 1}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  title: Text(formattedDate, style: const TextStyle(color: Colors.white70)),
                  trailing: Text(
                    '${score.score}',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold, 
                      color: index == 0 ? AppColors.goldCoin : Colors.white
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
