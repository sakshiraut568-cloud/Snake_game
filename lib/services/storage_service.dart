import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_score.dart';

class StorageService {
  static const String keyOnboarding = 'onboardingCompleted';
  static const String keyBestScore = 'bestScore';
  static const String keyHighScores = 'highScores';
  static const String keyCoins = 'coins';
  static const String keyPurchasedSkins = 'purchasedSkins';
  static const String keySelectedSkin = 'selectedSkin';
  static const String keySelectedTheme = 'selectedTheme';
  static const String keySound = 'soundEnabled';
  static const String keyMusic = 'musicEnabled';
  static const String keyVibration = 'vibrationEnabled';
  static const String keyControls = 'controlType';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Onboarding
  bool get isOnboardingCompleted => _prefs.getBool(keyOnboarding) ?? false;
  Future<void> setOnboardingCompleted(bool value) async => _prefs.setBool(keyOnboarding, value);

  // Score & Coins
  int get bestScore => _prefs.getInt(keyBestScore) ?? 0;
  Future<void> setBestScore(int value) async => _prefs.setInt(keyBestScore, value);

  int get coins => _prefs.getInt(keyCoins) ?? 0;
  Future<void> setCoins(int value) async => _prefs.setInt(keyCoins, value);

  // High Scores
  List<GameScore> get highScores {
    final jsonList = _prefs.getStringList(keyHighScores) ?? [];
    return jsonList.map((s) => GameScore.fromJson(jsonDecode(s))).toList();
  }
  Future<void> saveHighScore(GameScore score) async {
    final currentScores = highScores;
    currentScores.add(score);
    currentScores.sort((a, b) => b.score.compareTo(a.score)); // Descending
    final topScores = currentScores.take(10).toList(); // Keep top 10
    final jsonList = topScores.map((s) => jsonEncode(s.toJson())).toList();
    await _prefs.setStringList(keyHighScores, jsonList);
  }
  Future<void> clearHighScores() async => _prefs.remove(keyHighScores);

  // Settings
  bool get isSoundEnabled => _prefs.getBool(keySound) ?? true;
  Future<void> setSoundEnabled(bool value) async => _prefs.setBool(keySound, value);

  bool get isMusicEnabled => _prefs.getBool(keyMusic) ?? true;
  Future<void> setMusicEnabled(bool value) async => _prefs.setBool(keyMusic, value);

  bool get isVibrationEnabled => _prefs.getBool(keyVibration) ?? true;
  Future<void> setVibrationEnabled(bool value) async => _prefs.setBool(keyVibration, value);

  String get controlType => _prefs.getString(keyControls) ?? 'Swipe';
  Future<void> setControlType(String value) async => _prefs.setString(keyControls, value);

  String get selectedTheme => _prefs.getString(keySelectedTheme) ?? 'Classic';
  Future<void> setSelectedTheme(String value) async => _prefs.setString(keySelectedTheme, value);

  // Skins
  List<String> get purchasedSkins => _prefs.getStringList(keyPurchasedSkins) ?? ['classic_green'];
  Future<void> addPurchasedSkin(String skinId) async {
    final skins = purchasedSkins;
    if (!skins.contains(skinId)) {
      skins.add(skinId);
      await _prefs.setStringList(keyPurchasedSkins, skins);
    }
  }

  String get selectedSkin => _prefs.getString(keySelectedSkin) ?? 'classic_green';
  Future<void> setSelectedSkin(String value) async => _prefs.setString(keySelectedSkin, value);

  // Reset
  Future<void> resetGameData() async {
    await _prefs.clear();
  }
}
