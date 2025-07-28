import 'package:codexa_pass/app/common/widget/title_bar.dart';
import 'package:codexa_pass/app/global.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    observers: [GoTransition.observer, TalkerRouteObserver(talker)],
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final isFirstRun = prefs.getBool('is_first_run') ?? true;

      // Если это первый запуск и пользователь не на setup экране
      if (isFirstRun && state.fullPath != '/setup') {
        return '/setup';
      }

      // Если настройка завершена и пользователь на setup экране
      if (!isFirstRun && state.fullPath == '/setup') {
        return '/';
      }

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
  );
});
