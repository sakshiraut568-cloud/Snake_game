import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class GameButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final bool isOutline;

  const GameButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = color ?? AppColors.primaryGreen;

    if (isOutline) {
      return OutlinedButton.icon(
        icon: icon != null ? Icon(icon, color: AppColors.textWhite) : const SizedBox.shrink(),
        label: Text(text, style: const TextStyle(color: AppColors.textWhite)),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: bgColor, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      );
    }

    return ElevatedButton.icon(
      icon: icon != null ? Icon(icon, color: AppColors.textWhite) : const SizedBox.shrink(),
      label: Text(text, style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 18)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    );
  }
}
