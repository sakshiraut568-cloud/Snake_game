import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/app_constants.dart';
import '../utils/app_colors.dart';
import 'snake_widget.dart';
import 'food_widget.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return AspectRatio(
          aspectRatio: AppConstants.gridColumns / AppConstants.gridRows,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              border: Border.all(color: AppColors.secondaryBlue, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppConstants.gridRows * AppConstants.gridColumns,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AppConstants.gridColumns,
              ),
              itemBuilder: (context, index) {
                if (gameProvider.snake.body.contains(index)) {
                  bool isHead = gameProvider.snake.body.last == index;
                  return SnakeWidget(
                    isHead: isHead,
                    color: gameProvider.currentSkinColor,
                  );
                } else if (gameProvider.food.position == index) {
                  return const FoodWidget();
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.gridLineColor.withOpacity(0.3), width: 0.5),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
