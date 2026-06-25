import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/log_entry.dart';


class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // Locale
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  // Supported locales
  static const supportedLocales = [
    Locale('en'), // English
    Locale('zh'), // Chinese
    Locale('ja'), // Japanese
    Locale('ko'), // Korean
    Locale('es'), // Spanish
    Locale('fr'), // French
  ];

  // Theme mode
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  // Debug logging
  bool _debugMode = true;
  bool get debugMode => _debugMode;
  final List<LogEntry> _logs = [];
  List<LogEntry> get logs => List.unmodifiable(_logs);

  // Onboarding
  bool _onboardingComplete = false;
  bool get onboardingComplete => _onboardingComplete;

  // User profile
  String _displayName = '';
  String get displayName => _displayName;

  // Daily goal
  int _dailyGoal = 20;
  int get dailyGoal => _dailyGoal;

  // XP
  int _totalXP = 0;
  int get totalXP => _totalXP;

  // Streak
  int _streak = 0;
  int get streak => _streak;
  DateTime? _lastActiveDate;

  // Initialization
  bool _initialized = false;
  bool get initialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final langCode = prefs.getString('locale') ?? 'en';
      _locale = Locale(langCode);
      _themeMode = prefs.getString('themeMode') == 'dark' ? ThemeMode.dark : ThemeMode.light;
      _debugMode = prefs.getBool('debugMode') ?? true;
      _onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
      _displayName = prefs.getString('displayName') ?? '';
      _dailyGoal = prefs.getInt('dailyGoal') ?? 20;
      _totalXP = prefs.getInt('totalXP') ?? 0;
      _streak = prefs.getInt('streak') ?? 0;
      final lastActive = prefs.getString('lastActiveDate');
      if (lastActive != null) {
        try {
          _lastActiveDate = DateTime.parse(lastActive);
        } catch (_) {
          _lastActiveDate = null;
        }
      }
      _initialized = true;
      notifyListeners();
      log('INIT', 'AppState initialized', {'locale': langCode});
    } catch (e) {
      log('ERROR', 'AppState initialize failed', {'error': e.toString()});
      _initialized = true;
      notifyListeners();
    }
  }

  void setLocale(Locale loc) async {
    if (_locale == loc) return;
    _locale = loc;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('locale', loc.languageCode);
    } catch (e) {
      log('ERROR', 'Failed to save locale', {'error': e.toString()});
    }
    log('SETTINGS', 'Locale changed', {'locale': loc.languageCode});
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('themeMode', mode == ThemeMode.dark ? 'dark' : 'light');
    } catch (e) {
      log('ERROR', 'Failed to save theme', {'error': e.toString()});
    }
    log('SETTINGS', 'Theme changed', {'mode': mode.name});
  }

  void setOnboardingComplete() async {
    _onboardingComplete = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingComplete', true);
    } catch (e) {
      log('ERROR', 'Failed to save onboarding', {'error': e.toString()});
    }
    log('ONBOARDING', 'Onboarding completed');
  }

  void setDisplayName(String name) async {
    _displayName = name;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('displayName', name);
    } catch (e) {
      log('ERROR', 'Failed to save display name', {'error': e.toString()});
    }
    log('PROFILE', 'Display name updated', {'name': name});
  }

  void setDailyGoal(int goal) async {
    _dailyGoal = goal;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('dailyGoal', goal);
    } catch (e) {
      log('ERROR', 'Failed to save daily goal', {'error': e.toString()});
    }
    log('SETTINGS', 'Daily goal updated', {'goal': goal});
  }

  void addXP(int amount) async {
    _totalXP += amount;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('totalXP', _totalXP);
    } catch (e) {
      log('ERROR', 'Failed to save XP', {'error': e.toString()});
    }
    log('XP', 'XP added', {'amount': amount, 'total': _totalXP});
  }

  void updateStreak() async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    if (_lastActiveDate != null) {
      final lastDate = DateTime(_lastActiveDate!.year, _lastActiveDate!.month, _lastActiveDate!.day);
      final diff = todayDate.difference(lastDate).inDays;
      if (diff == 1) {
        _streak++;
      } else if (diff > 1) {
        _streak = 1;
      }
    } else {
      _streak = 1;
    }
    _lastActiveDate = todayDate;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('streak', _streak);
      await prefs.setString('lastActiveDate', todayDate.toIso8601String());
    } catch (e) {
      log('ERROR', 'Failed to save streak', {'error': e.toString()});
    }
    log('STREAK', 'Streak updated', {'streak': _streak});
  }

  void setDebugMode(bool enabled) async {
    _debugMode = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('debugMode', enabled);
    } catch (e) {
      log('ERROR', 'Failed to save debug mode', {'error': e.toString()});
    }
    log('SETTINGS', 'Debug mode ${enabled ? "enabled" : "disabled"}');
  }

  Future<void> resetAll() async {
    _totalXP = 0;
    _streak = 0;
    _lastActiveDate = null;
    _dailyGoal = 20;
    _displayName = '';
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      log('SETTINGS', 'All app preferences cleared');
    } catch (e) {
      log('ERROR', 'Failed to clear preferences', {'error': e.toString()});
    }
  }

  int get level => (_totalXP / 100).floor() + 1;
  int get xpToNextLevel => 100 - (_totalXP % 100);
  double get levelProgress => (_totalXP % 100) / 100.0;

  void log(String category, String message, [Map<String, dynamic>? detail]) {
    if (!_debugMode) return;
    _logs.add(LogEntry(
      timestamp: DateTime.now(),
      category: category,
      message: message,
      color: _categoryColor(category),
      detail: detail,
    ));
    if (_logs.length > 500) _logs.removeAt(0);
    debugPrint('[${category}] $message');
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'INIT': return Colors.blue;
      case 'ERROR': return Colors.red;
      case 'XP': return Colors.amber;
      case 'STREAK': return Colors.orange;
      case 'QUIZ': return Colors.purple;
      case 'SRS': return Colors.teal;
      case 'SETTINGS': return Colors.indigo;
      case 'FLASHCARD': return Colors.green;
      default: return Colors.grey;
    }
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }
}
