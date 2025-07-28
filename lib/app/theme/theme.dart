import 'package:flutter/material.dart';
import 'theme_light.dart' show appLightTheme;
import 'theme_dark.dart' show appDarkTheme;

class AppTheme {
  final BuildContext context;

  const AppTheme(this.context);

  static AppTheme of(BuildContext context) => AppTheme(context);

  static ThemeData get lightTheme {
    return appLightTheme;
  }

  static ThemeData get darkTheme {
    return appDarkTheme;
  }
}
