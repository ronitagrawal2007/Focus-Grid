import 'package:flutter/material.dart';
import 'package:work_helper_app/Theme/ThemeMode.dart';
import 'package:work_helper_app/Services/ThemePreferencesService.dart';

class DarkModeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool _isDarkMode = false;

  ThemeData get themeData => _themeData;

  // Logic fix: Ensure this compares correctly
  bool get isDarkMode => _isDarkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _isDarkMode = _themeData == darkMode;
    _saveTheme();
    notifyListeners(); // This is vital!
  }

  void toggleTheme() {
    if (_isDarkMode) {
      themeData = lightMode; // Uses the setter
    } else {
      themeData = darkMode; // Uses the setter
    }
  }

  // Load theme from SharedPreferences on app startup
  Future<void> loadSavedTheme() async {
    _isDarkMode = await ThemePreferencesService.loadThemePreference();
    _themeData = _isDarkMode ? darkMode : lightMode;
    notifyListeners();
  }

  // Save theme to SharedPreferences
  Future<void> _saveTheme() async {
    await ThemePreferencesService.saveThemePreference(_isDarkMode);
  }
}
