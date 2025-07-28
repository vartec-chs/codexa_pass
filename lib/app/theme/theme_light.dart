import 'package:codexa_pass/app/theme/colors/colors_light.dart';
import 'package:flutter/material.dart';
import 'color_schemas/schema_light.dart';

import 'package:google_fonts/google_fonts.dart';

import 'widgets/widgets_light.dart';

final ThemeData appLightTheme = ThemeData(
  colorScheme: lightColorScheme,
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: ColorsLight.background,
  appBarTheme: AppBarTheme(
    backgroundColor: ColorsLight.primary,
    foregroundColor: ColorsLight.onPrimary,
  ),
  textTheme: GoogleFonts.rubikTextTheme().copyWith(
    bodyLarge: GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    bodyMedium: GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    bodySmall: GoogleFonts.rubik(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurfaceVariant,
    ),
    titleLarge: GoogleFonts.rubik(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    titleMedium: GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    titleSmall: GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    labelLarge: GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    labelMedium: GoogleFonts.rubik(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    labelSmall: GoogleFonts.rubik(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    displayLarge: GoogleFonts.rubik(
      fontSize: 80,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    displayMedium: GoogleFonts.rubik(
      fontSize: 50,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    displaySmall: GoogleFonts.rubik(
      fontSize: 38,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    headlineLarge: GoogleFonts.rubik(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    headlineMedium: GoogleFonts.rubik(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
    headlineSmall: GoogleFonts.rubik(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsLight.onSurface,
    ),
  ),

  filledButtonTheme: filledButtonTheme,
  textButtonTheme: textButtonTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme,
  iconButtonTheme: iconButtonTheme,
  inputDecorationTheme: textInputLight,
  chipTheme: chipTheme,
  fontFamily: 'Rubik',
  iconTheme: IconThemeData(color: ColorsLight.onSurface),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: ColorsLight.primary,
    cursorColor: ColorsLight.primary,
    // Add any other properties you need
  ),
);
