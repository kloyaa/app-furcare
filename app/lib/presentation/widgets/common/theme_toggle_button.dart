import 'package:flutter/material.dart';
import 'package:furcare_app/core/theme/theme_notifier.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode,
      builder: (context, isDarkMode, _) {
        return IconButton(
          icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
          onPressed: () {
            ThemeNotifier.toggleTheme();
          },
        );
      },
    );
  }
}
