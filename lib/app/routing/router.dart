import 'package:codexa_pass/app/common/widget/center_container.dart';
import 'package:codexa_pass/app/routing/routes_path.dart';
import 'package:codexa_pass/demo/priority_snackbar_demo.dart';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';


final List<RouteBase> routes = [
  GoRoute(
    path: AppRoutes.home,
    builder: (context, state) => const PrioritySnackBarDemo(),
  ),
  GoRoute(
    path: AppRoutes.setup,
    builder: (context, state) => const CenterContainer(child: Text('Home')),
  ),

  // GoRoute(
  //   path: AppRoutes.logs,
  //   builder: (context, state) => TalkerScreen(talker: talker),
  // ),
];
