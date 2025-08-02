import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.checkAuthStatus();

      if (mounted) {
        if (authProvider.isAuthenticated) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            FadeIn(
              duration: const Duration(seconds: 2),
              child: Image.asset(
                "assets/furcare_logo.png",
                width: 320.0,
                height: 320.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
