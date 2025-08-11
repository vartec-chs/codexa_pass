import 'package:codexa_pass/app/config/constants.dart';
import 'package:codexa_pass/app/global.dart';
import 'package:codexa_pass/app/routing/routes.dart';
import 'package:codexa_pass/app/theme/theme.dart';
import 'package:codexa_pass/app/theme/theme_provider.dart';
import 'package:codexa_pass/app/utils/toast_manager/toast_manager_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // Инициализируем Toast Manager один раз
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToastManager.initialize(navigatorKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(goRouterProvider);
    final theme = ref.watch(themeProvider);

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
