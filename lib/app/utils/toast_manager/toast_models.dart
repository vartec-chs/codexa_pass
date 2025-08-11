import 'package:flutter/material.dart';

/// Типы тостов
enum ToastType { success, error, warning, info }

/// Позиция тоста на экране
enum ToastPosition { top, bottom }

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
  final Color borderColor;
  final Color shadowColor;

  const ToastColors({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.progressColor,
    required this.borderColor,
    required this.shadowColor,
  });

  static ToastColors forType(ToastType type, bool isDark) {
    switch (type) {
      case ToastType.success:
        return ToastColors(
          backgroundColor: isDark
              ? const Color(0xFF1B5E20)
              : const Color(0xFFE8F5E8),
          textColor: isDark ? Colors.white : const Color(0xFF2E7D32),
          iconColor: isDark ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32),
          progressColor: isDark
              ? const Color(0xFF4CAF50)
              : const Color(0xFF2E7D32),
          borderColor: isDark
              ? const Color(0xFF4CAF50)
              : const Color(0xFFC8E6C9),
          shadowColor: isDark ? Colors.black54 : Colors.green.withOpacity(0.2),
        );
      case ToastType.error:
        return ToastColors(
          backgroundColor: isDark
              ? const Color(0xFF8B0000)
              : const Color(0xFFFFEBEE),
          textColor: isDark ? Colors.white : const Color(0xFFD32F2F),
          iconColor: isDark ? const Color(0xFFFF5252) : const Color(0xFFD32F2F),
          progressColor: isDark
              ? const Color(0xFFFF5252)
              : const Color(0xFFD32F2F),
          borderColor: isDark
              ? const Color(0xFFFF5252)
              : const Color(0xFFFFCDD2),
          shadowColor: isDark ? Colors.black54 : Colors.red.withOpacity(0.2),
        );
      case ToastType.warning:
        return ToastColors(
          backgroundColor: isDark
              ? const Color(0xFF664A00)
              : const Color(0xFFFFF8E1),
          textColor: isDark ? Colors.white : const Color(0xFFEF6C00),
          iconColor: isDark ? const Color(0xFFFFB74D) : const Color(0xFFEF6C00),
          progressColor: isDark
              ? const Color(0xFFFFB74D)
              : const Color(0xFFEF6C00),
          borderColor: isDark
              ? const Color(0xFFFFB74D)
              : const Color(0xFFFFE0B2),
          shadowColor: isDark ? Colors.black54 : Colors.orange.withOpacity(0.2),
        );
      case ToastType.info:
        return ToastColors(
          backgroundColor: isDark
              ? const Color(0xFF0D47A1)
              : const Color(0xFFE3F2FD),
          textColor: isDark ? Colors.white : const Color(0xFF1976D2),
          iconColor: isDark ? const Color(0xFF42A5F5) : const Color(0xFF1976D2),
          progressColor: isDark
              ? const Color(0xFF42A5F5)
              : const Color(0xFF1976D2),
          borderColor: isDark
              ? const Color(0xFF42A5F5)
              : const Color(0xFFBBDEFB),
          shadowColor: isDark ? Colors.black54 : Colors.blue.withOpacity(0.2),
        );
    }
  }
}

/// Иконки для типов тостов
class ToastIcons {
  static IconData getIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
    }
  }
}
