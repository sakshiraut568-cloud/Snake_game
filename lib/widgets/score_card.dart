import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ScoreCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const ScoreCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.goldCoin, size: 16),
              const SizedBox(width: 4),
            ],
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: AppColors.textWhite, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
