import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';
import 'audit_logger.dart';

class StorageService {
  static final StorageService _instance = StorageService._();
  factory StorageService() => _instance;
  StorageService._();

  final _logger = AuditLogger();
  SharedPreferences? _prefs;
  UserProgress? _cachedProgress;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.info('Storage', 'Initialized');
    } catch (e, stack) {
      _logger.error('Storage', 'Init failed', e: e, s: stack);
      rethrow;
    }
  }

  Future<UserProgress> loadProgress() async {
    try {
      if (_cachedProgress != null) return _cachedProgress!;
      _prefs ??= await SharedPreferences.getInstance();
      final json = _prefs!.getString('user_progress');
      if (json != null) {
        _cachedProgress = UserProgress.fromJson(jsonDecode(json) as Map<String, dynamic>);
        _logger.info('Storage', 'Progress loaded: ${_cachedProgress!.totalWordsLearned} words');
      } else {
        _cachedProgress = UserProgress();
        _logger.info('Storage', 'New progress created');
      }
      return _cachedProgress!;
    } catch (e, stack) {
      _logger.error('Storage', 'Load failed, creating new', e: e, s: stack);
      _cachedProgress = UserProgress();
      return _cachedProgress!;
    }
  }

  Future<void> saveProgress(UserProgress p) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      _cachedProgress = p;
      await _prefs!.setString('user_progress', jsonEncode(p.toJson()));
    } catch (e, stack) {
      _logger.error('Storage', 'Save failed', e: e, s: stack);
    }
  }

  Future<void> setOnboardingCompleted() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool('onboarded', true);
  }

  Future<bool> isOnboardingCompleted() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getBool('onboarded') ?? false;
  }

  Future<void> setLanguage(String code) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString('lang', code);
  }

  Future<String> getLanguage() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getString('lang') ?? 'en';
  }

  Future<void> setDarkMode(bool v) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool('dark', v);
  }

  Future<bool> getDarkMode() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getBool('dark') ?? false;
  }

  Future<void> clearAll() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.clear();
    _cachedProgress = null;
    _logger.info('Storage', 'All data cleared');
  }
}
