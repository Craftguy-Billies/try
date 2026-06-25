import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'state/app_state.dart';
import 'state/french_state.dart';
import 'i18n/app_localizations.dart';
import 'pages/onboarding_page.dart';
import 'pages/learn_page.dart';
import 'pages/practice_page.dart';
import 'pages/conjugation_page.dart';
import 'pages/grammar_page.dart';
import 'pages/progress_page.dart';
import 'pages/settings_page.dart';
import 'pages/exam_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FrenchApp());
}

class FrenchApp extends StatefulWidget {
  const FrenchApp({super.key});

  @override
  State<FrenchApp> createState() => _FrenchAppState();
}

class _FrenchAppState extends State<FrenchApp> {
  final AppState _appState = AppState();
  final FrenchState _frenchState = FrenchState();
  bool _ready = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _appState.initialize();
      await _frenchState.initialize();
      if (mounted) {
        setState(() => _ready = true);
      }
    } catch (e) {
      _appState.log('ERROR', 'Initialization failed', {'error': e.toString()});
      if (mounted) {
        setState(() {
          _ready = true;
          _initError = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'French Learn',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: const Color(0xFF1A237E),
            brightness: Brightness.light,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 1,
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: const Color(0xFF1A237E),
            brightness: Brightness.dark,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
              scrolledUnderElevation: 1,
            ),
            cardTheme: CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          themeMode: _appState.themeMode,
          locale: _appState.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: _ready
              ? _initError != null
                  ? _ErrorScreen(error: _initError!)
                  : (_appState.onboardingComplete
                      ? const MainShell()
                      : const OnboardingPage())
              : const _SplashScreen(),
        );
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF283593),
              Color(0xFF3949AB),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🇫🇷',
                style: TextStyle(fontSize: 64),
              ),
              SizedBox(height: 24),
              Text(
                'French Learn',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String error;
  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Initialization Error',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(error, textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  final state = context.findAncestorStateOfType<_FrenchAppState>();
                  state?._initialize();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final AppState _appState = AppState();

  static const _tabIcons = [
    Icons.school_rounded,
    Icons.quiz_rounded,
    Icons.format_list_numbered_rounded,
    Icons.menu_book_rounded,
    Icons.trending_up_rounded,
    Icons.settings_rounded,
  ];

  static const _tabI18nKeys = [
    'learn',
    'practice',
    'conjugationTitle',
    'grammarTitle',
    'progressTitle',
    'settingsTitle',
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      LearnPage(),
      PracticePage(),
      ConjugationPage(),
      GrammarPage(),
      ProgressPage(),
      SettingsPage(),
    ];
  }

  String _titleForTab(int index, AppLocalizations l10n) {
    switch (index) {
      case 0:
        return l10n.learn;
      case 1:
        return l10n.practice;
      case 2:
        return l10n.conjugationTitle;
      case 3:
        return l10n.grammarTitle;
      case 4:
        return l10n.progressTitle;
      case 5:
        return l10n.settingsTitle;
      default:
        return '';
    }
  }

  String _labelForTab(int index, AppLocalizations l10n) {
    final key = _tabI18nKeys[index];
    switch (key) {
      case 'learn': return l10n.learn;
      case 'practice': return l10n.practice;
      case 'conjugationTitle': return l10n.conjugationTitle;
      case 'grammarTitle': return l10n.grammarTitle;
      case 'progressTitle': return l10n.progressTitle;
      case 'settingsTitle': return l10n.settingsTitle;
      default: return key;
    }
  }

  void _showLanguageMenu() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectLanguage,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ...AppState.supportedLocales.map((loc) {
                  final isSelected =
                      _appState.locale.languageCode == loc.languageCode;
                  return ListTile(
                    leading: Text(
                      _flagForLocale(loc.languageCode),
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(_nameForLocale(loc.languageCode)),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle,
                            color: Color(0xFF1A237E))
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      _appState.setLocale(loc);
                      Navigator.pop(ctx);
                      HapticFeedback.lightImpact();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  String _flagForLocale(String code) {
    switch (code) {
      case 'en':
        return '🇬🇧';
      case 'zh':
        return '🇨🇳';
      case 'ja':
        return '🇯🇵';
      case 'ko':
        return '🇰🇷';
      case 'es':
        return '🇪🇸';
      case 'fr':
        return '🇫🇷';
      default:
        return '🌐';
    }
  }

  String _nameForLocale(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _titleForTab(_currentIndex, l10n),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.school_outlined),
                tooltip: l10n.examMode,
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ExamPage()),
                  );
                },
              ),
              IconButton(
                icon: Text(
                  _flagForLocale(_appState.locale.languageCode),
                  style: const TextStyle(fontSize: 22),
                ),
                tooltip: l10n.language,
                onPressed: _showLanguageMenu,
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey(_currentIndex),
              child: _pages[_currentIndex],
            ),
          ),
          floatingActionButton: _currentIndex == 0
              ? FloatingActionButton.extended(
                  onPressed: () {
                    setState(() => _currentIndex = 1);
                    HapticFeedback.mediumImpact();
                  },
                  icon: const Icon(Icons.flash_on_rounded),
                  label: Text(l10n.practice),
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: const Color(0xFF1A237E),
                )
              : null,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
              HapticFeedback.selectionClick();
            },
            animationDuration: const Duration(milliseconds: 400),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            height: 68,
            destinations: List.generate(6, (i) {
              return NavigationDestination(
                icon: Icon(_tabIcons[i]),
                selectedIcon: Icon(_tabIcons[i], fill: 1),
                label: _labelForTab(i, l10n),
              );
            }),
          ),
        );
      },
    );
  }
}
