import 'package:flutter/material.dart';

/// Enum для типов уведомлений
enum NotificationType { success, error, warning, info }

/// Enum для позиции уведомлений
enum NotificationPosition { top, bottom }

/// Модель для конфигурации уведомлений
class NotificationConfig {
  final String message;
  final NotificationType type;
  final NotificationPosition position;
  final Duration duration;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;
  final bool showCloseButton;
  final bool showProgress;
  final double? progress;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double borderRadius;
  final String? subtitle;
  final bool isDismissible;
  final Widget? customIcon;
  final DateTime timestamp;

  NotificationConfig({
    required this.message,
    this.type = NotificationType.info,
    this.position = NotificationPosition.bottom,
    this.duration = const Duration(seconds: 3),
    this.onTap,
    this.onDismiss,
    this.onAction,
    this.actionLabel,
    this.showCloseButton = true,
    this.showProgress = false,
    this.progress,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.subtitle,
    this.isDismissible = true,
    this.customIcon,
  }) : timestamp = DateTime.now();

  /// Создать конфигурацию для информационного сообщения
  factory NotificationConfig.info(
    String message, {
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    String? subtitle,
    Widget? customIcon,
  }) {
    return NotificationConfig(
      message: message,
      type: NotificationType.info,
      position: position,
      duration: duration ?? const Duration(seconds: 3),
      onTap: onTap,
      onDismiss: onDismiss,
      subtitle: subtitle,
      customIcon: customIcon,
    );
  }

  /// Создать конфигурацию для сообщения об успехе
  factory NotificationConfig.success(
    String message, {
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    String? subtitle,
    Widget? customIcon,
  }) {
    return NotificationConfig(
      message: message,
      type: NotificationType.success,
      position: position,
      duration: duration ?? const Duration(seconds: 3),
      onTap: onTap,
      onDismiss: onDismiss,
      subtitle: subtitle,
      customIcon: customIcon,
    );
  }

  /// Создать конфигурацию для предупреждения
  factory NotificationConfig.warning(
    String message, {
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
    String? subtitle,
    Widget? customIcon,
  }) {
    return NotificationConfig(
      message: message,
      type: NotificationType.warning,
      position: position,
      duration: duration ?? const Duration(seconds: 4),
      onTap: onTap,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
      subtitle: subtitle,
      customIcon: customIcon,
    );
  }

  /// Создать конфигурацию для сообщения об ошибке
  factory NotificationConfig.error(
    String message, {
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
    String? actionLabel,
    String? subtitle,
    Widget? customIcon,
  }) {
    return NotificationConfig(
      message: message,
      type: NotificationType.error,
      position: position,
      duration: duration ?? const Duration(seconds: 5),
      onTap: onTap,
      onDismiss: onDismiss,
      onAction: onAction,
      actionLabel: actionLabel,
      subtitle: subtitle,
      customIcon: customIcon,
    );
  }

  /// Создать конфигурацию с прогрессом
  factory NotificationConfig.withProgress(
    String message, {
    NotificationType type = NotificationType.info,
    NotificationPosition position = NotificationPosition.bottom,
    Duration? duration,
    double? progress,
    String? subtitle,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
  }) {
    return NotificationConfig(
      message: message,
      type: type,
      position: position,
      duration: duration ?? const Duration(seconds: 5),
      showProgress: true,
      progress: progress,
      subtitle: subtitle,
      onTap: onTap,
      onDismiss: onDismiss,
    );
  }
}

/// Цвета для уведомлений
class NotificationColors {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color borderColor;
  final Color shadowColor;
  final Color actionColor;

  const NotificationColors({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.borderColor,
    required this.shadowColor,
    required this.actionColor,
  });

  /// Получить цвета для типа сообщения
  static NotificationColors forType(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return const NotificationColors(
          backgroundColor: Color(0xFF4CAF50),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: Color(0xFF388E3C),
          shadowColor: Color(0xFF4CAF50),
          actionColor: Colors.white,
        );
      case NotificationType.error:
        return const NotificationColors(
          backgroundColor: Color(0xFFF44336),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: Color(0xFFD32F2F),
          shadowColor: Color(0xFFF44336),
          actionColor: Colors.white,
        );
      case NotificationType.warning:
        return const NotificationColors(
          backgroundColor: Color(0xFFFF9800),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: Color(0xFFF57C00),
          shadowColor: Color(0xFFFF9800),
          actionColor: Colors.white,
        );
      case NotificationType.info:
        return const NotificationColors(
          backgroundColor: Color(0xFF2196F3),
          textColor: Colors.white,
          iconColor: Colors.white,
          borderColor: Color(0xFF1976D2),
          shadowColor: Color(0xFF2196F3),
          actionColor: Colors.white,
        );
    }
  }
}

/// Тема для уведомлений
class NotificationTheme {
  final LinearGradient gradient;
  final List<BoxShadow> shadows;

  const NotificationTheme({required this.gradient, required this.shadows});

  /// Получить тему для типа сообщения
  static NotificationTheme forType(NotificationType type) {
    final colors = NotificationColors.forType(type);

    return NotificationTheme(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          colors.backgroundColor,
          colors.backgroundColor.withOpacity(0.9),
        ],
        stops: const [0.0, 1.0],
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

/// Утилиты для уведомлений
class NotificationUtils {
  /// Получить иконку для типа сообщения
  static IconData getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.info:
        return Icons.info_outline;
    }
  }

  /// Получить приоритет типа сообщения (меньше = выше приоритет)
  static int getTypePriority(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return 0; // Наивысший приоритет
      case NotificationType.warning:
        return 1;
      case NotificationType.info:
        return 2;
      case NotificationType.success:
        return 3; // Наименьший приоритет
    }
  }

  /// Получить стандартную длительность для типа сообщения
  static Duration getDefaultDuration(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return const Duration(seconds: 6);
      case NotificationType.warning:
        return const Duration(seconds: 5);
      case NotificationType.info:
        return const Duration(seconds: 4);
      case NotificationType.success:
        return const Duration(seconds: 3);
    }
  }
}
