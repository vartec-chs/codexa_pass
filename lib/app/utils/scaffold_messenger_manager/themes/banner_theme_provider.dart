import 'package:flutter/material.dart';
import '../models/banner_data.dart';

abstract class BannerThemeProvider {
  Color getBackgroundColor(BuildContext context, BannerType type);
  Color getTextColor(BuildContext context, BannerType type);
  Color getIconColor(BuildContext context, BannerType type);
  IconData getIcon(BannerType type);
  Widget? getLeading(BuildContext context, BannerType type);
}
