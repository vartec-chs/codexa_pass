import 'colors/colors_dark.dart';
import 'package:flutter/material.dart';

import 'color_schemas/schema_dark.dart';

import 'package:google_fonts/google_fonts.dart';

import 'widgets/widgets_dark.dart';

final ThemeData appDarkTheme = ThemeData(
  colorScheme: darkColorScheme,
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: ColorsDark.background,
  appBarTheme: AppBarTheme(
    backgroundColor: ColorsDark.primary,
    foregroundColor: ColorsDark.onPrimary,
  ),
  textTheme: GoogleFonts.rubikTextTheme().copyWith(
    bodyLarge: GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    bodyMedium: GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    bodySmall: GoogleFonts.rubik(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurfaceVariant,
    ),
    titleLarge: GoogleFonts.rubik(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    titleMedium: GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    titleSmall: GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    labelLarge: GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    labelMedium: GoogleFonts.rubik(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    labelSmall: GoogleFonts.rubik(
      fontSize: 10,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    displayLarge: GoogleFonts.rubik(
      fontSize: 80,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    displayMedium: GoogleFonts.rubik(
      fontSize: 50,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    displaySmall: GoogleFonts.rubik(
      fontSize: 38,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    headlineLarge: GoogleFonts.rubik(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    headlineMedium: GoogleFonts.rubik(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
    headlineSmall: GoogleFonts.rubik(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.0,
      color: ColorsDark.onSurface,
    ),
  ),

  
  filledButtonTheme: filledButtonTheme,
  textButtonTheme: textButtonTheme,
  elevatedButtonTheme: elevatedButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme,
  iconButtonTheme: iconButtonTheme,
  inputDecorationTheme: textInputDark,
  chipTheme: chipTheme,
  fontFamily: 'Rubik',
  iconTheme: IconThemeData(color: ColorsDark.onSurface),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: ColorsDark.primary,
    cursorColor: ColorsDark.primary,
    // Add any other properties you need
  ),
);
