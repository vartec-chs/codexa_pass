import 'package:flutter/material.dart';

/// Конфигурация анимаций для MaterialBanner
class BannerAnimationConfig {
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

  /// Анимация скольжения
  final bool slideAnimation;

  /// Анимация прозрачности
  final bool fadeAnimation;

  /// Направление скольжения
  final BannerSlideDirection slideDirection;

  const BannerAnimationConfig({
    this.enabled = true,
    this.entryDuration = const Duration(milliseconds: 300),
    this.exitDuration = const Duration(milliseconds: 200),
    this.entryCurve = Curves.easeOut,
    this.exitCurve = Curves.easeIn,
    this.slideAnimation = true,
    this.fadeAnimation = true,
    this.slideDirection = BannerSlideDirection.top,
  });

  /// Предустановленная конфигурация для отключения анимаций
  static const BannerAnimationConfig disabled = BannerAnimationConfig(
    enabled: false,
    entryDuration: Duration.zero,
    exitDuration: Duration.zero,
  );

  /// Предустановленная конфигурация для быстрых анимаций
  static const BannerAnimationConfig fast = BannerAnimationConfig(
    entryDuration: Duration(milliseconds: 150),
    exitDuration: Duration(milliseconds: 100),
    entryCurve: Curves.easeOut,
    exitCurve: Curves.easeIn,
  );

  /// Предустановленная конфигурация для медленных анимаций
  static const BannerAnimationConfig slow = BannerAnimationConfig(
    entryDuration: Duration(milliseconds: 500),
    exitDuration: Duration(milliseconds: 400),
    entryCurve: Curves.easeOutBack,
    exitCurve: Curves.easeInBack,
  );

  BannerAnimationConfig copyWith({
    bool? enabled,
    Duration? entryDuration,
    Duration? exitDuration,
    Curve? entryCurve,
    Curve? exitCurve,
    bool? slideAnimation,
    bool? fadeAnimation,
    BannerSlideDirection? slideDirection,
  }) {
    return BannerAnimationConfig(
      enabled: enabled ?? this.enabled,
      entryDuration: entryDuration ?? this.entryDuration,
      exitDuration: exitDuration ?? this.exitDuration,
      entryCurve: entryCurve ?? this.entryCurve,
      exitCurve: exitCurve ?? this.exitCurve,
      slideAnimation: slideAnimation ?? this.slideAnimation,
      fadeAnimation: fadeAnimation ?? this.fadeAnimation,
      slideDirection: slideDirection ?? this.slideDirection,
    );
  }
}

/// Направления скольжения для анимации баннера
enum BannerSlideDirection { top, bottom, left, right }
