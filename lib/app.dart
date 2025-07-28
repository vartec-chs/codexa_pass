import 'package:codexa_pass/app/config/constants.dart';
import 'package:codexa_pass/app/routing/routes.dart';
import 'package:codexa_pass/app/theme/theme.dart';
import 'package:codexa_pass/app/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final theme = ref.watch(themeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      debugShowCheckedModeBanner: false,

      routerConfig: router,
      themeMode: theme,
    );
  }
}
