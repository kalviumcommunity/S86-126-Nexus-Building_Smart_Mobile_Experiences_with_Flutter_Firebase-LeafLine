import 'package:flutter/material.dart';

/// Custom Light Theme with Material 3 Design
class AppThemes {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Primary Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
        brightness: Brightness.light,
        primary: Colors.green.shade700,
        secondary: Colors.teal.shade600,
        tertiary: Colors.lightGreen.shade600,
        surface: Colors.white,
        background: Colors.grey.shade50,
        error: Colors.red.shade700,
      ),

      // Scaffold
      scaffoldBackgroundColor: Colors.grey.shade50,

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: Colors.green.shade700, size: 24),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Drawer
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
        elevation: 16,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
        space: 1,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.green.shade700;
          }
          return Colors.grey.shade400;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.green.shade200;
          }
          return Colors.grey.shade300;
        }),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade900,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade900,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade900,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.grey.shade800),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        labelLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Primary Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
        primary: Colors.teal.shade400,
        secondary: Colors.greenAccent.shade400,
        tertiary: Colors.lightGreenAccent.shade400,
        surface: Colors.grey.shade900,
        background: Colors.black,
        error: Colors.red.shade400,
      ),

      // Scaffold
      scaffoldBackgroundColor: Colors.grey.shade900,

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.tealAccent.shade400,
        iconTheme: IconThemeData(color: Colors.tealAccent.shade400),
        titleTextStyle: TextStyle(
          color: Colors.tealAccent.shade400,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey.shade800,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: Colors.teal.shade400, size: 24),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.black,
        elevation: 4,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey.shade900,
        selectedItemColor: Colors.tealAccent.shade400,
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Drawer
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.grey.shade900,
        elevation: 16,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade700,
        thickness: 1,
        space: 1,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.teal.shade400;
          }
          return Colors.grey.shade600;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.teal.shade700;
          }
          return Colors.grey.shade700;
        }),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade100,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade100,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade100,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade200,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.grey.shade300),
        bodyMedium: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }
}
