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
    return Theme.of(context).colorScheme.surface;
  }

  /// Gets the surface color of the current theme
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  /// Gets the text theme of the current theme
  static TextTheme getTextTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  /// Gets the primary text color (typically for body text)
  static Color getPrimaryTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  /// Gets the secondary text color (typically for less prominent text)
  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface.withAlpha(153);
  }

  /// Gets text color for content on background
  static Color getOnBackgroundTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  /// Gets text color for content on primary color
  static Color getOnPrimaryTextColor(BuildContext context) {
    return Theme.of(context).colorScheme.onPrimary;
  }
}
