import 'package:flutter/material.dart';
import 'package:mpro_notes/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  // Default theme is light mode
  ThemeData _themeData = lightMode;

  // Getter method for theme from theme.dart
  ThemeData get themeData => _themeData;

  // Getter method for dark mode
  bool get isDarkMode => _themeData == darkMode;

  // Setter method for theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // Method to toggle theme
  void toggleTheme() {
    _themeData = isDarkMode ? lightMode : darkMode;
    notifyListeners();
  }
}
