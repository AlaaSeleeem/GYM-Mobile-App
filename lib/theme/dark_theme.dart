import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData darkTheme = ThemeData(
  primarySwatch: primaryColor,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFfbc02d),
      brightness: Brightness.dark,
      onPrimary: Colors.white,
      onSurface: Colors.white),
  primaryColorDark: primaryColor,
  scaffoldBackgroundColor: Colors.black,
  fontFamily: "cairo",
  textSelectionTheme: const TextSelectionThemeData(
    selectionHandleColor: primaryColor,
    cursorColor: primaryColor,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.black,
    hintStyle: TextStyle(color: blackColor[200], fontSize: 14),
    helperStyle: TextStyle(color: blackColor[300], fontSize: 18),
    errorStyle: const TextStyle(fontSize: 16),
    enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.white)),
    focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 1.5, color: primaryColor)),
    focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 1.5, color: primaryColor)),
    errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(width: 1.5, color: Colors.red)),
    labelStyle: TextStyle(color: blackColor[300], fontSize: 18),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),
  appBarTheme: const AppBarTheme(
      color: blackColor,
      centerTitle: true,
      iconTheme: IconThemeData(color: primaryColor),
      surfaceTintColor: blackColor,
      elevation: 0,
      titleTextStyle: TextStyle(
          fontFamily: "cairo",
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: primaryColor)),
);
