import 'package:codexa_pass/app/global.dart';
import 'package:codexa_pass/app/logger/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'theme.dart';

/// Провайдер для управления темой приложения
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// Провайдер для получения светлой темы
// final lightThemeProvider = Provider<ThemeData>((ref) {
//   return AppTheme.lightTheme;
// });

// /// Провайдер для получения темной темы
// final darkThemeProvider = Provider<ThemeData>((ref) {
//   return AppTheme.darkTheme;
// });

/// Провайдер для проверки, активна ли темная тема
final isDarkThemeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeProvider);
  return themeMode == ThemeMode.dark;
});

/// StateNotifier для управления состоянием темы
class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  /// Загружает сохраненную тему из SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);

      if (themeIndex != null) {
        state = ThemeMode.values[themeIndex];
      }
    } catch (e) {
      // В случае ошибки оставляем системную тему
      state = ThemeMode.system;
    }
  }

  /// Сохраняет текущую тему в SharedPreferences
  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
    } catch (e) {
      // Игнорируем ошибки сохранения
    }
  }

  /// Устанавливает светлую тему
  Future<void> setLightTheme() async {
    state = ThemeMode.light;
    logInfo('Theme changed to light', tag: 'Theme');
    await _saveTheme(ThemeMode.light);
  }

  /// Устанавливает темную тему
  Future<void> setDarkTheme() async {
    state = ThemeMode.dark;
    logInfo('Theme changed to dark', tag: 'Theme');
    await _saveTheme(ThemeMode.dark);
  }

  /// Устанавливает системную тему
  Future<void> setSystemTheme() async {
    state = ThemeMode.system;
    logInfo('Theme changed to system', tag: 'Theme');
    await _saveTheme(ThemeMode.system);
  }

  /// Переключает между светлой и темной темой
  Future<void> toggleTheme() async {
    switch (state) {
      case ThemeMode.light:
        await setDarkTheme();
        break;
      case ThemeMode.dark:
        await setLightTheme();
        break;
      case ThemeMode.system:
        // При системной теме переключаемся на противоположную
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        if (brightness == Brightness.dark) {
          await setLightTheme();
        } else {
          await setDarkTheme();
        }
        break;
    }
  }

  /// Возвращает текущий режим темы
  ThemeMode get currentTheme => state;

  /// Проверяет, активна ли темная тема
  bool get isDarkMode => state == ThemeMode.dark;

  /// Проверяет, активна ли светлая тема
  bool get isLightMode => state == ThemeMode.light;

  /// Проверяет, используется ли системная тема
  bool get isSystemMode => state == ThemeMode.system;
}

/// Расширение для удобного доступа к ThemeNotifier
extension ThemeNotifierX on WidgetRef {
  ThemeNotifier get themeNotifier => read(themeProvider.notifier);
}
