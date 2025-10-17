import 'package:flutter/material.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/validate.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_fields.dart';
import 'package:furcare_app/presentation/widgets/common/custom_header.dart';
import 'package:furcare_app/presentation/widgets/common/default_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _usernameController.text = 'testuser1';
    _passwordController.text = 'Test@Password1';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _handleLogin(AuthProvider authProvider) async {
    if (_formKey.currentState?.validate() ?? false) {
      await authProvider.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

            // delayed execution to clear error after showing snackbar
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authProvider.clearError();
            });
          }

          // Navigate to home if authenticated
          if (authProvider.isAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
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
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Image.asset(
                            'assets/furcare_logo.png',
                            width: 150,
                            height: 150,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: const CustomHeader(
                            title: 'Welcome Back to Furcare',
                            subtitle: 'Please sign in to your account',
                            subtitleSize: AppTextSize.sm,
                            titleSize: AppTextSize.mlg,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    // Username Field
                    CustomInputField(
                      label: 'Username',
                      hintText: 'Enter your username',
                      controller: _usernameController,
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.text,
                      error: hasError,
                      validator: validateUsername,
                      isRequired: true,
                    ),
                    const SizedBox(height: 24),

                    // Password Field
                    CustomInputField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      error: hasError,
                      withSuffixIcon: true,
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
                      onPressed: () => _handleLogin(authProvider),
                      isLoading: authProvider.isLoading,
                      icon: Icons.login,
                      isEnabled: !authProvider.isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Secondary Button (Optional)
                    CustomButton(
                      text: 'Create Account',
                      onPressed: () {
                        context.go("/registration");
                      },
                      isOutlined: true,
                      icon: Icons.person_add_outlined,
                      isEnabled: !authProvider.isLoading,
                    ),
                    const SizedBox(height: 32),

                    // Social Login Section (Optional)
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: theme.colorScheme.outline),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface..withAlpha(15),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: theme.colorScheme.outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social Buttons
                    CustomButton(
                      text: 'Google',
                      onPressed: () {
                        // Handle Google login
                      },
                      backgroundColor: theme.colorScheme.surface,
                      textColor: theme.colorScheme.onSurface,
                      icon: Icons.g_mobiledata,
                      isOutlined: true,
                    ),
                    const SizedBox(height: 24),
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
