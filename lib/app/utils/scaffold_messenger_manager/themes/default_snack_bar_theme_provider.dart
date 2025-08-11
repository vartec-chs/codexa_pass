import 'package:flutter/material.dart';
import '../models/snack_bar_type.dart';
import 'snack_bar_theme_provider.dart';

class DefaultSnackBarThemeProvider implements SnackBarThemeProvider {
  @override
  Color getBackgroundColor(BuildContext context, SnackBarType type) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case SnackBarType.error:
        return colorScheme.errorContainer;
      case SnackBarType.warning:
        return const Color(0xFFFFF3CD);
      case SnackBarType.info:
        return colorScheme.primaryContainer;
      case SnackBarType.success:
        return const Color(0xFFD1E7DD);
    }
  }

  @override
  Color getTextColor(BuildContext context, SnackBarType type) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case SnackBarType.error:
        return colorScheme.onErrorContainer;
      case SnackBarType.warning:
        return const Color(0xFF664D03);
      case SnackBarType.info:
        return colorScheme.onPrimaryContainer;
      case SnackBarType.success:
        return const Color(0xFF0F5132);
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
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
      case SnackBarType.info:
        return Icons.info_outline;
      case SnackBarType.success:
        return Icons.check_circle_outline;
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
}
