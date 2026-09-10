import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/snake.dart';

class DirectionControls extends StatelessWidget {
  const DirectionControls({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildArrowBtn(Icons.keyboard_arrow_up, () => gameProvider.changeDirection(Direction.up)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildArrowBtn(Icons.keyboard_arrow_left, () => gameProvider.changeDirection(Direction.left)),
            const SizedBox(width: 60), // space for center
            _buildArrowBtn(Icons.keyboard_arrow_right, () => gameProvider.changeDirection(Direction.right)),
          ],
        ),
        _buildArrowBtn(Icons.keyboard_arrow_down, () => gameProvider.changeDirection(Direction.down)),
      ],
    );
  }

  Widget _buildArrowBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, size: 36, color: Colors.white),
      ),
    );
  }
}
