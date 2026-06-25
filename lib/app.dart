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

class FrenchLearnAppState extends State<FrenchLearnApp> {
  Locale _locale = const Locale('en');
  bool _initialized = false;
  String _initialRoute = '/onboarding';
  final _logger = AuditLogger();

  Locale get locale => _locale;

  void changeLanguage(String code) {
    setState(() {
      _locale = AppLanguage.fromCode(code).locale;
    });
    _logger.logUserAction('Language changed to: $code');
  }

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      _logger.info('App', 'Initializing app...');
      await StorageService().init();
      final lang = await StorageService().getLanguage();
      _locale = AppLanguage.fromCode(lang).locale;
      _logger.info('App', 'Language: $lang');

      await AudioService().init();
      await VocabularyService().init();
      await ExamService().init();

      final onboarded = await StorageService().isOnboardingCompleted();
      _initialRoute = onboarded ? '/home' : '/onboarding';
      _logger.info('App', 'Initial route: $_initialRoute');

      setState(() => _initialized = true);
      _logger.info('App', 'App initialized successfully');
    } catch (e, stack) {
      _logger.error('App', 'Init failed', e: e, s: stack);
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProgressProvider()),
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
            default: page = const HomeScreen();
          }
          return MaterialPageRoute(builder: (_) => page, settings: settings);
        },
      ),
    );
  }
}
