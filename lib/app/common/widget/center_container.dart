
import 'package:codexa_pass/app/config/constants.dart';
import 'package:flutter/material.dart';

class CenterContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const CenterContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.maxWidth = AppConstants.mobileWidth, // можно адаптировать под desktop
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
