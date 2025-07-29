import 'dart:async';

import 'package:codexa_pass/app.dart';

import 'package:codexa_pass/app/logger/app_logger.dart';
import 'package:codexa_pass/app/logger/models.dart';
import 'package:codexa_pass/app/logger/riverpod_observer.dart';
import 'package:codexa_pass/app/window_manager.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_permission_guard/flutter_permission_guard.dart';
import 'package:permission_handler/permission_handler.dart';

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
      };

      PlatformDispatcher.instance.onError = (error, stackTrace) {
        AppLogger.instance.error(
          'Platform error: ${error.toString()}',
          stackTrace: stackTrace,
        );
        return true;
      };

      await WindowManager.initialize();

      runApp(
        ProviderScope(
          observers: [LoggingProviderObserver()],
          child: PermissionGuard.multi(
            permissions: [
              Permission.accessMediaLocation,
              Permission.criticalAlerts,
              Permission.storage,
              Permission.systemAlertWindow,
              Permission.manageExternalStorage,
            ],
            deniedWidget: Center(
              child: Text('You need to grant location permission!'),
            ),
            child: const App(),
          ),
        ),
      );

      AppLogger.instance.info('App started');

      // runApp(
      //   TalkerWrapper(
      //     talker: talker,
      //     options: const TalkerWrapperOptions(enableErrorAlerts: true),
      //     child: ProviderScope(
      //       observers: [TalkerRiverpodObserver()],
      //       child: PermissionGuard.multi(
      //         permissions: [
      //           Permission.accessMediaLocation,
      //           Permission.criticalAlerts,
      //           Permission.storage,
      //           Permission.systemAlertWindow,
      //           Permission.manageExternalStorage,
      //         ],
      //         deniedWidget: Center(
      //           child: Text('You need to grant location permission!'),
      //         ),
      //         child: const App(),
      //       ),
      //     ),
      //   ),
      // );
    },
    (error, stackTrace) {
      // talker.handle(error, stackTrace, 'Main');
      logError(
        'Global error: ${error.toString()}',
        stackTrace: stackTrace,
        tag: 'Main',
      );
    },
  );
}
