import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferencesService {
  static const String _themeKey = 'isDarkMode';

  // Save theme preference
  static Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  // Load theme preference
  static Future<bool> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to light mode (false) if not set
    return prefs.getBool(_themeKey) ?? false;
  }

  // Clear theme preference
  static Future<void> clearThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeKey);
  }
}
