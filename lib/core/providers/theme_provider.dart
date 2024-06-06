import 'package:flutter/material.dart';
import 'package:shoesly_flutter/themes/theme.dart';

class ThemeProvider with ChangeNotifier {
  // height and width by default
  double height = 0;
  double width = 0;

  //initially light mode theme
  ThemeData _themeData = lightMode;

  //getter method to access the theme from other parts of the code
  ThemeData get themeData => _themeData;

  //getter method to see if the dark is turned on or not
  bool get isDarkMode => _themeData == darkMode;

  //setter method to set the new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //this enables the switching of themes
  //from either dark mode or light mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
