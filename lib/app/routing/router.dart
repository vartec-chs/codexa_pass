import 'package:codexa_pass/app/common/widget/center_container.dart';
// import 'package:codexa_pass/features/setup/presentation/screen/setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> routes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const CenterContainer(child: Text('Home')),
  ),
  // GoRoute(path: '/setup', builder: (context, state) => const SetupScreen()),
];
