import 'package:flutter/material.dart';
import '../models/banner_data.dart';
import '../themes/banner_theme_provider.dart';
import '../themes/default_banner_theme_provider.dart';
import '../scaffold_messenger_manager.dart';

abstract class BannerBuilder {
  MaterialBanner build(BuildContext context, BannerData data);
}

class ModernBannerBuilder implements BannerBuilder {
  final BannerThemeProvider themeProvider;

  const ModernBannerBuilder({required this.themeProvider});

  @override
  MaterialBanner build(BuildContext context, BannerData data) {
    final backgroundColor =
        data.backgroundColor ??
        themeProvider.getBackgroundColor(context, data.type);
    final textColor = themeProvider.getTextColor(context, data.type);
    final leading =
        data.leading ?? themeProvider.getLeading(context, data.type);

    // Получаем дополнительные стили, если провайдер поддерживает их
    Color? shadowColor;
    Color? dividerColor;
    Color? surfaceTintColor;

    if (themeProvider is DefaultBannerThemeProvider) {
      final provider = themeProvider as DefaultBannerThemeProvider;
      shadowColor =
          data.shadowColor ?? provider.getShadowColor(context, data.type);
      dividerColor =
          data.dividerColor ?? provider.getDividerColor(context, data.type);
      surfaceTintColor =
          data.surfaceTintColor ??
          provider.getSurfaceTintColor(context, data.type);
    }

    return MaterialBanner(
      content: _buildModernContent(context, data, textColor),
      leading: leading,
      actions: data.actions ?? _buildModernActions(context, data, textColor),
      backgroundColor: backgroundColor,
      forceActionsBelow: data.forceActionsBelow,
      // margin:
      //     data.margin ??
      //     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding:
          data.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      dividerColor: dividerColor,
      elevation: data.elevation ?? 4,
    );
  }

  Widget _buildModernContent(
    BuildContext context,
    BannerData data,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _getTypeTitle(data.type),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: textColor.withOpacity(0.8),
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          data.message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  String _getTypeTitle(BannerType type) {
    switch (type) {
      case BannerType.error:
        return 'ОШИБКА';
      case BannerType.warning:
        return 'ПРЕДУПРЕЖДЕНИЕ';
      case BannerType.info:
        return 'ИНФОРМАЦИЯ';
      case BannerType.success:
        return 'УСПЕХ';
    }
  }

  List<Widget> _buildModernActions(
    BuildContext context,
    BannerData data,
    Color textColor,
  ) {
    return [
      _buildModernActionButton(
        context: context,
        label: 'Закрыть',
        icon: Icons.close_rounded,
        textColor: textColor,
        onPressed: () {
          ScaffoldMessengerManager.instance.hideCurrentBanner();
        },
      ),
    ];
  }

  Widget _buildModernActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color textColor,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: isPrimary
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: FilledButton.styleFrom(
                backgroundColor: textColor.withOpacity(0.15),
                foregroundColor: textColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                side: BorderSide(color: textColor.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}

// Сохраняем старый билдер для обратной совместимости
class DefaultBannerBuilder extends ModernBannerBuilder {
  const DefaultBannerBuilder({required super.themeProvider});
}
