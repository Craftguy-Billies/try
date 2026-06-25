import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'state/app_state.dart';
import 'state/french_state.dart';
import 'widgets/error_boundary.dart';
import 'pages/learn_page.dart';
import 'pages/practice_page.dart';
import 'pages/conjugation_page.dart';
import 'pages/grammar_page.dart';
import 'pages/progress_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (appState.initialized) {
      appState.log('ERROR', 'Flutter error: ${details.exceptionAsString().split('\n').first}', color: Colors.red);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (appState.initialized) {
      appState.log('ERROR', 'Platform error: $error', color: Colors.red);
    }
    return true;
  };

  appState.init();
  frenchState; // initialize
  frenchState.load(); // restore persisted progress

  debugPrint = (message, {wrapWidth}) {
    if (appState.initialized) {
      appState.log('DEBUG', message?.toString() ?? '(null)', color: Colors.grey.shade500);
    }
    debugPrintSynchronously(message, wrapWidth: wrapWidth);
  };

  runApp(const FrenchApp());
}

class FrenchApp extends StatelessWidget {
  const FrenchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn French',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // French blue
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withAlpha(20)),
          ),
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.black.withAlpha(15)),
          ),
        ),
      ),
      home: const ErrorBoundary(pageName: 'App', child: MainShell()),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  int _tab = 0;
  String? _lastNavigationLog;
  static const _tabNames = ['Learn', 'Practice', 'Verbs', 'Grammar', 'Progress'];

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabs = const [
      ErrorBoundary(pageName: 'Learn', child: LearnPage()),
      ErrorBoundary(pageName: 'Practice', child: PracticePage()),
      ErrorBoundary(pageName: 'Verbs', child: ConjugationPage()),
      ErrorBoundary(pageName: 'Grammar', child: GrammarPage()),
      ErrorBoundary(pageName: 'Progress', child: ProgressPage()),
    ];

    appState.log('NAV', '🇫🇷 French app started — default tab: ${_tabNames[_tab]}', color: const Color(0xFF1A237E));
    appState.log('INFO', 'Flutter | ${defaultTargetPlatform.name} | Display: ${WidgetsBinding.instance.platformDispatcher.displays.first.size.width.toInt()}x${WidgetsBinding.instance.platformDispatcher.displays.first.size.height.toInt()}', color: Colors.blueGrey);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appState.setLifecycleState(state.name);
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    appState.log('SYSTEM', 'Platform brightness changed: ${brightness.name}', color: Colors.orange);
  }

  @override
  void didChangeMetrics() {
    final size = View.of(context).physicalSize;
    appState.log('SYSTEM', 'Metrics changed: ${size.width.toInt()}x${size.height.toInt()} | DPR: ${View.of(context).devicePixelRatio}', color: Colors.cyan);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _tab == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_tab > 0) {
          appState.log('NAV', 'Back navigation: ${_tabNames[_tab]} → ${_tabNames[0]}', color: const Color(0xFF1A237E));
          setState(() => _tab = 0);
        } else {
          appState.log('NAV', 'Back press on home — showing exit hint', color: const Color(0xFF1A237E));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Press back again to exit'), duration: Duration(seconds: 2), behavior: SnackBarBehavior.floating),
          );
        }
      },
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _tabs[_tab],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => _switchTab(i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.school), label: 'Learn'),
            NavigationDestination(icon: Icon(Icons.quiz), label: 'Practice'),
            NavigationDestination(icon: Icon(Icons.edit_note), label: 'Verbs'),
            NavigationDestination(icon: Icon(Icons.menu_book), label: 'Grammar'),
            NavigationDestination(icon: Icon(Icons.trending_up), label: 'Progress'),
          ],
        ),
      ),
    );
  }

  void _switchTab(int i) {
    if (i == _tab) return;
    final newTab = _tabNames[i];
    if (newTab != _lastNavigationLog) {
      appState.log('NAV', 'Tab: ${_tabNames[_tab]} → $newTab', color: const Color(0xFF1A237E));
      _lastNavigationLog = newTab;
    }
    setState(() => _tab = i);
    FocusScope.of(context).unfocus();
  }
}
