import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier(false);
  static final ValueNotifier<ThemeColorData> selectedColor = ValueNotifier(
    ThemeColorData.blue, // Default to brown
  );

  static const String _darkModeKey = 'isDarkMode';
  static const String _themeColorKey = 'themeColor';

  // Initialize theme from saved preferences
  static Future<void> initializeTheme() async {
    final prefs = await SharedPreferences.getInstance();

    // Load dark mode preference
    isDarkMode.value = prefs.getBool(_darkModeKey) ?? false;

    // Load theme color preference
    final colorName = prefs.getString(_themeColorKey) ?? 'Brown';
    selectedColor.value = ThemeColorData.getByName(colorName);
  }

  // Toggle between light and dark mode
  static Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, isDarkMode.value);
  }

  // Change theme color
  static Future<void> changeThemeColor(ThemeColorData colorData) async {
    selectedColor.value = colorData;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeColorKey, colorData.name);
  }

  // Get current light theme
  static ThemeData get lightTheme {
    return ThemeData(
      textTheme: GoogleFonts.latoTextTheme(),
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: selectedColor.value.lightColor,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: selectedColor.value.lightColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedColor.value.lightColor,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: selectedColor.value.lightColor,
        foregroundColor: Colors.white,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        strokeWidth: 2.0,
        color: selectedColor.value.lightColor,
      ),
      checkboxTheme: CheckboxThemeData(),
      radioTheme: RadioThemeData(),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(selectedColor.value.lightColor),
        trackColor: WidgetStateProperty.all(selectedColor.value.accentColor),
      ),
    );
  }

  // Get current dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      textTheme: GoogleFonts.latoTextTheme(),
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: selectedColor.value.darkColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: selectedColor.value.darkColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedColor.value.darkColor,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: selectedColor.value.darkColor,
        foregroundColor: Colors.white,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: selectedColor.value.darkColor,
      ),
      checkboxTheme: CheckboxThemeData(),
      radioTheme: RadioThemeData(),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(selectedColor.value.darkColor),
        trackColor: WidgetStateProperty.all(
          selectedColor.value.accentColor.withAlpha(77),
        ),
      ),
    );
  }
}

// Theme color data class
class ThemeColorData {
  final String name;
  final Color lightColor;
  final Color darkColor;
  final Color accentColor;

  const ThemeColorData({
    required this.name,
    required this.lightColor,
    required this.darkColor,
    required this.accentColor,
  });

  // Predefined theme colors
  static const brown = ThemeColorData(
    name: 'Brown',
    lightColor: Color(0xFF8D6E63),
    darkColor: Color(0xFF5D4037),
    accentColor: Color(0xFFBCAAA4),
  );

  static const purple = ThemeColorData(
    name: 'Purple',
    lightColor: Color(0xFF9C27B0),
    darkColor: Color(0xFF7B1FA2),
    accentColor: Color(0xFFE1BEE7),
  );

  static const blue = ThemeColorData(
    name: 'Blue',
    lightColor: Color(0xFF2196F3),
    darkColor: Color(0xFF1976D2),
    accentColor: Color(0xFFBBDEFB),
  );

  static const green = ThemeColorData(
    name: 'Green',
    lightColor: Color(0xFF4CAF50),
    darkColor: Color(0xFF388E3C),
    accentColor: Color(0xFFC8E6C9),
  );

  static const orange = ThemeColorData(
    name: 'Orange',
    lightColor: Color(0xFFFF9800),
    darkColor: Color(0xFFE65100),
    accentColor: Color(0xFFFFE0B2),
  );

  static const teal = ThemeColorData(
    name: 'Teal',
    lightColor: Color(0xFF009688),
    darkColor: Color(0xFF00695C),
    accentColor: Color(0xFFB2DFDB),
  );

  static final red = ThemeColorData(
    name: 'Red',
    lightColor: Colors.red,
    darkColor: Colors.red[800]!,
    accentColor: Colors.redAccent,
  );

  // Get all available colors
  static List<ThemeColorData> get allColors => [
    brown,
    purple,
    blue,
    green,
    orange,
    teal,
    red,
  ];

  // Get color by name
  static ThemeColorData getByName(String name) {
    return allColors.firstWhere(
      (color) => color.name == name,
      orElse: () => brown, // Default to brown if not found
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeColorData && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
