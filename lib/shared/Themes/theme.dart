import 'package:flutter/material.dart';
import 'package:my_network_app/shared/Themes/Texts.dart';
import 'package:my_network_app/shared/Themes/colors.dart';

var appTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: transperent),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: orange),
    scaffoldBackgroundColor: navy,
    textTheme: TextTheme(
      displayLarge: h1,
      displayMedium: h2,
      displaySmall: h3,
      headlineMedium: h4,
      headlineSmall: h5,
      titleLarge: title1,
      titleSmall: title2,
      bodyLarge: body,
      bodySmall: caption,
    ));
