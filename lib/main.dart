import 'dart:isolate';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'app.dart';
import 'services/audit_logger.dart';

void main() {
  final logger = AuditLogger();
  logger.info('App', 'main() called — initializing Flutter app', data: {
    'dart_version': ui.PlatformDispatcher.instance.defaultRouteName,
    'platform': ui.PlatformDispatcher.instance.platformBrightness.name,
  });

  WidgetsFlutterBinding.ensureInitialized();
  logger.debug('App', 'Flutter binding initialized');

  // Capture unhandled errors at the framework / platform level
  FlutterError.onError = (FlutterErrorDetails details) {
    logger.critical('FlutterError', 'Unhandled Flutter exception', e: details.exception, s: details.stack);
    // Also report via debugPrint for dev logging
    FlutterError.dumpErrorToConsole(details);
  };

  // Catch platform-level async errors
  ui.PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    logger.critical('PlatformDispatcher', 'Unhandled platform error', e: error, s: stack);
    return true; // Don't terminate app on these errors
  };

  // Catch truly unhandled zone-level errors (Isolate errors, etc.)
  Isolate.current.addErrorListener(RawReceivePort((dynamic pair) {
    final errorAndStack = pair as List<dynamic>;
    logger.critical('Isolate', 'Unhandled isolate error',
        e: errorAndStack.first, s: errorAndStack.last as StackTrace?);
  }).sendPort);

  // Catch errors during runApp itself (synchronous)
  try {
    logger.debug('App', 'About to call runApp...');
    runApp(const FrenchLearnApp());
    logger.info('App', 'runApp completed');
  } catch (e, stack) {
    logger.critical('App', 'runApp threw synchronously — app may not render',
        e: e, s: stack);
    // Attempt to show a minimal error widget as fallback
    try {
      runApp(MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('App failed to start: $e',
                textDirection: TextDirection.ltr),
          ),
        ),
      ));
    } catch (_) {
      // Nothing more we can do
    }
  }
}
