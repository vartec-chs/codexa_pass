import 'package:flutter/material.dart';
import '../models/snack_bar_type.dart';

abstract class SnackBarThemeProvider {
  Color getBackgroundColor(BuildContext context, SnackBarType type);
  Color getTextColor(BuildContext context, SnackBarType type);
  Color getIconColor(BuildContext context, SnackBarType type);
  IconData getIcon(SnackBarType type);
  Duration getDefaultDuration(SnackBarType type);
}
