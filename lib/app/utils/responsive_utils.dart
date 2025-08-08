import 'package:flutter/material.dart';

/// Утилита для адаптивного дизайна
class ResponsiveUtils {
  /// Брейкпоинты для разных размеров экрана
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMinWidth = 1025;

  /// Проверяет, является ли экран мобильным
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= mobileMaxWidth;
  }

  /// Проверяет, является ли экран планшетом
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > mobileMaxWidth && width <= tabletMaxWidth;
  }

  /// Проверяет, является ли экран десктопом
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopMinWidth;
  }

  /// Возвращает адаптивное значение в зависимости от размера экрана
  static T responsive<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  /// Возвращает адаптивный отступ
  static EdgeInsets adaptivePadding(BuildContext context) {
    return responsive(
      context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  /// Возвращает адаптивный размер шрифта
  static double adaptiveFontSize(BuildContext context, double baseSize) {
    return responsive(
      context,
      mobile: baseSize,
      tablet: baseSize * 1.1,
      desktop: baseSize * 1.2,
    );
  }

  /// Возвращает максимальную ширину контента
  static double getMaxContentWidth(BuildContext context) {
    return responsive(
      context,
      mobile: double.infinity,
      tablet: 600,
      desktop: 800,
    );
  }
}
