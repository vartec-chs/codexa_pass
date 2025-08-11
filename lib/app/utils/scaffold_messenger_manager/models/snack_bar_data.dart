import 'package:flutter/material.dart';
import 'snack_bar_type.dart';
import 'snack_bar_animation_config.dart';

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
  final SnackBarAnimationConfig? animationConfig;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool enableBlur;
  final double blurRadius;

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
    this.animationConfig,
    this.elevation,
    this.margin,
    this.borderRadius,
    this.enableBlur = false,
    this.blurRadius = 10.0,
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
    SnackBarAnimationConfig? animationConfig,
    double? elevation,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    bool? enableBlur,
    double? blurRadius,
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
      animationConfig: animationConfig ?? this.animationConfig,
      elevation: elevation ?? this.elevation,
      margin: margin ?? this.margin,
      borderRadius: borderRadius ?? this.borderRadius,
      enableBlur: enableBlur ?? this.enableBlur,
      blurRadius: blurRadius ?? this.blurRadius,
    );
  }
}
