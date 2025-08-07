import 'package:flutter/material.dart';

/// Enum для типов уведомлений Top Snack Bar
enum TopSnackBarType { success, error, warning, info }

/// Модель для конфигурации Top Snack Bar
class TopSnackBarConfig {
  final String message;
  final TopSnackBarType type;
  final Duration duration;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final bool showCloseButton;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final String? subtitle;
  final bool isDismissible;
  final Widget? customIcon;
  final DateTime timestamp;

  TopSnackBarConfig({
    required this.message,
    this.type = TopSnackBarType.info,
    this.duration = const Duration(seconds: 3),
    this.onTap,
    this.onDismiss,
    this.showCloseButton = true,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.subtitle,
    this.isDismissible = true,
    this.customIcon,
  }) : timestamp = DateTime.now();
}

/// Цвета для Top Snack Bar
class TopSnackBarColors {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color borderColor;
  final Color shadowColor;

  const TopSnackBarColors({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.borderColor,
    required this.shadowColor,
  });

  /// Получить цвета для типа сообщения
  static TopSnackBarColors forType(TopSnackBarType type) {
    switch (type) {
      case TopSnackBarType.success:
        return const TopSnackBarColors(
          backgroundColor: Color(0xFF4CAF50),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: Color(0xFF388E3C),
          shadowColor: Color(0xFF4CAF50),
        );
      case TopSnackBarType.error:
        return const TopSnackBarColors(
          backgroundColor: Color(0xFFF44336),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: Color(0xFFD32F2F),
          shadowColor: Color(0xFFF44336),
        );
      case TopSnackBarType.warning:
        return const TopSnackBarColors(
          backgroundColor: Color(0xFFFF9800),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: Color(0xFFF57C00),
          shadowColor: Color(0xFFFF9800),
        );
      case TopSnackBarType.info:
        return const TopSnackBarColors(
          backgroundColor: Color(0xFF2196F3),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: Color(0xFF1976D2),
          shadowColor: Color(0xFF2196F3),
        );
    }
  }
}

/// Тема для Top Snack Bar
class TopSnackBarTheme {
  final LinearGradient? gradient;
  final List<BoxShadow> shadows;

  const TopSnackBarTheme({this.gradient, required this.shadows});

  /// Получить тему для типа сообщения
  static TopSnackBarTheme forType(TopSnackBarType type) {
    final colors = TopSnackBarColors.forType(type);

    return TopSnackBarTheme(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colors.backgroundColor,
          colors.backgroundColor.withOpacity(0.9),
        ],
      ),
      shadows: [
        BoxShadow(
          color: colors.shadowColor.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    );
  }
}

/// Утилиты для Top Snack Bar
class TopSnackBarUtils {
  /// Получить иконку для типа сообщения
  static IconData getIconForType(TopSnackBarType type) {
    switch (type) {
      case TopSnackBarType.success:
        return Icons.check_circle;
      case TopSnackBarType.error:
        return Icons.error;
      case TopSnackBarType.warning:
        return Icons.warning;
      case TopSnackBarType.info:
        return Icons.info;
    }
  }

  /// Получить приоритет типа сообщения (меньше = выше приоритет)
  static int getTypePriority(TopSnackBarType type) {
    switch (type) {
      case TopSnackBarType.error:
        return 0; // Наивысший приоритет
      case TopSnackBarType.warning:
        return 1;
      case TopSnackBarType.info:
        return 2;
      case TopSnackBarType.success:
        return 3; // Наименьший приоритет
    }
  }
}
