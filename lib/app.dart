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
import 'models/user_progress.dart';

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
  String _initialRoute = '/onboarding';
  final _logger = AuditLogger();
  UserProgressProvider? _progressProvider;

  Locale get locale => _locale;

  void changeLanguage(String code) {
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
    StorageService().setLanguage(code);
  }

  @override
  void initState() {
    super.initState();
    _logger.logInit('FrenchLearnApp');
    WidgetsBinding.instance.addObserver(this);
    _logger.debug('App', 'WidgetsBindingObserver added');
    _initApp();
  }

  @override
  void dispose() {
    _logger.logDispose('FrenchLearnApp');
    WidgetsBinding.instance.removeObserver(this);
    _logger.debug('App', 'WidgetsBindingObserver removed');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.logLifecycle('App', 'lifecycle=${state.name}');
  }

  @override
  void didChangePlatformBrightness() {
    _logger.logLifecycle('App', 'platformBrightness changed');
  }

  @override
  void didChangeMetrics() {
    _logger.logLifecycle('App', 'metrics changed (screen size, text scale, etc.)');
  }

  @override
  void didChangeAccessibilityFeatures() {
    _logger.logLifecycle('App', 'accessibility features changed');
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    _logger.logLifecycle('App', 'system locales changed', data: {
      'locales': locales?.map((l) => l.languageCode).toList(),
    });
  }

  Future<void> _initApp() async {
    final sw = Stopwatch()..start();
    _logger.logAsyncStart('App', 'init');

    try {
      _logger.debug('App', 'Stage 1/6: StorageService.init');
      await StorageService().init();
      _logger.debug('App', 'Stage 1/6: StorageService.init done');

      final lang = await StorageService().getLanguage();
      _locale = AppLanguage.fromCode(lang).locale;
      _logger.info('App', 'Language resolved: $lang → ${_locale.languageCode}');

      _logger.debug('App', 'Stage 2/6: AudioService.init');
      await AudioService().init();
      _logger.debug('App', 'Stage 2/6: AudioService.init done');

      _logger.debug('App', 'Stage 3/6: VocabularyService.init');
      await VocabularyService().init();
      _logger.debug('App', 'Stage 3/6: VocabularyService.init done');

      _logger.debug('App', 'Stage 4/6: ExamService.init');
      await ExamService().init();
      _logger.debug('App', 'Stage 4/6: ExamService.init done');

      _logger.debug('App', 'Stage 5/6: Onboarding check');
      final onboarded = await StorageService().isOnboardingCompleted();
      _initialRoute = onboarded ? '/home' : '/onboarding';
      _logger.info('App', 'Onboarding completed: $onboarded → initial route: $_initialRoute');

      _logger.debug('App', 'Stage 6/6: Load persisted progress');
      if (_progressProvider != null) {
        await _progressProvider!.loadFromStorage();
        _logger.debug('App', 'Stage 6/6: Progress loaded from storage');
      } else {
        _logger.warn('App', 'Stage 6/6: Progress provider not yet created, skipping load');
      }

      setState(() => _initialized = true);
      _logger.logAsyncDone('App', 'init', elapsed: sw.elapsed, data: {
        'route': _initialRoute, 'locale': _locale.languageCode,
        'onboarded': onboarded,
      });
    } catch (e, stack) {
      _logger.logAsyncFail('App', 'init', e, stack, data: {'stage_elapsed_ms': sw.elapsedMilliseconds});
      _logger.logRecover('App', 'init failure — proceeding to home');
      setState(() => _initialized = true);
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
        ChangeNotifierProvider(create: (_) {
          _logger.logProvider('created', 'UserProgressProvider');
          final provider = UserProgressProvider();
          _progressProvider = provider;
          // If app already initialized, load progress now (catch-up for late init)
          if (_initialized) {
            _logger.logEdge('App', 'progress-provider-created-after-init — loading now');
            provider.loadFromStorage();
          }
          return provider;
        }),
        Provider.value(value: AudioService()),
        Provider.value(value: VocabularyService()),
        Provider.value(value: ExamService()),
        Provider.value(value: StorageService()),
      ],
      child: MaterialApp(
        title: 'Learn French',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        locale: _locale,
        localizationsDelegates: const [
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLanguage.supported.map((l) => l.locale).toList(),
        initialRoute: _initialRoute,
        onGenerateRoute: (settings) {
          Widget page;
          switch (settings.name) {
            case '/onboarding': page = const OnboardingScreen(); break;
            case '/home': page = const HomeScreen(); break;
            case '/vocabulary': page = const VocabularyListScreen(); break;
            case '/exam': page = const ExamHomeScreen(); break;
            case '/grammar': page = const GrammarListScreen(); break;
            case '/phrases': page = const PhrasesScreen(); break;
            case '/profile': page = const ProfileScreen(); break;
            case '/settings': page = const SettingsScreen(); break;
            default:
              _logger.logFallback('Router', 'Unknown route', '/home', data: {'requested': settings.name});
              page = const HomeScreen();
          }
          _logger.logNavigate('init', settings.name ?? '/', data: {'widget': page.runtimeType.toString()});
          return MaterialPageRoute(builder: (_) => page, settings: settings);
        },
      ),
    );
  }
}
