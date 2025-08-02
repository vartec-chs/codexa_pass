import 'package:codexa_pass/app/routing/routes_path.dart';
import 'package:codexa_pass/features/home/home.dart';
import 'package:codexa_pass/features/setup/setup.dart';

import 'package:go_router/go_router.dart';

final List<RouteBase> routes = [
  GoRoute(
    path: AppRoutes.home,
    builder: (context, state) => const HomeScreen(),
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
