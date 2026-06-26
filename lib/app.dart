import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'i18n/translations.dart';
import 'services/audit_logger.dart';
import 'services/storage_service.dart';
import 'services/audio_service.dart';
import 'services/vocabulary_service.dart';
import 'services/exam_service.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/vocabulary/vocabulary_list_screen.dart';
import 'screens/exam/exam_home_screen.dart';
import 'screens/grammar/grammar_list_screen.dart';
import 'screens/phrases/phrases_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/settings_screen.dart';

class FrenchLearnApp extends StatefulWidget {
  const FrenchLearnApp({super.key});

  static FrenchLearnAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<FrenchLearnAppState>();
  }

  @override
  State<FrenchLearnApp> createState() => FrenchLearnAppState();
}

class FrenchLearnAppState extends State<FrenchLearnApp> with WidgetsBindingObserver {
  Locale _locale = const Locale('en');
  bool _initialized = false;
  bool _initInProgress = false;
  bool _darkMode = false;
  String _initialRoute = '/onboarding';
  final _logger = AuditLogger();
  late final UserProgressProvider _progressProvider;

  Locale get locale => _locale;

  Future<void> refreshDarkMode() async {
    try {
      final dark = await StorageService().getDarkMode();
      if (mounted && _darkMode != dark) {
        setState(() => _darkMode = dark);
        _logger.info('App', 'Dark mode refreshed from storage: $dark');
      }
    } catch (e, stack) {
      _logger.logAsyncFail('App', 'refreshDarkMode', e, stack);
    }
  }

  void changeLanguage(String code) {
    if (!_initialized) {
      _logger.logGuard('App', 'changeLanguage-before-init', data: {'code': code});
      return;
    }
    if (_locale.languageCode == code) {
      _logger.logGuardSkip('App', 'same-language', data: {'code': code});
      return;
    }
    final old = _locale.languageCode;
    setState(() {
      _locale = AppLanguage.fromCode(code).locale;
    });
    _logger.logStateChange('App', 'locale', old, code);
    _logger.logUserAction('Language changed to: $code');
    try {
      StorageService().setLanguage(code);
    } catch (e, stack) {
      _logger.logAsyncFail('App', 'setLanguage-during-changeLanguage', e, stack,
          data: {'code': code});
    }
  }

  @override
  void initState() {
    super.initState();
    _logger.logInit('FrenchLearnApp');
    WidgetsBinding.instance.addObserver(this);
    _logger.debug('App', 'WidgetsBindingObserver added');
    _progressProvider = UserProgressProvider();
    _logger.logProvider('created', 'UserProgressProvider (in initState, pre-init)');
    _initApp();
  }

