import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/theme_toggle_button.dart';

class CustomerMainScreen extends StatelessWidget {
  const CustomerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Module 1'),
        actions: const [ThemeToggleButton()],
      ),
      body: const Center(child: Text('Welcome to Module 1')),
    );
  }
}
