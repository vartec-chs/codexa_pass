import 'package:codexa_pass/app/config/constants.dart';
import 'package:codexa_pass/app/global.dart';
import 'package:codexa_pass/app/routing/routes.dart';
import 'package:codexa_pass/app/theme/theme.dart';
import 'package:codexa_pass/app/theme/theme_provider.dart';
import 'package:codexa_pass/app/utils/toast_manager/toast_manager_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final theme = ref.watch(themeProvider);

    // Инициализируем Toast Manager
    ToastManager.initialize(navigatorKey);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      scaffoldMessengerKey: scaffoldMessengerKey,

      debugShowCheckedModeBanner: false,

      routerConfig: router,
      themeMode: theme,
    );
  }
}
