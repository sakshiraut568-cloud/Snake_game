import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class FoodWidget extends StatelessWidget {
  const FoodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: AppColors.foodRed,
        shape: BoxShape.circle,
      ),
    );
  }
}
