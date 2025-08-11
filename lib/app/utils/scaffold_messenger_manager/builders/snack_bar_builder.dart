import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/snack_bar_data.dart';
import '../models/snack_bar_type.dart';
import '../models/snack_bar_animation_config.dart';
import '../themes/snack_bar_theme_provider.dart';
import '../themes/default_snack_bar_theme_provider.dart';
import '../scaffold_messenger_manager.dart';
import '../widgets/animated_snack_bar.dart';

abstract class SnackBarBuilder {
  SnackBar build(BuildContext context, SnackBarData data);
}

class ModernSnackBarBuilder implements SnackBarBuilder {
  final SnackBarThemeProvider themeProvider;
  final SnackBarAnimationConfig defaultAnimationConfig;

  const ModernSnackBarBuilder({
    required this.themeProvider,
    this.defaultAnimationConfig = const SnackBarAnimationConfig(),
  });

  @override
  SnackBar build(BuildContext context, SnackBarData data) {
    final backgroundColor = themeProvider.getBackgroundColor(
      context,
      data.type,
    );
    final textColor = themeProvider.getTextColor(context, data.type);
    final iconColor = themeProvider.getIconColor(context, data.type);
    final icon = themeProvider.getIcon(data.type);
    final duration =
        data.duration ?? themeProvider.getDefaultDuration(data.type);
    final animationConfig = data.animationConfig ?? defaultAnimationConfig;

    // Получаем дополнительные стили, если провайдер поддерживает их
    Color? borderColor;
    Color? shadowColor;
    LinearGradient? gradient;

    if (themeProvider is DefaultSnackBarThemeProvider) {
      final provider = themeProvider as DefaultSnackBarThemeProvider;
      borderColor = provider.getBorderColor(context, data.type);
      shadowColor = provider.getShadowColor(context, data.type);
      gradient = provider.getGradient(context, data.type);
    }

    final content = _buildModernContent(
      context,
      data,
      icon,
      textColor,
      iconColor,
    );

    return SnackBar(
      content: AnimatedCustomSnackBar(
        content: content,
        backgroundColor: backgroundColor,
        elevation: data.elevation ?? 12.0,
        margin: data.margin ?? const EdgeInsets.all(16),
        borderRadius:
            data.borderRadius ?? const BorderRadius.all(Radius.circular(16)),
        animationConfig: animationConfig,
        enableBlur: data.enableBlur,
        blurRadius: data.blurRadius,
        shadowColor: shadowColor,
        gradient: gradient,
        borderColor: borderColor,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      action: null,
    );
  }

  Widget _buildModernContent(
    BuildContext context,
    SnackBarData data,
    IconData icon,
    Color textColor,
    Color iconColor,
  ) {
    final actions = _buildActions(context, data, textColor);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Анимированная иконка
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 600),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Transform.rotate(
                  angle: value * 0.1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),

          // Контент с анимацией появления
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(20 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getTypeTitle(data.type),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: textColor.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.message,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (actions.isNotEmpty) ...[
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions
                  .map(
                    (action) => Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: action,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _getTypeTitle(SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return 'ОШИБКА';
      case SnackBarType.warning:
        return 'ПРЕДУПРЕЖДЕНИЕ';
      case SnackBarType.info:
        return 'ИНФОРМАЦИЯ';
      case SnackBarType.success:
        return 'УСПЕХ';
    }
  }

  List<Widget> _buildActions(
    BuildContext context,
    SnackBarData data,
    Color textColor,
  ) {
    final actions = <Widget>[];

    // Добавляем кастомное действие если есть
    if (data.actionLabel != null && data.onActionPressed != null) {
      actions.add(
        _buildModernActionButton(
          onPressed: data.onActionPressed!,
          icon: Icons.touch_app_rounded,
          color: textColor,
          tooltip: data.actionLabel!,
          label: data.actionLabel!,
        ),
      );
    }

    if (data.showCopyButton) {
      actions.add(
        _buildModernActionButton(
          onPressed: data.onCopyPressed ?? () => _copyToClipboard(data.message),
          icon: Icons.copy_rounded,
          color: textColor,
          tooltip: 'Копировать',
        ),
      );
    }

    if (data.showCloseButton) {
      actions.add(
        _buildModernActionButton(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentSnackBar();
          },
          icon: Icons.close_rounded,
          color: textColor,
          tooltip: 'Закрыть',
        ),
      );
    }

    return actions;
  }

  Widget _buildModernActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required String tooltip,
    String? label,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 18),
                if (label != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}

// Сохраняем старый билдер для обратной совместимости
class DefaultSnackBarBuilder extends ModernSnackBarBuilder {
  const DefaultSnackBarBuilder({
    required super.themeProvider,
    super.defaultAnimationConfig,
  });
}
