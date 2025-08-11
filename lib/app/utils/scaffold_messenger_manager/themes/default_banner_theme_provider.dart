import 'package:flutter/material.dart';
import '../models/banner_data.dart';
import 'banner_theme_provider.dart';

class DefaultBannerThemeProvider implements BannerThemeProvider {
  @override
  Color getBackgroundColor(BuildContext context, BannerType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case BannerType.error:
        return isDark
            ? const Color(0xFF5D1A1A).withOpacity(
                0.9,
              ) // Темный красно-коричневый
            : const Color(
                0xFFFFEBEE,
              ).withOpacity(0.95); // Очень светлый розовый
      case BannerType.warning:
        return isDark
            ? const Color(0xFF7A5500).withOpacity(0.9)
            : const Color(0xFFFFF3CD).withOpacity(0.95);
      case BannerType.info:
        return isDark
            ? colorScheme.primaryContainer.withOpacity(0.9)
            : colorScheme.primaryContainer.withOpacity(0.95);
      case BannerType.success:
        return isDark
            ? const Color(0xFF0A3D28).withOpacity(0.9)
            : const Color(0xFFD1E7DD).withOpacity(0.95);
    }
  }

  @override
  Color getTextColor(BuildContext context, BannerType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case BannerType.error:
        return isDark
            ? const Color(0xFFFFB4AB) // Светло-розовый для тёмной темы
            : const Color(0xFFB71C1C); // Тёмно-красный для светлой темы
      case BannerType.warning:
        return isDark ? const Color(0xFFFAD776) : const Color(0xFF664D03);
      case BannerType.info:
        return isDark
            ? colorScheme.onPrimaryContainer
            : colorScheme.onPrimaryContainer;
      case BannerType.success:
        return isDark ? const Color(0xFF7FE8A8) : const Color(0xFF0F5132);
    }
  }

  @override
  Color getIconColor(BuildContext context, BannerType type) {
    return getTextColor(context, type);
  }

  @override
  IconData getIcon(BannerType type) {
    switch (type) {
      case BannerType.error:
        return Icons.error_outline_rounded;
      case BannerType.warning:
        return Icons.warning_amber_outlined;
      case BannerType.info:
        return Icons.info_outline_rounded;
      case BannerType.success:
        return Icons.check_circle_outline_rounded;
    }
  }

  @override
  Widget? getLeading(BuildContext context, BannerType type) {
    final iconColor = getIconColor(context, type);
    final icon = getIcon(type);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  /// Получить цвет границы для Banner
  Color getBorderColor(BuildContext context, BannerType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case BannerType.error:
        return isDark
            ? const Color(0xFFFF5722).withOpacity(0.5)
            : const Color(0xFFD32F2F).withOpacity(0.3);
      case BannerType.warning:
        return isDark
            ? const Color(0xFFFFD700).withOpacity(0.5)
            : const Color(0xFFFF9800).withOpacity(0.3);
      case BannerType.info:
        return isDark
            ? const Color(0xFF42A5F5).withOpacity(0.5)
            : const Color(0xFF1976D2).withOpacity(0.3);
      case BannerType.success:
        return isDark
            ? const Color(0xFF4CAF50).withOpacity(0.5)
            : const Color(0xFF4CAF50).withOpacity(0.3);
    }
  }

  /// Получить цвет тени для Banner
  Color getShadowColor(BuildContext context, BannerType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case BannerType.error:
        return isDark
            ? Colors.red.withOpacity(0.3)
            : Colors.red.withOpacity(0.2);
      case BannerType.warning:
        return isDark
            ? Colors.orange.withOpacity(0.3)
            : Colors.orange.withOpacity(0.2);
      case BannerType.info:
        return isDark
            ? Colors.blue.withOpacity(0.3)
            : Colors.blue.withOpacity(0.2);
      case BannerType.success:
        return isDark
            ? Colors.green.withOpacity(0.3)
            : Colors.green.withOpacity(0.2);
    }
  }

  /// Получить цвет для разделителя
  Color getDividerColor(BuildContext context, BannerType type) {
    return getBorderColor(context, type);
  }

  /// Получить цвет поверхности
  Color getSurfaceTintColor(BuildContext context, BannerType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case BannerType.error:
        return isDark ? const Color(0xFFFF8A80) : const Color(0xFFFFCDD2);
      case BannerType.warning:
        return isDark ? const Color(0xFFFFCC80) : const Color(0xFFFFF9C4);
      case BannerType.info:
        return isDark ? const Color(0xFF81D4FA) : const Color(0xFFE1F5FE);
      case BannerType.success:
        return isDark ? const Color(0xFF81C784) : const Color(0xFFC8E6C9);
    }
  }
}
