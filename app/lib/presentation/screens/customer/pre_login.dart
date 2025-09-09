import 'package:flutter/material.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/validate.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_fields.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/common/default_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomerPreLoginScreen extends StatefulWidget {
  const CustomerPreLoginScreen({super.key});

  @override
  State<CustomerPreLoginScreen> createState() => _CustomerPreLoginScreenState();
}

class _CustomerPreLoginScreenState extends State<CustomerPreLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _passwordController.text = 'Password@123';
  }

  @override
  void dispose() {
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _handleLogin(AuthProvider authProvider, String username) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      await authProvider.login(
        username: username,
        password: _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final extras = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final passedUsername = extras?['username'] ?? '';

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final hasError = authProvider.errorMessage != null;

          if (hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomSnackBar(
                context,
                authProvider.errorMessage!,
                isError: true,
              );
            });
          }

          // Navigate to home if authenticated
          if (authProvider.isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authProvider.clearError();
              context.go("/home");
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: kDefaultBodyPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo Section (Optional)
                    const SizedBox(height: 40),

                    CustomText.subtitle(
                      "Welcome back to Furcare",
                      size: AppTextSize.md,
                      fontWeight: AppFontWeight.normal.value,
                      color: theme.colorScheme.onSurface,
                    ),
                    CustomText.title(
                      passedUsername,
                      size: passedUsername.toString().length < 9
                          ? AppTextSize.xl
                          : AppTextSize.lg,
                      fontWeight: AppFontWeight.bold.value,
                      color: theme.colorScheme.onSurface,
                    ),

                    const SizedBox(height: 20),

                    // Password Field
                    CustomInputField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      error: hasError,
                      validator: validatePassword,
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Login Button
                    CustomButton(
                      text: 'Sign In',
                      onPressed: () =>
                          _handleLogin(authProvider, passedUsername),
                      isLoading: _isLoading,
                      icon: Icons.person_outline,
                      isEnabled: !_isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Secondary Button (Optional)
                    CustomButton(
                      text: 'Sign in as another user',
                      onPressed: () {
                        context.go("/login");
                      },
                      isOutlined: true,
                      icon: Icons.login,
                      isEnabled: !_isLoading,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
