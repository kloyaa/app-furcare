import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_appbar.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_button.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_fields.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_header.dart';
import 'package:go_router/go_router.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Section (Optional)
                const SizedBox(height: 40),
                // Header
                const CustomHeader(
                  title: 'Welcome Back to Furcare',
                  subtitle: 'Please sign in to your account',
                  subtitleSize: AppTextSize.sm,
                  titleSize: AppTextSize.lg,
                ),
                const SizedBox(height: 48),

                // Username Field
                CustomInputField(
                  label: 'Username',
                  hintText: 'Enter your username',
                  controller: _usernameController,
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.text,
                  validator: _validateUsername,
                ),
                const SizedBox(height: 24),

                // Password Field
                CustomInputField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: _validatePassword,
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
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                  icon: Icons.login,
                ),
                const SizedBox(height: 16),

                // Secondary Button (Optional)
                CustomButton(
                  text: 'Create Account',
                  onPressed: () {
                    // Handle create account
                  },
                  isOutlined: true,
                  icon: Icons.person_add_outlined,
                ),
                const SizedBox(height: 32),

                // Social Login Section (Optional)
                Row(
                  children: [
                    Expanded(child: Divider(color: theme.colorScheme.outline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          color: theme.colorScheme.onBackground.withOpacity(
                            0.6,
                          ),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.colorScheme.outline)),
                  ],
                ),
                const SizedBox(height: 24),

                // Social Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Google',
                        onPressed: () {
                          // Handle Google login
                        },
                        backgroundColor: theme.colorScheme.surface,
                        textColor: theme.colorScheme.onSurface,
                        icon: Icons.g_mobiledata,
                        isOutlined: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: 'Apple',
                        onPressed: () {
                          // Handle Apple login
                        },
                        backgroundColor: theme.colorScheme.onSurface,
                        textColor: theme.colorScheme.surface,
                        icon: Icons.apple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
