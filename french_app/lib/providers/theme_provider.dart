import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../debug/debug_logger.dart';

class ThemeProvider extends ChangeNotifier {
  static const _key = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _loadSaved();
  }

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    DebugLogger.logStateChange('ThemeProvider', 'Theme set to ${mode.name}');
    notifyListeners();
    _persist();
  }

  ThemeMode getThemeMode() => _themeMode;

  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);
        break;
      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
        break;
    }
  }

  Future<void> _loadSaved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final index = prefs.getInt(_key);
      if (index != null && index >= 0 && index < ThemeMode.values.length) {
        _themeMode = ThemeMode.values[index];
        DebugLogger.logInit('ThemeProvider loaded: ${_themeMode.name}');
      }
    } catch (e, stack) {
      DebugLogger.logError('ThemeProvider', 'Failed to load theme: $e', stack: stack);
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, _themeMode.index);
  }
}
