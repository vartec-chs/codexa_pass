import 'package:codexa_pass/app/routing/routes_path.dart';
import 'package:codexa_pass/demo/priority_snackbar_demo.dart';
import 'package:codexa_pass/features/setup/setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_permission_guard/flutter_permission_guard.dart';

import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

final List<RouteBase> routes = [
  GoRoute(
    path: AppRoutes.home,
    builder: (context, state) => const PrioritySnackBarDemo(),
  ),
  GoRoute(
    path: AppRoutes.setup,
    builder: (context, state) => const SetupScreen(),
    // builder: (context, state) => PermissionGuard.multi(
    //   permissions: [
    //     Permission.accessMediaLocation,
    //     Permission.criticalAlerts,
    //     Permission.storage,
    //     Permission.systemAlertWindow,
    //     Permission.manageExternalStorage,
    //   ],

    //   deniedWidget: Center(
    //     child: Text('You need to grant location permission!'),
    //   ),
    //   child: const SetupScreen(),
    // ),
  ),

  // GoRoute(
  //   path: AppRoutes.logs,
  //   builder: (context, state) => TalkerScreen(talker: talker),
  // ),
];