  @override
  void dispose() {
    _logger.logDispose('FrenchLearnApp', data: {
      'initialized': _initialized, 'initInProgress': _initInProgress,
    });
    if (_initInProgress) {
      _logger.logEdge('App', 'dispose-during-init');
    }
    WidgetsBinding.instance.removeObserver(this);
    _logger.debug('App', 'WidgetsBindingObserver removed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.logLifecycle('App', 'lifecycle=${state.name}');
    switch (state) {
      case AppLifecycleState.paused:
        _logger.debug('App', 'App moving to background — consider saving state');
        break;
      case AppLifecycleState.resumed:
        _logger.debug('App', 'App returning to foreground');
        break;
      case AppLifecycleState.inactive:
        _logger.debug('App', 'App becoming inactive (e.g., phone call, split-screen)');
        break;
      case AppLifecycleState.detached:
        _logger.debug('App', 'App detached from view tree');
        break;
      case AppLifecycleState.hidden:
        _logger.debug('App', 'App hidden — not visible to user');
        break;
    }
  }

  @override
  void didChangePlatformBrightness() {
    _logger.logLifecycle('App', 'platformBrightness changed', data: {
      'platformBrightness': MediaQuery.platformBrightnessOf(context).name,
      'usingUserDarkMode': _darkMode,
    });
  }

  @override
  void didChangeMetrics() {
    _logger.logLifecycle('App', 'metrics changed', data: {
      'size': '${MediaQuery.sizeOf(context)}',
      'padding': '${MediaQuery.paddingOf(context)}',
      'textScale': MediaQuery.textScaleFactorOf(context),
      'devicePixelRatio': MediaQuery.devicePixelRatioOf(context),
    });
  }

  @override
  void didChangeAccessibilityFeatures() {
    _logger.logLifecycle('App', 'accessibility features changed', data: {
      'accessibleNavigation': MediaQuery.accessibleNavigationOf(context),
      'invertColors': MediaQuery.invertColorsOf(context),
      'disableAnimations': MediaQuery.disableAnimationsOf(context),
      'boldText': MediaQuery.boldTextOf(context),
      'highContrast': MediaQuery.highContrastOf(context),
    });
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    _logger.logLifecycle('App', 'system locales changed', data: {
      'locales': locales?.map((l) => l.languageCode).toList(),
    });
  }

  @override
  void didChangeTextScaleFactor() {
    _logger.logLifecycle('App', 'textScaleFactor changed', data: {
      'textScale': MediaQuery.textScaleFactorOf(context),
    });
    setState(() {}); // Force rebuild with new text scale
  }

  Future<void> _initApp() async {
    if (_initInProgress) {
      _logger.logGuard('App', 'init-already-in-progress');
      return;
    }
    if (_initialized) {
      _logger.logGuard('App', 'already-initialized');
      return;
    }
    _initInProgress = true;
    final sw = Stopwatch()..start();
    _logger.logAsyncStart('App', 'init');

    try {
      _logger.debug('App', 'Stage 1/7: StorageService.init');
      await StorageService().init();
      _logger.debug('App', 'Stage 1/7: StorageService.init done');

      final lang = await StorageService().getLanguage();
      _locale = AppLanguage.fromCode(lang).locale;
      _logger.info('App', 'Language resolved: $lang → ${_locale.languageCode}');

      _logger.debug('App', 'Stage 2/7: AudioService.init');
      await AudioService().init();
      _logger.debug('App', 'Stage 2/7: AudioService.init done');

      _logger.debug('App', 'Stage 3/7: VocabularyService.init');
      await VocabularyService().init();
      _logger.debug('App', 'Stage 3/7: VocabularyService.init done');

      _logger.debug('App', 'Stage 4/7: ExamService.init');
      await ExamService().init();
      _logger.debug('App', 'Stage 4/7: ExamService.init done');

      _logger.debug('App', 'Stage 5/7: Onboarding check');
      final onboarded = await StorageService().isOnboardingCompleted();
      _initialRoute = onboarded ? '/home' : '/onboarding';
      _logger.info('App', 'Onboarding completed: $onboarded → initial route: $_initialRoute');

      _logger.debug('App', 'Stage 6/7: Load persisted progress');
      await _progressProvider.loadFromStorage();
      _logger.debug('App', 'Stage 6/7: Progress loaded from storage');

      _logger.debug('App', 'Stage 7/7: Load preferences (dark mode, etc.)');
      try {
        _darkMode = await StorageService().getDarkMode();
        _logger.info('App', 'Dark mode loaded: $_darkMode');
      } catch (e, stack) {
        _logger.logAsyncFail('App', 'load-darkMode-preference', e, stack);
        _darkMode = false;
      }

      if (!mounted) {
        _logger.logEdge('App', 'init-complete-but-not-mounted', data: {
          'elapsed_ms': sw.elapsedMilliseconds,
        });
        _initInProgress = false;
        return;
      }
      setState(() => _initialized = true);
      _initInProgress = false;
      _logger.logAsyncDone('App', 'init', elapsed: sw.elapsed, data: {
        'route': _initialRoute, 'locale': _locale.languageCode,
        'onboarded': onboarded,
      });
    } catch (e, stack) {
      _logger.logAsyncFail('App', 'init', e, stack, data: {'stage_elapsed_ms': sw.elapsedMilliseconds});
      _logger.logRecover('App', 'init failure — proceeding to home');
      _initInProgress = false;
      if (mounted) setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.logBuild('FrenchLearnApp', data: {
      'initialized': _initialized, 'locale': _locale.languageCode, 'route': _initialRoute,
    });

    if (!_initialized) {
      _logger.debug('App', 'Rendering loading spinner (not initialized)');
      return MaterialApp(
        locale: _locale,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLanguage.supported.map((l) => l.locale).toList(),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    _logger.logProvider('creating', 'MultiProvider with 5 services');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _progressProvider),
        Provider.value(value: AudioService()),
        Provider.value(value: VocabularyService()),
        Provider.value(value: ExamService()),
        Provider.value(value: StorageService()),
      ],
      child: MaterialApp(
        title: 'Learn French',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
        locale: _locale,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLanguage.supported.map((l) => l.locale).toList(),
        initialRoute: _initialRoute,
        onGenerateRoute: (settings) {
          Widget page;
          final routeName = settings.name;
          _logger.debug('Router', 'onGenerateRoute called', data: {
            'name': routeName, 'arguments': '${settings.arguments}',
          });
          switch (routeName) {
            case '/onboarding': page = const OnboardingScreen(); break;
            case '/home': page = const HomeScreen(); break;
            case '/vocabulary': page = const VocabularyListScreen(); break;
            case '/exam': page = const ExamHomeScreen(); break;
            case '/grammar': page = const GrammarListScreen(); break;
            case '/phrases': page = const PhrasesScreen(); break;
            case '/profile': page = const ProfileScreen(); break;
            case '/settings': page = const SettingsScreen(); break;
            case null:
              _logger.logEdge('Router', 'null-route-name — using /home as fallback');
              page = const HomeScreen();
              break;
            default:
              _logger.logFallback('Router', 'Unknown route', '/home', data: {'requested': routeName});
              page = const HomeScreen();
          }
          _logger.logNavigate('init', routeName ?? '/', data: {'widget': page.runtimeType.toString()});
          return MaterialPageRoute(builder: (_) => page, settings: settings);
        },
      ),
    );
  }
}
