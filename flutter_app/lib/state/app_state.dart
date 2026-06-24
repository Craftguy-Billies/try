import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/log_entry.dart';
import '../models/todo_item.dart';

class AppState extends ChangeNotifier {
  static const _maxLogs = 3000;
  static const _maxTasksWarning = 500;

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

  // ---- Counter ----
  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
    log('COUNTER', 'Incremented → $_counter', color: Colors.green);
    notifyListeners();
  }

  void decrement() {
    if (_counter <= 0) {
      log('COUNTER', 'Decrement blocked at 0 (already at minimum)', color: Colors.orange);
      return;
    }
    _counter--;
    log('COUNTER', 'Decremented → $_counter', color: Colors.orange);
    notifyListeners();
  }

  void resetCounter() {
    final prev = _counter;
    _counter = 0;
    log('COUNTER', 'Reset from $prev to 0', color: Colors.red);
    notifyListeners();
  }

  // ---- Tasks ----
  final List<TodoItem> _tasks = [];
  UnmodifiableListView<TodoItem> get tasks => UnmodifiableListView(_tasks);
  int get taskCount => _tasks.length;
  int get doneTaskCount => _tasks.where((t) => t.done).length;

  bool addTask(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      log('TASK', 'Add rejected: empty title', color: Colors.red);
      return false;
    }
    if (trimmed.length > 200) {
      log('TASK', 'Add rejected: title too long (${trimmed.length} > 200)', color: Colors.red);
      return false;
    }
    final t = TodoItem(
      id: '${DateTime.now().millisecondsSinceEpoch}_${_tasks.length}',
      title: trimmed,
    );
    _tasks.add(t);
    log('TASK', 'Added: "$trimmed" (total: ${_tasks.length})', color: Colors.teal);
    if (_tasks.length >= _maxTasksWarning && _tasks.length % 100 == 0) {
      log('TASK', 'WARNING: ${_tasks.length} tasks — consider clearing done items', color: Colors.orange);
    }
    notifyListeners();
    return true;
  }

  bool toggleTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) {
      log('TASK', 'Toggle failed: task $id not found', color: Colors.red);
      return false;
    }
    final old = _tasks[idx];
    _tasks[idx] = old.copyWith(done: !old.done);
    log('TASK', 'Toggled: "${old.title}" → ${_tasks[idx].done ? "DONE" : "PENDING"}', color: _tasks[idx].done ? Colors.green : Colors.orange);
    notifyListeners();
    return true;
  }

  bool removeTask(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx == -1) {
      log('TASK', 'Remove failed: task $id not found', color: Colors.red);
      return false;
    }
    final removed = _tasks[idx];
    _tasks.removeAt(idx);
    log('TASK', 'Removed: "${removed.title}" (${_tasks.length} remaining)', color: Colors.red);
    notifyListeners();
    return true;
  }

  int clearDoneTasks() {
    final done = _tasks.where((t) => t.done).toList();
    if (done.isEmpty) {
      log('TASK', 'No done tasks to clear', color: Colors.grey);
      return 0;
    }
    _tasks.removeWhere((t) => t.done);
    log('TASK', 'Cleared ${done.length} done task(s) (${_tasks.length} remaining)', color: Colors.red);
    notifyListeners();
    return done.length;
  }

  // ---- Controls ----
  double _sliderValue = 50;
  double get sliderValue => _sliderValue;
  void setSlider(double v) { _sliderValue = v; notifyListeners(); }
  void commitSlider(double v) {
    _sliderValue = v;
    log('CONTROL', 'Slider final: ${v.toInt()}%', color: Colors.indigo);
    notifyListeners();
  }

  bool _switchNotifications = true;
  bool get switchNotifications => _switchNotifications;
  void toggleNotifications(bool v) {
    if (_switchNotifications == v) return;
    _switchNotifications = v;
    log('CONTROL', 'Notifications: ${v ? "ON" : "OFF"}', color: Colors.indigo);
    notifyListeners();
  }

  bool _switchVibration = true;
  bool get switchVibration => _switchVibration;
  void toggleVibration(bool v) {
    if (_switchVibration == v) return;
    _switchVibration = v;
    log('CONTROL', 'Vibration: ${v ? "ON" : "OFF"}', color: Colors.indigo);
    notifyListeners();
  }

  double _rating = 3;
  double get rating => _rating;
  void setRating(double v) {
    if (_rating == v) return;
    _rating = v;
    log('CONTROL', 'Rating: ${v.toInt()}/5', color: Colors.amber);
    notifyListeners();
  }

  String _selectedFruit = 'Apple';
  String get selectedFruit => _selectedFruit;
  void setFruit(String? v) {
    if (v == null || v == _selectedFruit) return;
    _selectedFruit = v;
    log('CONTROL', 'Selected fruit: $v', color: Colors.indigo);
    notifyListeners();
  }

  // ---- Form ----
  bool _agreedToTerms = false;
  bool get agreedToTerms => _agreedToTerms;
  void setAgreedToTerms(bool v) {
    if (_agreedToTerms == v) return;
    _agreedToTerms = v;
    log('FORM', 'Terms agreement: ${v ? "ACCEPTED" : "DECLINED"}', color: v ? Colors.green : Colors.orange);
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
    _tasks.clear();
    super.dispose();
  }
}

final AppState appState = AppState();
