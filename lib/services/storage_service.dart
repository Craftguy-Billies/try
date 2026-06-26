import 'dart:async';
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
  Future<void>? _pendingSave;
  UserProgress? _queuedProgress;

  bool get isReady => _prefs != null;

  Future<void> init() async {
    _logger.logAsyncStart('Storage', 'init');
    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.logAsyncDone('Storage', 'init', data: {'prefs_keys': _prefs!.getKeys().length});
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'init', e, stack);
      rethrow;
    }
  }

  Future<UserProgress> loadProgress() async {
    _logger.logAsyncStart('Storage', 'loadProgress');
    try {
      if (_cachedProgress != null) {
        _logger.logGuardSkip('Storage', 'cache-hit');
        return _cachedProgress!;
      }
      _prefs ??= await SharedPreferences.getInstance();
      final json = _prefs!.getString('user_progress');
      if (json != null) {
        final decoded = jsonDecode(json) as Map<String, dynamic>;
        _cachedProgress = UserProgress.fromJson(decoded);
        _logger.logAsyncDone('Storage', 'loadProgress', data: {
          'words': _cachedProgress!.totalWordsLearned, 'streak': _cachedProgress!.currentStreak,
          'json_len': json.length,
        });
      } else {
        _cachedProgress = UserProgress();
        _logger.logAsyncDone('Storage', 'loadProgress', data: {'source': 'new (no saved data)'});
      }
      return _cachedProgress!;
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'loadProgress', e, stack);
      _logger.logRecover('Storage', 'loadProgress — creating fresh progress');
      _cachedProgress = UserProgress();
      return _cachedProgress!;
    }
  }

  Future<void> saveProgress(UserProgress p) async {
    _cachedProgress = p;
    if (_pendingSave != null) {
      _queuedProgress = p;
      _logger.logDebounce('Storage', 'saveProgress — queued (previous save in progress)');
      return _pendingSave;
    }
    _logger.logAsyncStart('Storage', 'saveProgress');
    _pendingSave = _doSave(p);
    await _pendingSave;
    // After completing, check if another save was queued
    while (_queuedProgress != null) {
      final next = _queuedProgress!;
      _queuedProgress = null;
      _logger.logConcurrent('Storage', 'saveProgress — draining queued save');
      _pendingSave = _doSave(next);
      await _pendingSave;
    }
    _pendingSave = null;
  }

  Future<void> _doSave(UserProgress p) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final encoded = jsonEncode(p.toJson());
      await _prefs!.setString('user_progress', encoded);
      _logger.logAsyncDone('Storage', 'saveProgress', data: {
        'words': p.totalWordsLearned, 'streak': p.currentStreak, 'json_len': encoded.length,
      });
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'saveProgress', e, stack);
    }
  }

  Future<void> setOnboardingCompleted() async {
    _logger.logAsyncStart('Storage', 'setOnboardingCompleted');
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setBool('onboarded', true);
      _logger.logAsyncDone('Storage', 'setOnboardingCompleted');
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'setOnboardingCompleted', e, stack);
    }
  }

  Future<bool> isOnboardingCompleted() async {
    _logger.logAsyncStart('Storage', 'isOnboardingCompleted');
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final result = _prefs!.getBool('onboarded') ?? false;
      _logger.logAsyncDone('Storage', 'isOnboardingCompleted', data: {'result': result});
      return result;
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'isOnboardingCompleted', e, stack);
      return false;
    }
  }

  Future<void> setLanguage(String code) async {
    _logger.logAsyncStart('Storage', 'setLanguage', data: {'code': code});
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setString('lang', code);
      _logger.logAsyncDone('Storage', 'setLanguage');
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'setLanguage', e, stack);
    }
  }

  Future<String> getLanguage() async {
    _logger.logAsyncStart('Storage', 'getLanguage');
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final code = _prefs!.getString('lang') ?? 'en';
      _logger.logAsyncDone('Storage', 'getLanguage', data: {'code': code});
      return code;
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'getLanguage', e, stack);
      return 'en';
    }
  }

  Future<void> setDarkMode(bool v) async {
    _logger.logAsyncStart('Storage', 'setDarkMode', data: {'value': v});
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setBool('dark', v);
      _logger.logAsyncDone('Storage', 'setDarkMode');
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'setDarkMode', e, stack);
    }
  }

  Future<bool> getDarkMode() async {
    _logger.logAsyncStart('Storage', 'getDarkMode');
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final result = _prefs!.getBool('dark') ?? false;
      _logger.logAsyncDone('Storage', 'getDarkMode', data: {'result': result});
      return result;
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'getDarkMode', e, stack);
      return false;
    }
  }

  Future<void> setNotificationsEnabled(bool v) async {
    _logger.logAsyncStart('Storage', 'setNotificationsEnabled', data: {'value': v});
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.setBool('notif', v);
      _logger.logAsyncDone('Storage', 'setNotificationsEnabled');
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'setNotificationsEnabled', e, stack);
    }
  }

  Future<bool> getNotificationsEnabled() async {
    _logger.logAsyncStart('Storage', 'getNotificationsEnabled');
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final result = _prefs!.getBool('notif') ?? true;
      _logger.logAsyncDone('Storage', 'getNotificationsEnabled', data: {'result': result});
      return result;
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'getNotificationsEnabled', e, stack);
      return true;
    }
  }

  Future<void> clearAll() async {
    _logger.logAsyncStart('Storage', 'clearAll');
    _logger.logEdge('Storage', 'User requested full data wipe');
    try {
      _prefs ??= await SharedPreferences.getInstance();
      await _prefs!.clear();
      _cachedProgress = null;
      _logger.logDataClear('Storage (SharedPreferences cleared, cache nulled)');
      _logger.logAsyncDone('Storage', 'clearAll');
    } catch (e, stack) {
      _logger.logAsyncFail('Storage', 'clearAll', e, stack);
    }
  }
}
