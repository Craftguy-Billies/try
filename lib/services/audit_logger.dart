import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error, critical }

class AuditLogger {
  static final AuditLogger _instance = AuditLogger._();
  factory AuditLogger() => _instance;
  AuditLogger._();

  final List<LogEntry> _history = [];
  bool _verbose = true;
  int _maxHistory = 1000;

  void configure({bool verbose = true, int maxHistory = 1000}) {
    _verbose = verbose;
    _maxHistory = maxHistory;
  }

  void log(LogLevel level, String tag, String message,
      {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    final entry = LogEntry(
      timestamp: DateTime.now(), level: level, tag: tag, message: message,
      error: error, stackTrace: stackTrace, data: data,
    );
    _history.add(entry);
    if (_history.length > _maxHistory) _history.removeAt(0);
    if (_verbose || level == LogLevel.error || level == LogLevel.critical) {
      dev.log('[${level.name.toUpperCase()}] $tag: $message',
          name: tag, error: error, stackTrace: stackTrace);
    }
    if (level == LogLevel.critical) {
      FlutterError.reportError(FlutterErrorDetails(
          exception: error ?? message, stack: stackTrace, library: tag));
    }
  }

  void debug(String tag, String msg, {Map<String, dynamic>? data}) => log(LogLevel.debug, tag, msg, data: data);
  void info(String tag, String msg, {Map<String, dynamic>? data}) => log(LogLevel.info, tag, msg, data: data);
  void warn(String tag, String msg, {Map<String, dynamic>? data}) => log(LogLevel.warning, tag, msg, data: data);
  void error(String tag, String msg, {Object? e, StackTrace? s, Map<String, dynamic>? d}) =>
      log(LogLevel.error, tag, msg, error: e, stackTrace: s, data: d);
  void critical(String tag, String msg, {Object? e, StackTrace? s, Map<String, dynamic>? d}) =>
      log(LogLevel.critical, tag, msg, error: e, stackTrace: s, data: d);

  void logScreenView(String screen, {Map<String, dynamic>? p}) => info('Nav', 'Screen: $screen', data: p);
  void logUserAction(String action, {Map<String, dynamic>? p}) => info('Action', action, data: p);
  void logDataLoad(String src, int count, {Duration? dur}) =>
      debug('Data', 'Loaded $count from $src', data: {'count': count, 'ms': dur?.inMilliseconds});

  List<LogEntry> get history => List.unmodifiable(_history);
  void clearHistory() => _history.clear();
}

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String tag;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? data;

  const LogEntry({required this.timestamp, required this.level, required this.tag,
    required this.message, this.error, this.stackTrace, this.data});

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(), 'level': level.name,
    'tag': tag, 'message': message, 'error': error?.toString()};
}
