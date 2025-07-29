import 'package:codexa_pass/app/common/widget/title_bar.dart';

import 'package:codexa_pass/app/logger/route_observer.dart';
import 'package:codexa_pass/app/routing/routes_path.dart';

import 'router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';

import 'package:universal_platform/universal_platform.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,

    observers: [GoTransition.observer, LoggingRouteObserver()],
    redirect: (context, state) async {
      // final prefs = await SharedPreferences.getInstance();
      // final isFirstRun = prefs.getBool('is_first_run') ?? true;

      // // Если это первый запуск и пользователь не на setup экране
      // if (isFirstRun && state.fullPath != '/setup') {
      //   return '/setup';
      // }

      // // Если настройка завершена и пользователь на setup экране
      // if (!isFirstRun && state.fullPath == '/setup') {
      //   return '/';
      // }

      return null;
    },
    routes: UniversalPlatform.isDesktop
        ? [
            ShellRoute(
              builder: (context, state, child) {
                return Column(
                  children: [
                    TitleBar(),
                    Expanded(child: child),
                  ],
                );
              },
              routes: routes,
            ),
          ]
        : routes,

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: Text('Error'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Oops! Something went wrong.'),
            SizedBox(width: 8),
            Text(state.error.toString()),
          ],
        ),
      ),
    ),
  );
});
