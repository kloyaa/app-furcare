import 'package:flutter/material.dart';

class ThemeHelper {
  /// Checks if the current theme is in dark mode
  static bool isDarkMode(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark;
  }

  /// Gets the current theme data
  static ThemeData getTheme(BuildContext context) {
    return Theme.of(context);
  }

  /// Gets the current color scheme
  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  /// Gets the primary color of the current theme
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

  /// Gets the background color of the current theme
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.background;
  }

  /// Gets the surface color of the current theme
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  /// Gets the text theme of the current theme
  static TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }
}
