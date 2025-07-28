import 'dart:async';

import 'package:codexa_pass/app.dart';
import 'package:codexa_pass/app/window_manager.dart';
import 'package:flutter/material.dart';

import 'package:codexa_pass/app/logging/logger.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await initLogger(
        config: const LoggerConfig(
          enableFileLogging: true,
          enableConsoleLogging: true,
          prettyFileFormat: false, // Используем JSON формат для файлов
          maxFileSize: 5 * 1024 * 1024, // 5MB
          maxTotalSize: 50 * 1024 * 1024, // 50MB
          flushIntervalMs: 3000, // 3 секунды
          maxMemoryEntries: 50,
          minLevel: AppLogLevel.debug,
        ),
      );

      await WindowManager.initialize();

      runApp(const App());
    },
    (error, stackTrace) {
      logCrash(
        'Unhandled error: $error',
        tag: 'ZONE_ERROR',
        stackTrace: stackTrace.toString(),
        extra: {
          'error_type': error.runtimeType.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    },
  );
}
