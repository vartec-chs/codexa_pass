import 'package:flutter/material.dart';
import 'snack_bar_type.dart';

class SnackBarData {
  final String message;
  final SnackBarType type;
  final Duration? duration;
  final List<Widget>? actions;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool showCloseButton;
  final bool showCopyButton;
  final VoidCallback? onCopyPressed;

  const SnackBarData({
    required this.message,
    required this.type,
    this.duration,
    this.actions,
    this.actionLabel,
    this.onActionPressed,
    this.showCloseButton = true,
    this.showCopyButton = false,
    this.onCopyPressed,
  });

  SnackBarData copyWith({
    String? message,
    SnackBarType? type,
    Duration? duration,
    List<Widget>? actions,
    String? actionLabel,
    VoidCallback? onActionPressed,
    bool? showCloseButton,
    bool? showCopyButton,
    VoidCallback? onCopyPressed,
  }) {
    return SnackBarData(
      message: message ?? this.message,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      actions: actions ?? this.actions,
      actionLabel: actionLabel ?? this.actionLabel,
      onActionPressed: onActionPressed ?? this.onActionPressed,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      showCopyButton: showCopyButton ?? this.showCopyButton,
      onCopyPressed: onCopyPressed ?? this.onCopyPressed,
    );
  }
}
