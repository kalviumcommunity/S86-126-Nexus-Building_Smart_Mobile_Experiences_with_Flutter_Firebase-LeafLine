import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme Provider to manage app theme state and persistence
///
/// Handles:
/// - Light/Dark/System theme modes
/// - Theme persistence across app restarts
/// - ThemeMode state management using Provider
class ThemeProvider with ChangeNotifier {
  // SharedPreferences key for storing theme preference
  static const String _themePreferenceKey = 'theme_mode';

  // Current theme mode (default: system)
  ThemeMode _themeMode = ThemeMode.system;

  // Flag to track if preferences have been loaded
  bool _isInitialized = false;

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if theme is currently dark (considers system theme)
  bool get isDarkMode {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;

    // For system mode, we'd need BuildContext to check actual brightness
    // For simplicity, we'll treat system as light in this getter
    return false;
  }

  /// Check if initialization is complete
  bool get isInitialized => _isInitialized;

  /// Get theme mode as a displayable string
  String get themeModeString {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Constructor - loads theme preference on initialization
  ThemeProvider() {
    _loadThemePreference();
  }

  /// Load saved theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeIndex = prefs.getInt(_themePreferenceKey);

      if (savedThemeIndex != null) {
        // Convert saved index back to ThemeMode
        _themeMode = ThemeMode.values[savedThemeIndex];
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themePreferenceKey, _themeMode.index);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  /// Set theme mode and persist the choice
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();
    await _saveThemePreference();
  }

  /// Toggle between light and dark mode (skips system)
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Check if current mode is light
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Check if current mode is dark (explicit dark, not system)
  bool get isExplicitDarkMode => _themeMode == ThemeMode.dark;

  /// Check if current mode is system
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Get appropriate icon for current theme
  IconData get themeIcon {
    switch (_themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.settings_brightness;
    }
  }

  /// Reset theme to system default
  Future<void> resetTheme() async {
    await setThemeMode(ThemeMode.system);
  }
}
