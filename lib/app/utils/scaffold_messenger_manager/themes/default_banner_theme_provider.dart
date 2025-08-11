import 'package:flutter/material.dart';
import '../models/banner_data.dart';
import 'banner_theme_provider.dart';

class DefaultBannerThemeProvider implements BannerThemeProvider {
  @override
  Color getBackgroundColor(BuildContext context, BannerType type) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case BannerType.error:
        return colorScheme.errorContainer;
      case BannerType.warning:
        return const Color(0xFFFFF3CD);
      case BannerType.info:
        return colorScheme.primaryContainer;
      case BannerType.success:
        return const Color(0xFFD1E7DD);
    }
  }

  @override
  Color getTextColor(BuildContext context, BannerType type) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case BannerType.error:
        return colorScheme.onErrorContainer;
      case BannerType.warning:
        return const Color(0xFF664D03);
      case BannerType.info:
        return colorScheme.onPrimaryContainer;
      case BannerType.success:
        return const Color(0xFF0F5132);
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
        return Icons.error_outline;
      case BannerType.warning:
        return Icons.warning_amber_outlined;
      case BannerType.info:
        return Icons.info_outline;
      case BannerType.success:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget? getLeading(BuildContext context, BannerType type) {
    return Icon(getIcon(type), color: getIconColor(context, type));
  }
}
