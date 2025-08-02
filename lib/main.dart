import 'dart:async';

import 'package:codexa_pass/app.dart';

import 'package:codexa_pass/app/logger/app_logger.dart';
import 'package:codexa_pass/app/logger/models.dart';
import 'package:codexa_pass/app/logger/riverpod_observer.dart';
import 'package:codexa_pass/app/utils/snack_bar_message.dart';
import 'package:codexa_pass/app/window_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:flutter/foundation.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await AppLogger.instance.initialize(
        config: const LoggerConfig(
          maxFileSize: 5 * 1024 * 1024, // 5MB
          maxFileCount: 5,
          bufferSize: 50,
          bufferFlushInterval: Duration(seconds: 15),
          enableDebug: true,
          enableConsoleOutput: true,
          enableFileOutput: true,
          enableCrashReports: true,
        ),
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        AppLogger.instance.error(
          'Flutter error: ${details.exceptionAsString()}',
          stackTrace: details.stack,
        );
        SnackBarManager.showError(
          'Произошла ошибка в приложении',
          subtitle: details.exceptionAsString(),
          actionLabel: 'Скопировать',
          onAction: () {
            Clipboard.setData(ClipboardData(text: details.exceptionAsString()));
          },
        );
      };

      PlatformDispatcher.instance.onError = (error, stackTrace) {
        AppLogger.instance.error(
          'Platform error: ${error.toString()}',
          stackTrace: stackTrace,
        );
        SnackBarManager.showError(
          'Произошла ошибка в приложении',
          subtitle: error.toString(),
          actionLabel: 'Скопировать',
          onAction: () {
            Clipboard.setData(ClipboardData(text: error.toString()));
          },
        );

        return true;
      };

      await WindowManager.initialize();

      runApp(
        ProviderScope(
          observers: [LoggingProviderObserver()],

          child: const App(),
        ),
      );

      AppLogger.instance.info('App started');
    },
    (error, stackTrace) {
      logError(
        'Global error: ${error.toString()}',
        stackTrace: stackTrace,
        tag: 'Main',
      );
      SnackBarManager.showError(
        'Произошла непредвиденная ошибка',
        subtitle: error.toString(),
        actionLabel: 'Скопировать',
        onAction: () {
          Clipboard.setData(ClipboardData(text: error.toString()));
        },
      );
    },
  );
}
