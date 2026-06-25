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
  int _seq = 0;

  void configure({bool verbose = true, int maxHistory = 1000}) {
    _verbose = verbose;
    _maxHistory = maxHistory;
    debug('Sys', 'Logger configured', data: {'verbose': verbose, 'maxHistory': maxHistory});
  }

  int _nextSeq() => ++_seq;

  // ─── Core ────────────────────────────────────────────────────

  void log(LogLevel level, String tag, String message,
      {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    final entry = LogEntry(
      timestamp: DateTime.now(), level: level, tag: tag, message: message,
      error: error, stackTrace: stackTrace, data: data,
    );
    _history.add(entry);
    if (_history.length > _maxHistory) _history.removeAt(0);
    if (_verbose || level == LogLevel.error || level == LogLevel.critical) {
      dev.log('[#${_nextSeq()}] [${level.name.toUpperCase()}] $tag: $message',
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

  // ─── Lifecycle ───────────────────────────────────────────────

  void logLifecycle(String widget, String event, {Map<String, dynamic>? data}) =>
      debug('Lifecycle', '$widget.$event', data: data);

  void logInit(String widget, {Map<String, dynamic>? data}) =>
      debug('Lifecycle', '$widget.initState', data: data);

  void logDispose(String widget, {Map<String, dynamic>? data}) =>
      debug('Lifecycle', '$widget.dispose', data: data);

  void logBuild(String widget, {Map<String, dynamic>? data}) =>
      debug('Lifecycle', '$widget.build', data: data);

  // ─── Async ───────────────────────────────────────────────────

  void logAsyncStart(String tag, String operation, {Map<String, dynamic>? data}) =>
      debug(tag, '$operation → start', data: data);

  void logAsyncDone(String tag, String operation, {Map<String, dynamic>? data, Duration? elapsed}) {
    final d = Map<String, dynamic>.from(data ?? {});
    if (elapsed != null) d['elapsed_ms'] = elapsed.inMilliseconds;
    debug(tag, '$operation → done', data: d);
  }

  void logAsyncFail(String tag, String operation, Object error, StackTrace? stack,
      {Map<String, dynamic>? data}) {
    final d = Map<String, dynamic>.from(data ?? {});
    d['error_type'] = error.runtimeType.toString();
    this.error(tag, '$operation → FAIL', e: error, s: stack, d: d);
  }

  // ─── Navigation ──────────────────────────────────────────────

  void logScreenView(String screen, {Map<String, dynamic>? p}) =>
      info('Nav', '→ $screen', data: p);

  void logNavigate(String from, String to, {String method = 'push', Map<String, dynamic>? data}) =>
      info('Nav', '$from —$method→ $to', data: data);

  void logPop(String from, {dynamic result, Map<String, dynamic>? data}) =>
      debug('Nav', '$from ← pop', data: {'result': result?.toString(), if (data != null) ...data});

  // ─── State ───────────────────────────────────────────────────

  void logStateChange(String widget, String field, String from, String to, {Map<String, dynamic>? data}) =>
      debug('State', '$widget.$field: $from → $to', data: data);

  void logStateChangeInt(String widget, String field, int from, int to, {Map<String, dynamic>? data}) =>
      debug('State', '$widget.$field: $from → $to', data: data);

  void logStateChangeBool(String widget, String field, bool from, bool to, {Map<String, dynamic>? data}) =>
      debug('State', '$widget.$field: $from → $to', data: data);

  // ─── User Interaction ────────────────────────────────────────

  void logUserAction(String action, {Map<String, dynamic>? p}) =>
      info('Action', action, data: p);

  void logButton(String widget, String label, {Map<String, dynamic>? data}) =>
      info('Button', '$widget » $label', data: data);

  void logTap(String widget, String target, {Map<String, dynamic>? data}) =>
      debug('Tap', '$widget → $target', data: data);

  void logSwipe(String widget, {int? from, int? to, Map<String, dynamic>? data}) =>
      debug('Swipe', '$widget ${from ?? "?"}→${to ?? "?"}', data: data);

  void logBackPress(String screen, {bool handled = true, Map<String, dynamic>? data}) =>
      debug('Back', '$screen back-press handled=$handled', data: data);

  // ─── Dialogs ─────────────────────────────────────────────────

  void logDialogShow(String dialog, String trigger, {Map<String, dynamic>? data}) =>
      debug('Dialog', '$dialog shown (trigger: $trigger)', data: data);

  void logDialogResult(String dialog, String result, {Map<String, dynamic>? data}) =>
      info('Dialog', '$dialog → $result', data: data);

  // ─── Guard / Edge-case ───────────────────────────────────────

  void logGuard(String widget, String guard, {Map<String, dynamic>? data}) =>
      warn('Guard', '$widget blocked by $guard', data: data);

  void logEdge(String widget, String scenario, {Map<String, dynamic>? data}) =>
      info('Edge', '$widget: $scenario', data: data);

  void logGuardSkip(String widget, String guard, {Map<String, dynamic>? data}) =>
      debug('Guard', '$widget skip: $guard', data: data);

  // ─── Timer ───────────────────────────────────────────────────

  void logTimerStart(String widget, {int? seconds, Map<String, dynamic>? data}) =>
      debug('Timer', '$widget started', data: {'seconds': seconds, if (data != null) ...data});

  void logTimerTick(String widget, int remaining, {Map<String, dynamic>? data}) =>
      debug('Timer', '$widget tick: ${remaining}s left', data: data);

  void logTimerExpire(String widget, {Map<String, dynamic>? data}) =>
      info('Timer', '$widget expired', data: data);

  void logTimerCancel(String widget, {Map<String, dynamic>? data}) =>
      debug('Timer', '$widget cancelled', data: data);

  // ─── Animation ───────────────────────────────────────────────

  void logAnimationStart(String widget, String anim, {Map<String, dynamic>? data}) =>
      debug('Anim', '$widget.$anim start', data: data);

  void logAnimationDone(String widget, String anim, {Map<String, dynamic>? data}) =>
      debug('Anim', '$widget.$anim done', data: data);

  // ─── Audio ───────────────────────────────────────────────────

  void logAudio(String event, {String? text, Map<String, dynamic>? data}) =>
      info('Audio', event, data: {'text_len': text?.length, if (data != null) ...data});

  // ─── Search / Filter ─────────────────────────────────────────

  void logSearch(String widget, String query, {int? results, Map<String, dynamic>? data}) =>
      debug('Search', '$widget query="$query" → $results results', data: data);

  void logFilter(String widget, String filter, {int? results, Map<String, dynamic>? data}) =>
      debug('Filter', '$widget $filter → $results results', data: data);

  // ─── Toggle ──────────────────────────────────────────────────

  void logToggle(String widget, String toggle, bool newValue, {Map<String, dynamic>? data}) =>
      info('Toggle', '$widget.$toggle → $newValue', data: data);

  // ─── Data ────────────────────────────────────────────────────

  void logDataLoad(String src, int count, {Duration? dur}) =>
      info('Data', 'Loaded $count items from $src', data: {'count': count, 'ms': dur?.inMilliseconds});

  void logDataSave(String key, {Map<String, dynamic>? data}) =>
      debug('Data', 'Saved $key', data: data);

  void logDataClear(String domain, {Map<String, dynamic>? data}) =>
      warn('Data', 'Cleared $domain', data: data);

  // ─── Error recovery ──────────────────────────────────────────

  void logRecover(String widget, String context, {Map<String, dynamic>? data}) =>
      warn('Recover', '$widget recovered in $context', data: data);

  void logFallback(String widget, String reason, String fallback, {Map<String, dynamic>? data}) =>
      warn('Fallback', '$widget: $reason → using $fallback', data: data);

  // ─── Provider / DI ───────────────────────────────────────────

  void logProvider(String action, String provider, {Map<String, dynamic>? data}) =>
      debug('Provider', '$action $provider', data: data);

  // ─── History access ──────────────────────────────────────────

  List<LogEntry> get history => List.unmodifiable(_history);
  void clearHistory() => _history.clear();
  int get historyLength => _history.length;
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
