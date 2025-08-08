import 'package:flutter/material.dart';

/// Утилиты для работы с темами
class ThemeUtils {
  /// Проверяет, является ли текущая тема темной
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Возвращает цвет в зависимости от темы
  static Color getColorForTheme(
    BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) {
    return isDarkMode(context) ? darkColor : lightColor;
  }

  /// Возвращает адаптивный цвет поверхности
  static Color getSurfaceColor(BuildContext context, {double elevation = 0}) {
    final theme = Theme.of(context);
    if (isDarkMode(context)) {
      return ElevationOverlay.applySurfaceTint(
        theme.colorScheme.surface,
        theme.colorScheme.surfaceTint,
        elevation,
      );
    }
    return theme.colorScheme.surface;
  }

  /// Возвращает адаптивный цвет границы
  static Color getBorderColor(BuildContext context, {double opacity = 0.2}) {
    final theme = Theme.of(context);
    return theme.colorScheme.outline.withOpacity(opacity);
  }

  /// Возвращает адаптивную тень
  static List<BoxShadow> getAdaptiveShadow(
    BuildContext context, {
    double elevation = 2,
  }) {
    if (isDarkMode(context)) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: elevation * 2,
          offset: Offset(0, elevation),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: elevation * 2,
        offset: Offset(0, elevation),
      ),
    ];
  }

  /// Возвращает градиент для карточек
  static LinearGradient getCardGradient(BuildContext context) {
    final theme = Theme.of(context);
    if (isDarkMode(context)) {
      return LinearGradient(
        colors: [
          theme.colorScheme.surface,
          theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return LinearGradient(
      colors: [
        theme.colorScheme.primaryContainer.withOpacity(0.1),
        theme.colorScheme.secondaryContainer.withOpacity(0.05),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Возвращает стиль для заголовков
  static TextStyle getHeadingStyle(
    BuildContext context, {
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: theme.colorScheme.onSurface,
      letterSpacing: -0.5,
    );
  }

  /// Возвращает стиль для подзаголовков
  static TextStyle getSubtitleStyle(
    BuildContext context, {
    double fontSize = 14,
    double opacity = 0.7,
  }) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: fontSize,
      color: theme.colorScheme.onSurface.withOpacity(opacity),
      height: 1.4,
    );
  }

  /// Возвращает стиль для лейблов
  static TextStyle getLabelStyle(
    BuildContext context, {
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: theme.colorScheme.onSurface,
    );
  }
}

/// Виджет для адаптивной карточки
class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double elevation;
  final bool useGradient;
  final VoidCallback? onTap;

  const AdaptiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation = 2,
    this.useGradient = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: useGradient
            ? null
            : ThemeUtils.getSurfaceColor(context, elevation: elevation),
        gradient: useGradient ? ThemeUtils.getCardGradient(context) : null,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ThemeUtils.getBorderColor(context), width: 1),
        boxShadow: ThemeUtils.getAdaptiveShadow(context, elevation: elevation),
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
