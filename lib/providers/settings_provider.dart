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
    _version = "0.1.0 - The Magician"; // 实际项目中通常使用 package_info_plus 获取
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  String get languageCode => _languageCode;
  String get version => _version;

  // 初始化 Hive 并读取配置
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);

    // 读取主题设置 (默认为 0/System)
    final savedThemeIndex = _box?.get('themeMode', defaultValue: 0);
    _themeMode = _indexToThemeMode(savedThemeIndex);

    // 读取语言设置
    _languageCode = _box?.get('language', defaultValue: 'system');

    notifyListeners();
  }

  // --- 主题逻辑 ---
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _box?.put('themeMode', _themeModeToIndex(mode));
    notifyListeners();
  }

  // 辅助转换方法
  ThemeMode _indexToThemeMode(int index) {
    switch (index) {
      case 1: return ThemeMode.light;
      case 2: return ThemeMode.dark;
      case 0: default: return ThemeMode.system;
    }
  }

  int _themeModeToIndex(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 1;
      case ThemeMode.dark: return 2;
      case ThemeMode.system: default: return 0;
    }
  }

  // --- 语言逻辑 ---
  void setLanguage(String code) {
    _languageCode = code;
    _box?.put('language', code);
    notifyListeners();
  }
}