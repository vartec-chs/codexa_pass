import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/snack_bar_data.dart';
import '../themes/snack_bar_theme_provider.dart';
import '../scaffold_messenger_manager.dart';

abstract class SnackBarBuilder {
  SnackBar build(BuildContext context, SnackBarData data);
}

class DefaultSnackBarBuilder implements SnackBarBuilder {
  final SnackBarThemeProvider themeProvider;

  const DefaultSnackBarBuilder({required this.themeProvider});

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

    return SnackBar(
      content: _buildContent(context, data, icon, textColor, iconColor),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      elevation: 8,
      action: _buildAction(context, data, textColor),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SnackBarData data,
    IconData icon,
    Color textColor,
    Color iconColor,
  ) {
    final actions = _buildActions(context, data, textColor);

    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            data.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (actions.isNotEmpty) ...[const SizedBox(width: 8), ...actions],
      ],
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    SnackBarData data,
    Color textColor,
  ) {
    final actions = <Widget>[];

    if (data.showCopyButton) {
      actions.add(
        IconButton(
          onPressed: data.onCopyPressed ?? () => _copyToClipboard(data.message),
          icon: Icon(Icons.copy, color: textColor, size: 20),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: EdgeInsets.zero,
        ),
      );
    }

    if (data.showCloseButton) {
      actions.add(
        IconButton(
          onPressed: () {
            ScaffoldMessengerManager.instance.hideCurrentSnackBar();
          },
          icon: Icon(Icons.close, color: textColor, size: 20),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: EdgeInsets.zero,
        ),
      );
    }

    return actions;
  }

  SnackBarAction? _buildAction(
    BuildContext context,
    SnackBarData data,
    Color textColor,
  ) {
    if (data.actionLabel != null && data.onActionPressed != null) {
      return SnackBarAction(
        label: data.actionLabel!,
        textColor: textColor,
        onPressed: data.onActionPressed!,
      );
    }
    return null;
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
