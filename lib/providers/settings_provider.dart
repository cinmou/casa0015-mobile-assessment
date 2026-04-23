import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _boxName = 'settings';

  // 0: System, 1: Light, 2: Dark
  late ThemeMode _themeMode;
  late String _languageCode;
  late String _version;

  Box? _box;

  SettingsProvider() {
    _themeMode = ThemeMode.system;
    _languageCode = 'system';
    _version = "0.2.0 - The High Priestess";
  }

  ThemeMode get themeMode => _themeMode;
  String get languageCode => _languageCode;
  String get version => _version;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);

    final savedThemeIndex = _box?.get('themeMode', defaultValue: 0);
    _themeMode = _indexToThemeMode(savedThemeIndex);

    _languageCode = _box?.get('language', defaultValue: 'system');

    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _box?.put('themeMode', _themeModeToIndex(mode));
    notifyListeners();
  }

  ThemeMode _indexToThemeMode(int index) {
    switch (index) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      case 0:
      default:
        return ThemeMode.system;
    }
  }

  int _themeModeToIndex(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 1;
      case ThemeMode.dark:
        return 2;
      case ThemeMode.system:
      default:
        return 0;
    }
  }

  void setLanguage(String code) {
    _languageCode = code;
    _box?.put('language', code);
    notifyListeners();
  }
}
