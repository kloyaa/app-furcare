import 'package:flutter/material.dart';

class ThemeNotifier {
  static ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  static void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        ThemeNotifier.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
      ),
      onPressed: () {
        ThemeNotifier.toggleTheme();
      },
    );
  }
}
