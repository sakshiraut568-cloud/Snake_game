import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

class Snake {
  List<int> body;
  Direction currentDirection;

  Snake({
    required this.body,
    required this.currentDirection,
  });
}
