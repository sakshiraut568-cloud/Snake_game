import 'package:flutter/material.dart';

class SnakeWidget extends StatelessWidget {
  final bool isHead;
  final Color color;

  const SnakeWidget({super.key, required this.isHead, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(isHead ? 6 : 4),
      ),
      child: isHead
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
                ],
              ),
            )
          : null,
    );
  }
}
