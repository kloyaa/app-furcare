import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeNotifier.isDarkMode,
      builder: (context, isDarkMode, _) {
        return MaterialApp(
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Toggle'),
        actions: [
          IconButton(
            icon: Icon(
              ThemeNotifier.isDarkMode.value
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              ThemeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: const Center(child: Text('Hello World!')),
    );
  }
}

class ThemeNotifier {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  static void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
