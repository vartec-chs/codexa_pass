import 'package:codexa_pass/app/common/widget/center_container.dart';
import 'package:codexa_pass/app/routing/routes_path.dart';
import 'package:talker_flutter/talker_flutter.dart';
// import 'package:codexa_pass/features/setup/presentation/screen/setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:codexa_pass/app/global.dart';

final List<RouteBase> routes = [
  GoRoute(
    path: AppRoutes.home,
    builder: (context, state) => const CenterContainer(child: Text('Home')),
  ),
  GoRoute(
    path: AppRoutes.setup,
    builder: (context, state) => const CenterContainer(child: Text('Home')),
  ),

  GoRoute(
    path: AppRoutes.logs,
    builder: (context, state) => TalkerScreen(talker: talker),
  ),
];
