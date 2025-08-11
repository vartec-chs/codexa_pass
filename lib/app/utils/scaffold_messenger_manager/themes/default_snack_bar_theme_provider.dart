import 'package:flutter/material.dart';
import '../models/snack_bar_type.dart';
import 'snack_bar_theme_provider.dart';

class DefaultSnackBarThemeProvider implements SnackBarThemeProvider {
  @override
  Color getBackgroundColor(BuildContext context, SnackBarType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case SnackBarType.error:
        return isDark
            ? const Color(0xFF5D1A1A) // Темный красно-коричневый
            : const Color(0xFFFFEBEE); // Очень светлый розовый
      case SnackBarType.warning:
        return isDark
            ? const Color(0xFF7A5500).withOpacity(0.9)
            : const Color(0xFFFFF3CD).withOpacity(0.95);
      case SnackBarType.info:
        return isDark
            ? colorScheme.primaryContainer.withOpacity(0.9)
            : colorScheme.primaryContainer.withOpacity(0.95);
      case SnackBarType.success:
        return isDark
            ? const Color(0xFF0A3D28).withOpacity(0.9)
            : const Color(0xFFD1E7DD).withOpacity(0.95);
    }
  }

  @override
  Color getTextColor(BuildContext context, SnackBarType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case SnackBarType.error:
        return isDark
            ? const Color(0xFFFFB4AB) // Светло-розовый для тёмной темы
            : const Color(0xFFB71C1C); // Тёмно-красный для светлой темы
      case SnackBarType.warning:
        return isDark ? const Color(0xFFFAD776) : const Color(0xFF664D03);
      case SnackBarType.info:
        return isDark
            ? colorScheme.onPrimaryContainer
            : colorScheme.onPrimaryContainer;
      case SnackBarType.success:
        return isDark ? const Color(0xFF7FE8A8) : const Color(0xFF0F5132);
    }
  }

  @override
  Color getIconColor(BuildContext context, SnackBarType type) {
    return getTextColor(context, type);
  }

  @override
  IconData getIcon(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return Icons.error_outline_rounded;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.info:
        return Icons.info_outline_rounded;
      case SnackBarType.success:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Duration getDefaultDuration(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return const Duration(seconds: 8);
      case SnackBarType.warning:
        return const Duration(seconds: 6);
      case SnackBarType.info:
        return const Duration(seconds: 4);
      case SnackBarType.success:
        return const Duration(seconds: 3);
    }
  }

  /// Получить цвет границы для SnackBar
  Color getBorderColor(BuildContext context, SnackBarType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case SnackBarType.error:
        return isDark
            ? const Color(0xFFFF5722).withOpacity(0.5)
            : const Color(0xFFD32F2F).withOpacity(0.3);
      case SnackBarType.warning:
        return isDark
            ? const Color(0xFFFFD700).withOpacity(0.5)
            : const Color(0xFFFF9800).withOpacity(0.3);
      case SnackBarType.info:
        return isDark
            ? colorScheme.primary.withOpacity(0.5)
            : colorScheme.primary.withOpacity(0.3);
      case SnackBarType.success:
        return isDark
            ? const Color(0xFF4CAF50).withOpacity(0.5)
            : const Color(0xFF4CAF50).withOpacity(0.3);
    }
  }

  /// Получить цвет тени для SnackBar
  Color getShadowColor(BuildContext context, SnackBarType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case SnackBarType.error:
        return isDark
            ? Colors.red.withOpacity(0.2)
            : Colors.red.withOpacity(0.15);
      case SnackBarType.warning:
        return isDark
            ? Colors.orange.withOpacity(0.2)
            : Colors.orange.withOpacity(0.15);
      case SnackBarType.info:
        return isDark
            ? Colors.blue.withOpacity(0.2)
            : Colors.blue.withOpacity(0.15);
      case SnackBarType.success:
        return isDark
            ? Colors.green.withOpacity(0.2)
            : Colors.green.withOpacity(0.15);
    }
  }

  /// Получить градиент для SnackBar
  LinearGradient? getGradient(BuildContext context, SnackBarType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!isDark) return null; // Градиент только для тёмной темы

    switch (type) {
      case SnackBarType.error:
        return LinearGradient(
          colors: [
            const Color(0xFF5D1A1A).withOpacity(0.95),
            const Color(0xFF8B0000).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case SnackBarType.warning:
        return LinearGradient(
          colors: [
            const Color(0xFF7A5500).withOpacity(0.9),
            const Color(0xFFFFAA00).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case SnackBarType.info:
        return LinearGradient(
          colors: [
            const Color(0xFF1565C0).withOpacity(0.9),
            const Color(0xFF42A5F5).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case SnackBarType.success:
        return LinearGradient(
          colors: [
            const Color(0xFF0A3D28).withOpacity(0.9),
            const Color(0xFF2E7D32).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
