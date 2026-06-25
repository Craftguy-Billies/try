import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'app.dart';
import 'services/audit_logger.dart';

void main() {
  final logger = AuditLogger();
  logger.info('App', 'main() called — initializing Flutter app');

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

  logger.debug('App', 'About to call runApp...');
  runApp(const FrenchLearnApp());
  logger.info('App', 'runApp completed');
}
