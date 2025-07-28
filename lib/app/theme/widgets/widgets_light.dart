import 'package:flutter/material.dart';
import 'settings.dart';
import '../colors/colors_light.dart';

final filledButtonTheme = FilledButtonThemeData(
  style: ButtonStyle(
    textStyle: WidgetStatePropertyAll(
      TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      ),
    ),
    padding: WidgetStatePropertyAll(PaddingWidgets.paddingButton),
    foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
    backgroundColor: WidgetStatePropertyAll<Color>(ColorsLight.primary),
    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
    ),
  ),
);

final textButtonTheme = TextButtonThemeData(
  style: ButtonStyle(
    textStyle: WidgetStatePropertyAll(
      TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      ),
    ),
    padding: WidgetStatePropertyAll(PaddingWidgets.paddingButton),
    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
    ),
  ),
);

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    textStyle: WidgetStatePropertyAll(
      TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      ),
    ),
    padding: WidgetStatePropertyAll(PaddingWidgets.paddingButton),
    foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
    backgroundColor: WidgetStatePropertyAll<Color>(ColorsLight.primary),
    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
    ),
  ),
);

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: ButtonStyle(
    textStyle: WidgetStatePropertyAll(
      TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      ),
    ),
    padding: WidgetStatePropertyAll(PaddingWidgets.paddingButton),
    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
    ),
  ),
);

final iconButtonTheme = IconButtonThemeData(
  style: ButtonStyle(
    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
    ),
  ),
);

final textInputLight = InputDecorationTheme(
  labelStyle: TextStyle(color: ColorsLight.onSurface),
  hintStyle: TextStyle(color: ColorsLight.onSurface.withValues(alpha: 0.5)),
  errorStyle: TextStyle(color: ColorsLight.error),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: ColorsLight.onSurface),
    borderRadius: BorderRadius.circular(borderRadius),
  ),
  outlineBorder: BorderSide(
    color: ColorsLight.onSurface,
    width: textFieldBorderWidth,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorsLight.primary,
      width: textFieldBorderWidth,
    ),
    borderRadius: BorderRadius.circular(borderRadius),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorsLight.onSurface,
      width: textFieldBorderWidth,
    ),
    borderRadius: BorderRadius.circular(borderRadius),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorsLight.error,
      width: textFieldBorderWidth,
    ),
    borderRadius: BorderRadius.circular(borderRadius),
  ),
);

final chipTheme = ChipThemeData(
  backgroundColor: ColorsLight.primary,
  selectedColor: ColorsLight.primaryContainer,
  secondarySelectedColor: ColorsLight.secondaryContainer,
  labelStyle: TextStyle(color: ColorsLight.onPrimary),
  secondaryLabelStyle: TextStyle(color: ColorsLight.onSecondary),
  padding: EdgeInsets.all(8),
);

final List<Object> lightThemeComponents = [
  filledButtonTheme,
  textButtonTheme,
  elevatedButtonTheme,
  outlinedButtonTheme,
  iconButtonTheme,
  textInputLight,
  chipTheme,
];
