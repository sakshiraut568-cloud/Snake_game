import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;

  bool _soundEnabled;
  bool _musicEnabled;
  bool _vibrationEnabled;
  String _controlType;
  String _selectedTheme;

  SettingsProvider(this._storageService)
      : _soundEnabled = _storageService.isSoundEnabled,
        _musicEnabled = _storageService.isMusicEnabled,
        _vibrationEnabled = _storageService.isVibrationEnabled,
        _controlType = _storageService.controlType,
        _selectedTheme = _storageService.selectedTheme;

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;
  bool get vibrationEnabled => _vibrationEnabled;
  String get controlType => _controlType;
  String get selectedTheme => _selectedTheme;

  void toggleSound(bool value) {
    _soundEnabled = value;
    _storageService.setSoundEnabled(value);
    notifyListeners();
  }

  void toggleMusic(bool value) {
    _musicEnabled = value;
    _storageService.setMusicEnabled(value);
    notifyListeners();
  }

  void toggleVibration(bool value) {
    _vibrationEnabled = value;
    _storageService.setVibrationEnabled(value);
    notifyListeners();
  }

  void setControlType(String type) {
    _controlType = type;
    _storageService.setControlType(type);
    notifyListeners();
  }

  void setTheme(String theme) {
    _selectedTheme = theme;
    _storageService.setSelectedTheme(theme);
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _storageService.resetGameData();
    _soundEnabled = true;
    _musicEnabled = true;
    _vibrationEnabled = true;
    _controlType = 'Swipe';
    _selectedTheme = 'Classic';
    notifyListeners();
  }
}
