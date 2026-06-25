import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/log_entry.dart';

class AppState extends ChangeNotifier {
  static const _maxLogs = 3000;

  final List<LogEntry> _logs = [];
  UnmodifiableListView<LogEntry> get logs => UnmodifiableListView(_logs);
  int get logCount => _logs.length;

  bool _initialized = false;
  bool get initialized => _initialized;

  void init() {
    if (_initialized) return;
    _initialized = true;
    log('SYSTEM', 'AppState initialized', color: Colors.teal);
  }

  // ---- Logging ----
  void log(String type, String detail, {Color? color}) {
    _logs.add(LogEntry(
      time: DateTime.now(),
      type: type,
      detail: detail,
      color: color ?? Colors.blue,
    ));
    if (_logs.length > _maxLogs) {
      final removed = _logs.length - (_maxLogs - 500);
      _logs.removeRange(0, removed);
      if (_logs.length % 500 == 0) {
        log('SYSTEM', 'Log buffer trimmed: $_maxLogs max entries', color: Colors.grey);
      }
    }
    notifyListeners();
  }

  void clearLogs() {
    final count = _logs.length;
    _logs.clear();
    log('SYSTEM', 'Cleared $count log entries', color: Colors.grey);
    notifyListeners();
  }

  // ---- Lifecycle ----
  String _lifecycleState = 'resumed';
  String get lifecycleState => _lifecycleState;
  void setLifecycleState(String state) {
    if (_lifecycleState == state) return;
    final prev = _lifecycleState;
    _lifecycleState = state;
    log('LIFECYCLE', 'App state: $prev → $state', color: Colors.purple);
    notifyListeners();
  }

  @override
  void dispose() {
    _logs.clear();
    super.dispose();
  }
}

final AppState appState = AppState();
