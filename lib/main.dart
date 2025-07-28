import 'dart:async';

import 'package:codexa_pass/app.dart';
import 'package:codexa_pass/app/global.dart';
import 'package:codexa_pass/app/window_manager.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import "package:talker_flutter/talker_flutter.dart";
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await WindowManager.initialize();

      runApp(
        TalkerWrapper(
          talker: talker,
          options: const TalkerWrapperOptions(enableErrorAlerts: true),
          child: ProviderScope(
            observers: [TalkerRiverpodObserver()],
            child: App(),
          ),
        ),
      );
    },
    (error, stackTrace) {
      talker.handle(error, stackTrace, 'Main');
    },
  );
}
