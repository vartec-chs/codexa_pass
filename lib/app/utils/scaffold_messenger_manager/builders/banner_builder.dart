import 'package:flutter/material.dart';
import '../models/banner_data.dart';
import '../themes/banner_theme_provider.dart';
import '../scaffold_messenger_manager.dart';

abstract class BannerBuilder {
  MaterialBanner build(BuildContext context, BannerData data);
}

class DefaultBannerBuilder implements BannerBuilder {
  final BannerThemeProvider themeProvider;

  const DefaultBannerBuilder({required this.themeProvider});

  @override
  MaterialBanner build(BuildContext context, BannerData data) {
    final backgroundColor =
        data.backgroundColor ??
        themeProvider.getBackgroundColor(context, data.type);
    final textColor = themeProvider.getTextColor(context, data.type);
    final leading =
        data.leading ?? themeProvider.getLeading(context, data.type);

    return MaterialBanner(
      content: Text(
        data.message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: leading,
      actions: data.actions ?? _buildDefaultActions(context),
      backgroundColor: backgroundColor,
      forceActionsBelow: data.forceActionsBelow,
      margin: data.margin,
      padding: data.padding,
      surfaceTintColor: data.surfaceTintColor,
      shadowColor: data.shadowColor,
      dividerColor: data.dividerColor,
      elevation: data.elevation,
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () {
          ScaffoldMessengerManager.instance.hideCurrentBanner();
        },
        child: const Text('Закрыть'),
      ),
    ];
  }
}
