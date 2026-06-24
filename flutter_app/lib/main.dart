import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'state/app_state.dart';
import 'widgets/error_boundary.dart';
import 'pages/counter_page.dart';
import 'pages/tasks_page.dart';
import 'pages/controls_page.dart';
import 'pages/form_page.dart';
import 'pages/logs_page.dart';
import 'pages/drawing_page.dart';
import 'pages/reaction_page.dart';

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

  debugPrint = (message, {wrapWidth}) {
    if (appState.initialized) {
      appState.log('DEBUG', message?.toString() ?? '(null)', color: Colors.grey.shade500);
    }
    debugPrintSynchronously(message, wrapWidth: wrapWidth);
  };

  runApp(const TrialHostApp());
}

class TrialHostApp extends StatelessWidget {
  const TrialHostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrialHost Flutter',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.dark),
        useMaterial3: true,
        cardTheme: CardThemeData(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.white.withAlpha(20)))),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.light),
        useMaterial3: true,
        cardTheme: CardThemeData(elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.black.withAlpha(15)))),
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
  static const _tabNames = ['Counter', 'Tasks', 'Controls', 'Form', 'Sketch', 'Reaction', 'Logs'];

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabs = const [
      ErrorBoundary(pageName: 'Counter', child: CounterPage()),
      ErrorBoundary(pageName: 'Tasks', child: TasksPage()),
      ErrorBoundary(pageName: 'Controls', child: ControlsPage()),
      ErrorBoundary(pageName: 'Form', child: FormPage()),
      ErrorBoundary(pageName: 'Sketch', child: DrawingPage()),
      ErrorBoundary(pageName: 'Reaction', child: ReactionPage()),
      ErrorBoundary(pageName: 'Logs', child: LogsPage()),
    ];

    appState.log('NAV', 'App started — default tab: ${_tabNames[_tab]}', color: Colors.purple);
    appState.log('INFO', 'Flutter web | ${defaultTargetPlatform.name} | Display: ${WidgetsBinding.instance.platformDispatcher.displays.first.size.width.toInt()}x${WidgetsBinding.instance.platformDispatcher.displays.first.size.height.toInt()}', color: Colors.blueGrey);
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
          appState.log('NAV', 'Back navigation: ${_tabNames[_tab]} → ${_tabNames[0]}', color: Colors.purple);
          setState(() => _tab = 0);
        } else {
          appState.log('NAV', 'Back press on home — showing exit hint', color: Colors.purple);
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
            NavigationDestination(icon: Icon(Icons.plus_one), label: 'Counter'),
            NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'),
            NavigationDestination(icon: Icon(Icons.tune), label: 'Controls'),
            NavigationDestination(icon: Icon(Icons.assignment), label: 'Form'),
            NavigationDestination(icon: Icon(Icons.brush), label: 'Sketch'),
            NavigationDestination(icon: Icon(Icons.flash_on), label: 'Reaction'),
            NavigationDestination(icon: Icon(Icons.terminal), label: 'Logs'),
          ],
        ),
      ),
    );
  }

  void _switchTab(int i) {
    if (i == _tab) return;
    final newTab = _tabNames[i];
    if (newTab != _lastNavigationLog) {
      appState.log('NAV', 'Tab: ${_tabNames[_tab]} → $newTab', color: Colors.purple);
      _lastNavigationLog = newTab;
    }
    setState(() => _tab = i);
    FocusScope.of(context).unfocus();
  }
}
