import 'package:flutter/material.dart';

import '../colors/colors_dark.dart';

import 'settings.dart';

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
    backgroundColor: WidgetStatePropertyAll<Color>(ColorsDark.primary),
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
    backgroundColor: WidgetStatePropertyAll<Color>(ColorsDark.primary),
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

final textInputDark = InputDecorationTheme(
  labelStyle: TextStyle(color: ColorsDark.onSurface),
  hintStyle: TextStyle(color: ColorsDark.onSurface.withValues(alpha: 0.5)),
  errorStyle: TextStyle(color: ColorsDark.error),
  border: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey[600]!,
      width: textFieldBorderWidth,
    ),
    borderRadius: BorderRadius.circular(borderRadius),
  ),
  outlineBorder: BorderSide(
    color: Colors.grey[600]!,
    width: textFieldBorderWidth,
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorsDark.primary,
      width: textFieldBorderWidth,
    ),
    borderRadius: BorderRadius.circular(borderRadius),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey[600]!,
      width: textFieldBorderWidth,
    ),
    borderRadius: BorderRadius.circular(borderRadius),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorsDark.error,
      width: textFieldBorderWidth,
    ),
    borderRadius: BorderRadius.circular(borderRadius),
  ),
);

final chipTheme = ChipThemeData(
  backgroundColor: ColorsDark.primary,
  secondarySelectedColor: ColorsDark.onPrimary,
  selectedColor: ColorsDark.onPrimary,
  disabledColor: ColorsDark.onSurface.withValues(alpha: 0.5),
  labelStyle: TextStyle(color: ColorsDark.onPrimary),
  secondaryLabelStyle: TextStyle(color: ColorsDark.onPrimary),
  padding: EdgeInsets.all(8),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  ),
);

// list of all widgets

final List<Object> darkThemeComponents = [
  filledButtonTheme,
  textButtonTheme,
  elevatedButtonTheme,
  outlinedButtonTheme,
  iconButtonTheme,
  textInputDark,
  chipTheme,
  
];
