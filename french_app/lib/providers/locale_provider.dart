import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../debug/debug_logger.dart';

class LocaleProvider extends ChangeNotifier {
  static const _key = 'app_locale';

  Locale _currentLocale = const Locale('en');

  final List<Locale> supportedLocales = const [
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('zh'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ar'),
    Locale('hi'),
    Locale('it'),
    Locale('ru'),
  ];

  LocaleProvider() {
    _loadSaved();
  }

  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) {
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    DebugLogger.logStateChange('LocaleProvider', 'Locale set to ${locale.languageCode}');
    notifyListeners();
    _persist();
  }

  Locale getCurrentLocale() => _currentLocale;

  Future<void> _loadSaved() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_key);
      if (code != null && code.isNotEmpty) {
        final parts = code.split('_');
        final languageCode = parts[0];
        final countryCode = parts.length > 1 ? parts[1] : null;
        final saved = countryCode != null
            ? Locale(languageCode, countryCode)
            : Locale(languageCode);

        if (supportedLocales.contains(saved)) {
          _currentLocale = saved;
          DebugLogger.logInit('LocaleProvider loaded: ${saved.languageCode}');
        } else {
          DebugLogger.logError('LocaleProvider',
              'Saved locale $saved not in supported list, using default');
        }
      }
    } catch (e, stack) {
      DebugLogger.logError('LocaleProvider', 'Failed to load locale: $e', stack: stack);
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _currentLocale.toString());
  }
}
