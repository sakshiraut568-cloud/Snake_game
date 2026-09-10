import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/snake.dart';
import '../models/food.dart';
import '../models/game_score.dart';
import '../models/snake_skin.dart';
import '../services/storage_service.dart';
import '../utils/app_constants.dart';

class GameProvider extends ChangeNotifier {
  final StorageService _storage;

  // Game state
  bool isPlaying = false;
  bool isPaused = false;
  bool isGameOver = false;

  Snake snake = Snake(body: [45, 65, 85], currentDirection: Direction.down);
  Food food = Food(position: 100);
  
  int score = 0;
  int foodCollected = 0;
  Timer? _timer;
  int _currentSpeed = AppConstants.initialSpeedMs;

  final Random _random = Random();

  GameProvider(this._storage);

  int get bestScore => _storage.bestScore;
  int get coins => _storage.coins;
  List<GameScore> get highScores => _storage.highScores;

  // Skins data
  final List<SnakeSkin> availableSkins = [
    SnakeSkin(id: 'classic_green', name: 'Classic', price: 0, color: Colors.green),
    SnakeSkin(id: 'red_snake', name: 'Red Snake', price: 250, color: Colors.red),
    SnakeSkin(id: 'blue_snake', name: 'Blue Snake', price: 250, color: Colors.blue),
    SnakeSkin(id: 'yellow_snake', name: 'Yellow Snake', price: 250, color: Colors.yellow),
    SnakeSkin(id: 'purple_snake', name: 'Purple Snake', price: 250, color: Colors.purple),
    SnakeSkin(id: 'black_snake', name: 'Black Snake', price: 250, color: Colors.black),
  ];

  String get selectedSkinId => _storage.selectedSkin;
  Color get currentSkinColor {
    return availableSkins.firstWhere((s) => s.id == selectedSkinId).color;
  }
  
  List<String> get purchasedSkins => _storage.purchasedSkins;

  void startGame() {
    isPlaying = true;
    isPaused = false;
    isGameOver = false;
    score = 0;
    foodCollected = 0;
    _currentSpeed = AppConstants.initialSpeedMs;
    snake = Snake(
      body: [
        4 + 2 * AppConstants.gridColumns,
        4 + 3 * AppConstants.gridColumns,
        4 + 4 * AppConstants.gridColumns
      ], 
      currentDirection: Direction.down
    );
    _generateFood();
    _startTimer();
    notifyListeners();
  }

  void pauseGame() {
    isPaused = true;
    _timer?.cancel();
    notifyListeners();
  }

  void resumeGame() {
    isPaused = false;
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: _currentSpeed), (timer) {
      _updateSnake();
    });
  }

  void changeDirection(Direction newDirection) {
    if (isPaused || !isPlaying) return;
    
    // Prevent 180-degree turns
    if (snake.currentDirection == Direction.up && newDirection == Direction.down) return;
    if (snake.currentDirection == Direction.down && newDirection == Direction.up) return;
    if (snake.currentDirection == Direction.left && newDirection == Direction.right) return;
    if (snake.currentDirection == Direction.right && newDirection == Direction.left) return;

    snake.currentDirection = newDirection;
  }

  void _updateSnake() {
    final head = snake.body.last;
    int nextHead = head;

    switch (snake.currentDirection) {
      case Direction.up:
        nextHead = head - AppConstants.gridColumns;
        break;
      case Direction.down:
        nextHead = head + AppConstants.gridColumns;
        break;
      case Direction.left:
        // Moving left from the left edge wraps to the right edge (or crashes, depending on logic)
        // We implement crash on walls
        if (head % AppConstants.gridColumns == 0) {
          _gameOver();
          return;
        }
        nextHead = head - 1;
        break;
      case Direction.right:
        if ((head + 1) % AppConstants.gridColumns == 0) {
          _gameOver();
          return;
        }
        nextHead = head + 1;
        break;
    }

    // Check wall collision for up/down
    if (nextHead < 0 || nextHead >= AppConstants.gridRows * AppConstants.gridColumns) {
      _gameOver();
      return;
    }

    // Check self collision
    if (snake.body.contains(nextHead)) {
      _gameOver();
      return;
    }

    snake.body.add(nextHead);

    // Check food collision
    if (nextHead == food.position) {
      score += AppConstants.pointsPerFood;
      foodCollected++;
      _storage.setCoins(_storage.coins + AppConstants.coinsPerFood);
      
      // Increase speed slightly
      if (_currentSpeed > AppConstants.minSpeedMs) {
        _currentSpeed -= 2; 
        _startTimer();
      }
      _generateFood();
    } else {
      snake.body.removeAt(0);
    }

    notifyListeners();
  }

  void _generateFood() {
    int totalCells = AppConstants.gridRows * AppConstants.gridColumns;
    int newPos;
    do {
      newPos = _random.nextInt(totalCells);
    } while (snake.body.contains(newPos));
    food = Food(position: newPos);
  }

  void _gameOver() {
    isPlaying = false;
    isGameOver = true;
    _timer?.cancel();
    
    if (score > bestScore) {
      _storage.setBestScore(score);
    }
    
    _storage.saveHighScore(GameScore(
      score: score,
      date: DateTime.now().toIso8601String(),
    ));

    notifyListeners();
  }

  // Shop logic
  Future<bool> buySkin(SnakeSkin skin) async {
    if (coins >= skin.price && !purchasedSkins.contains(skin.id)) {
      await _storage.setCoins(coins - skin.price);
      await _storage.addPurchasedSkin(skin.id);
      notifyListeners();
      return true;
    }
    return false;
  }

  void equipSkin(String skinId) {
    if (purchasedSkins.contains(skinId)) {
      _storage.setSelectedSkin(skinId);
      notifyListeners();
    }
  }

  void clearHighScores() {
    _storage.clearHighScores();
    notifyListeners();
  }
}
