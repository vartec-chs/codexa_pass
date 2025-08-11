import 'package:flutter/material.dart';

/// Конфигурация анимаций для SnackBar
class SnackBarAnimationConfig {
  /// Включены ли анимации
  final bool enabled;

  /// Продолжительность анимации входа
  final Duration entryDuration;

  /// Продолжительность анимации выхода
  final Duration exitDuration;

  /// Кривая анимации входа
  final Curve entryCurve;

  /// Кривая анимации выхода
  final Curve exitCurve;

  /// Анимация масштабирования
  final bool scaleAnimation;

  /// Анимация скольжения
  final bool slideAnimation;

  /// Анимация прозрачности
  final bool fadeAnimation;

  /// Анимация bounce эффекта
  final bool bounceAnimation;

  /// Направление скольжения
  final SlideDirection slideDirection;

  /// Начальный масштаб для анимации
  final double initialScale;

  /// Конечный масштаб для анимации
  final double finalScale;

  const SnackBarAnimationConfig({
    this.enabled = true,
    this.entryDuration = const Duration(milliseconds: 350),
    this.exitDuration = const Duration(milliseconds: 250),
    this.entryCurve = Curves.easeOutBack,
    this.exitCurve = Curves.easeInBack,
    this.scaleAnimation = true,
    this.slideAnimation = true,
    this.fadeAnimation = true,
    this.bounceAnimation = false,
    this.slideDirection = SlideDirection.bottom,
    this.initialScale = 0.8,
    this.finalScale = 1.0,
  });

  /// Предустановленная конфигурация для отключения анимаций
  static const SnackBarAnimationConfig disabled = SnackBarAnimationConfig(
    enabled: false,
    entryDuration: Duration.zero,
    exitDuration: Duration.zero,
  );

  /// Предустановленная конфигурация для быстрых анимаций
  static const SnackBarAnimationConfig fast = SnackBarAnimationConfig(
    entryDuration: Duration(milliseconds: 200),
    exitDuration: Duration(milliseconds: 150),
    entryCurve: Curves.easeOut,
    exitCurve: Curves.easeIn,
  );

  /// Предустановленная конфигурация для медленных анимаций
  static const SnackBarAnimationConfig slow = SnackBarAnimationConfig(
    entryDuration: Duration(milliseconds: 500),
    exitDuration: Duration(milliseconds: 400),
    entryCurve: Curves.elasticOut,
    exitCurve: Curves.easeInBack,
  );

  /// Предустановленная конфигурация с bounce эффектом
  static const SnackBarAnimationConfig bouncy = SnackBarAnimationConfig(
    entryDuration: Duration(milliseconds: 600),
    exitDuration: Duration(milliseconds: 300),
    entryCurve: Curves.bounceOut,
    exitCurve: Curves.easeInBack,
    bounceAnimation: true,
  );

  SnackBarAnimationConfig copyWith({
    bool? enabled,
    Duration? entryDuration,
    Duration? exitDuration,
    Curve? entryCurve,
    Curve? exitCurve,
    bool? scaleAnimation,
    bool? slideAnimation,
    bool? fadeAnimation,
    bool? bounceAnimation,
    SlideDirection? slideDirection,
    double? initialScale,
    double? finalScale,
  }) {
    return SnackBarAnimationConfig(
      enabled: enabled ?? this.enabled,
      entryDuration: entryDuration ?? this.entryDuration,
      exitDuration: exitDuration ?? this.exitDuration,
      entryCurve: entryCurve ?? this.entryCurve,
      exitCurve: exitCurve ?? this.exitCurve,
      scaleAnimation: scaleAnimation ?? this.scaleAnimation,
      slideAnimation: slideAnimation ?? this.slideAnimation,
      fadeAnimation: fadeAnimation ?? this.fadeAnimation,
      bounceAnimation: bounceAnimation ?? this.bounceAnimation,
      slideDirection: slideDirection ?? this.slideDirection,
      initialScale: initialScale ?? this.initialScale,
      finalScale: finalScale ?? this.finalScale,
    );
  }
}

/// Направления скольжения для анимации
enum SlideDirection { top, bottom, left, right }
