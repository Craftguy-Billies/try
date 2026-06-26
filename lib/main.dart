import 'dart:isolate';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'app.dart';
import 'services/audit_logger.dart';

void main() {
  final logger = AuditLogger();
  final platformDispatcher = ui.PlatformDispatcher.instance;
  logger.info('App', 'main() called — initializing Flutter app', data: {
    'platform': platformDispatcher.platformBrightness.name,
    'locales': platformDispatcher.locales.map((l) => l.languageCode).toList(),
    'accessibility': platformDispatcher.accessibilityFeatures.toString(),
    'textScale': platformDispatcher.textScaleFactor,
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
  platformDispatcher.onError = (Object error, StackTrace stack) {
    logger.critical('PlatformDispatcher', 'Unhandled platform error', e: error, s: stack);
    return true; // Don't terminate app on these errors
  };

  // Catch truly unhandled zone-level errors (Isolate errors, etc.)
  Isolate.current.addErrorListener(RawReceivePort((dynamic pair) {
    final errorAndStack = pair as List<dynamic>;
    logger.critical('Isolate', 'Unhandled isolate error',
        e: errorAndStack.first, s: errorAndStack.last as StackTrace?);
  }).sendPort);
  logger.debug('App', 'Global error handlers installed');

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
      runApp(Directionality(
        textDirection: TextDirection.ltr,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('App failed to start\n\n$e',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ),
      ));
      logger.logRecover('App', 'fallback error widget rendered');
    } catch (e2, stack2) {
      logger.critical('App', 'Even fallback widget failed — total startup failure',
          e: e2, s: stack2);
    }
  }
}
