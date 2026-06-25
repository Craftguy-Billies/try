import 'dart:core';
import 'package:flutter/foundation.dart';

enum LogLevel { verbose, debug, info, warning, error }

class DebugLogger {
  static bool _enabled = true;
  static LogLevel _currentLevel = LogLevel.verbose;
  static DateTime? _sessionStart;
  static final List<String> _buffer = [];
  static const int _maxBufferSize = 2000;

  DebugLogger._();

  static void init() {
    _sessionStart = DateTime.now();
    _buffer.clear();
    debugPrint('[FrenchApp] Session started at $_sessionStart');
  }

  static bool get isEnabled => _enabled;

  static void setEnabled(bool enabled) {
    _enabled = enabled;
    _log(LogLevel.info, 'DebugLogger', 'Logging ${enabled ? "enabled" : "disabled"}');
  }

  static void setLevel(LogLevel level) {
    final old = _currentLevel;
    _currentLevel = level;
    _log(LogLevel.info, 'DebugLogger', 'Log level changed from $old to $level');
  }

  static LogLevel get currentLevel => _currentLevel;

  static List<String> get buffer => List.unmodifiable(_buffer);

  static void flushBuffer() => _buffer.clear();

  // ─── Logging methods ───

  static void logScreenView(String screen, {Map<String, dynamic>? details}) {
    _log(LogLevel.info, 'SCREEN', 'View: $screen', details: details);
  }

  static void logAction(String action, {Map<String, dynamic>? details}) {
    _log(LogLevel.info, 'ACTION', action, details: details);
  }

  static void logError(String context, dynamic error, {StackTrace? stack}) {
    final parts = <String>['Context: $context', 'Error: $error'];
    if (stack != null) parts.add('Stack: $stack');
    _log(LogLevel.error, 'ERROR', parts.join(' | '));
  }

  static void logNavigation(String from, String to) {
    _log(LogLevel.debug, 'NAV', '$from → $to');
  }

  static void logStateChange(String provider, String change) {
    _log(LogLevel.debug, 'STATE', '[$provider] $change');
  }

  static void logUserEvent(String event, {Map<String, dynamic>? data}) {
    _log(LogLevel.info, 'USER_EVENT', event, details: data);
  }

  static void logApiCall(String endpoint, {Map<String, dynamic>? params}) {
    _log(LogLevel.debug, 'API', endpoint, details: params);
  }

  static void logAppLifecycle(String state) {
    _log(LogLevel.info, 'LIFECYCLE', state);
  }

  static void logInit(String component) {
    _log(LogLevel.info, 'INIT', component);
  }

  // ─── Internal ───

  static void _log(LogLevel level, String tag, String message, {Map<String, dynamic>? details}) {
    if (!_enabled || level.index < _currentLevel.index) return;

    final ts = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(7);
    final detailStr = details != null && details.isNotEmpty ? ' | ${_formatDetails(details)}' : '';
    final line = '[$ts] $levelStr [$tag] $message$detailStr';

    _addToBuffer(line);
    debugPrint('[FrenchApp] $line');
  }

  static String _formatDetails(Map<String, dynamic> details) {
    return details.entries.map((e) => '${e.key}=${e.value}').join(', ');
  }

  static void _addToBuffer(String line) {
    _buffer.add(line);
    if (_buffer.length > _maxBufferSize) {
      _buffer.removeRange(0, _buffer.length - _maxBufferSize);
    }
  }
}
