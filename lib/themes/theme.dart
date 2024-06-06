import 'package:flutter/material.dart';
import 'package:shoesly_flutter/utils/values.dart';

//light mode
ThemeData lightMode = ThemeData(
  // colorSchemeSeed: AppColors.primaryAccentColor,
  useMaterial3: false,
  fontFamily: "Urbanist",
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.primaryBackgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
  ),
);

//dark mode
ThemeData darkMode = ThemeData(
  useMaterial3: false,
  fontFamily: "Urbanist",
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.primaryBackgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
  ),
);
