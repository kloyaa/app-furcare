import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/providers/health_check_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
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
    _initializeApp();
  }

  void _initializeApp() async {
    // Show splash for minimum 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // First, check system health
    final healthProvider = context.read<HealthCheckProvider>();
    await healthProvider.checkHealth();

    if (!mounted) return;

    final healthStatus = healthProvider.healthStatus;
    if (healthStatus == null) {
      return;
    }

    if (healthStatus.maintenance.value) {
      _showMaintenanceDialog();
      return;
    }

    _proceedToAuth();
  }

  void _proceedToAuth() async {
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.checkAuthStatus();

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  void _showMaintenanceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.build_outlined,
            size: 48,
            color: Colors.orange,
          ),
        ),
        title: CustomText.title('Maintenance', textAlign: TextAlign.center),
        content: Consumer<HealthCheckProvider>(
          builder: (context, healthProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText.body(
                  healthProvider.maintenanceMessage,
                  textAlign: TextAlign.center,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  child: CustomButton(
                    text: healthProvider.isLoading
                        ? 'Checking...'
                        : 'Check Again',
                    onPressed: () async {
                      await healthProvider.checkHealth();
                      if (!mounted) return;

                      if (healthProvider.healthStatus?.maintenance.value ==
                          false) {
                        _initializeApp();
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Consumer<HealthCheckProvider>(
        builder: (context, healthProvider, child) {
          return Center(
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

                // Loading indicator only when checking health
                if (healthProvider.isLoading) ...[
                  const SizedBox(height: 32),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  FadeIn(
                    duration: const Duration(milliseconds: 500),
                    child: CustomText.body(
                      'Checking system status...',
                      color: theme.colorScheme.onSurface.withAlpha(160),
                      size: AppTextSize.sm,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
