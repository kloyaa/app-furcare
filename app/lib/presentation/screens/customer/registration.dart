import 'package:flutter/material.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/validate.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_fields.dart';
import 'package:furcare_app/presentation/widgets/common/custom_header.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/common/default_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _handleRegistration(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      await authProvider.register(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        email: _emailController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final hasError = authProvider.errorMessage != null;
          final errorCode = authProvider.errorCode;
          // Handle specific error codes
          if (errorCode == "0052") {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              authProvider.clearError();
              context.go(
                "/pre-login",
                extra: {"username": _usernameController.text.trim()},
              );
            });
          }

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
              context.go("/me/profile/create");
            });
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: kDefaultBodyPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                            title: 'Welcome to Furcare',
                            subtitle: 'Create your account to get started',
                            subtitleSize: AppTextSize.sm,
                            titleSize: AppTextSize.mlg,
                          ),
                        ),
                      ],
                    ),

                    // Email Field
                    CustomInputField(
                      label: 'Email Address',
                      hintText: 'Enter your email address',
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      isRequired: true,
                    ),
                    const SizedBox(height: 20),

                    // Username Field
                    CustomInputField(
                      label: 'Username',
                      hintText: 'Enter your username',
                      controller: _usernameController,
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.text,
                      validator: validateUsername,
                      isRequired: true,
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    CustomInputField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      isPassword: true,
                      withSuffixIcon: true,
                      prefixIcon: Icons.lock_outline,
                      validator: validatePassword,
                      isRequired: true,
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    CustomInputField(
                      label: 'Confirm Password',
                      hintText: 'Confirm your password',
                      controller: _confirmPasswordController,
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) => validateConfirmPassword(
                        _passwordController.text,
                        value,
                      ),
                      isRequired: true,
                    ),
                    const SizedBox(height: 32),

                    // Registration Button
                    CustomButton(
                      text: authProvider.isLoading
                          ? 'Creating Account...'
                          : 'Create Account',
                      onPressed: () => _handleRegistration(authProvider),
                      isEnabled: !authProvider.isLoading,
                      icon: Icons.person_add_outlined,
                      isLoading: authProvider.isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText.body(
                          'Already have an account?',
                          fontWeight: AppFontWeight.normal.value,
                          size: AppTextSize.sm,
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/login');
                          },
                          child: CustomText.body(
                            'Sign In',
                            fontWeight: AppFontWeight.bold.value,
                            color: theme.colorScheme.primary,
                            size: AppTextSize.sm,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Terms and Privacy
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: AppTextSize.xs.size,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By creating an account, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.blue[300]
                                    : Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.blue[300]
                                    : Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
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
