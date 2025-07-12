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
