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

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _usernameController.text = 'teststaff1';
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
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Sign In',
                      onPressed: () => _handleLogin(authProvider),
                      isLoading: authProvider.isLoading,
                      icon: Icons.login,
                      isEnabled: !authProvider.isLoading,
                    ),
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
