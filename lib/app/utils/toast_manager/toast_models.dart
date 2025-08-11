import 'package:flutter/material.dart';

/// Типы тостов
enum ToastType { success, error, warning, info }

/// Позиция тоста на экране
enum ToastPosition {
  top,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  left,
  right,
}

/// Действие для кастомной кнопки
class ToastAction {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? icon;

  const ToastAction({
    required this.label,
    required this.onPressed,
    this.color,
    this.icon,
  });
}

/// Конфигурация тоста
class ToastConfig {
  final String id;
  final String title;
  final String? subtitle;
  final ToastType type;
  final ToastPosition position;
  final Duration duration;
  final Duration animationDuration;
  final bool dismissible;
  final bool showProgressBar;
  final bool showCloseButton;
  final List<ToastAction> actions;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final EdgeInsets margin;
  final double? width;
  final int priority;

  const ToastConfig({
    required this.id,
    required this.title,
    this.subtitle,
    this.type = ToastType.info,
    this.position = ToastPosition.top,
    this.duration = const Duration(seconds: 4),
    this.animationDuration = const Duration(milliseconds: 300),
    this.dismissible = true,
    this.showProgressBar = true,
    this.showCloseButton = true,
    this.actions = const [],
    this.onTap,
    this.onDismiss,
    this.margin = const EdgeInsets.all(16),
    this.width,
    this.priority = 0,
  });

  ToastConfig copyWith({
    String? id,
    String? title,
    String? subtitle,
    ToastType? type,
    ToastPosition? position,
    Duration? duration,
    Duration? animationDuration,
    bool? dismissible,
    bool? showProgressBar,
    bool? showCloseButton,
    List<ToastAction>? actions,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
    EdgeInsets? margin,
    double? width,
    int? priority,
  }) {
    return ToastConfig(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      animationDuration: animationDuration ?? this.animationDuration,
      dismissible: dismissible ?? this.dismissible,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      actions: actions ?? this.actions,
      onTap: onTap ?? this.onTap,
      onDismiss: onDismiss ?? this.onDismiss,
      margin: margin ?? this.margin,
      width: width ?? this.width,
      priority: priority ?? this.priority,
    );
  }
}

/// Цветовая схема для тостов
class ToastColors {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color progressColor;
  final Color shadowColor;
  final Color accentColor;
  final Gradient? gradient;

  const ToastColors({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.progressColor,
    required this.shadowColor,
    required this.accentColor,
    this.gradient,
  });

  static ToastColors forType(ToastType type, bool isDark) {
    switch (type) {
      case ToastType.success:
        return ToastColors(
          backgroundColor: isDark
              ? const Color(0xFF0F2A14)
              : const Color(0xFFF0F9F1),
          textColor: isDark ? const Color(0xFFE8F5E9) : const Color(0xFF1B5E20),
          iconColor: const Color(0xFF4CAF50),
          progressColor: const Color(0xFF66BB6A),
          accentColor: const Color(0xFF4CAF50),
          shadowColor: isDark
              ? Colors.black.withOpacity(0.3)
              : const Color(0xFF4CAF50).withOpacity(0.1),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0F2A14), const Color(0xFF1B4D20)]
                : [const Color(0xFFF0F9F1), const Color(0xFFE8F5E9)],
          ),
        );
      case ToastType.error:
        return ToastColors(
          backgroundColor: isDark
              ? const Color(0xFF2C0E0E)
              : const Color(0xFFFFF5F5),
          textColor: isDark ? const Color(0xFFFFEBEE) : const Color(0xFFC62828),
          iconColor: const Color(0xFFF44336),
          progressColor: const Color(0xFFEF5350),
          accentColor: const Color(0xFFF44336),
          shadowColor: isDark
              ? Colors.black.withOpacity(0.3)
              : const Color(0xFFF44336).withOpacity(0.1),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF2C0E0E), const Color(0xFF4D1414)]
                : [const Color(0xFFFFF5F5), const Color(0xFFFFEBEE)],
          ),
        );
      case ToastType.warning:
        return ToastColors(
          backgroundColor: isDark
              ? const Color(0xFF2D1B0E)
              : const Color(0xFFFFFBF0),
          textColor: isDark ? const Color(0xFFFFF3E0) : const Color(0xFFE65100),
          iconColor: const Color(0xFFFF9800),
          progressColor: const Color(0xFFFFB74D),
          accentColor: const Color(0xFFFF9800),
          shadowColor: isDark
              ? Colors.black.withOpacity(0.3)
              : const Color(0xFFFF9800).withOpacity(0.1),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF2D1B0E), const Color(0xFF4D2E14)]
                : [const Color(0xFFFFFBF0), const Color(0xFFFFF3E0)],
          ),
        );
      case ToastType.info:
        return ToastColors(
          backgroundColor: isDark
              ? const Color(0xFF0E1621)
              : const Color(0xFFF3F8FF),
          textColor: isDark ? const Color(0xFFE3F2FD) : const Color(0xFF1565C0),
          iconColor: const Color(0xFF2196F3),
          progressColor: const Color(0xFF42A5F5),
          accentColor: const Color(0xFF2196F3),
          shadowColor: isDark
              ? Colors.black.withOpacity(0.3)
              : const Color(0xFF2196F3).withOpacity(0.1),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0E1621), const Color(0xFF142A4D)]
                : [const Color(0xFFF3F8FF), const Color(0xFFE3F2FD)],
          ),
        );
    }
  }
}

/// Иконки для типов тостов
class ToastIcons {
  static IconData getIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.error:
        return Icons.error_rounded;
      case ToastType.warning:
        return Icons.warning_rounded;
      case ToastType.info:
        return Icons.info_rounded;
    }
  }

  /// Дополнительные анимированные иконки
  static IconData getAnimatedIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Icons.celebration_rounded;
      case ToastType.error:
        return Icons.dangerous_rounded;
      case ToastType.warning:
        return Icons.priority_high_rounded;
      case ToastType.info:
        return Icons.lightbulb_rounded;
    }
  }
}
