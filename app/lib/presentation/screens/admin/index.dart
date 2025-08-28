import 'package:flutter/material.dart';
import 'package:furcare_app/presentation/widgets/common/theme_toggle_button.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

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
