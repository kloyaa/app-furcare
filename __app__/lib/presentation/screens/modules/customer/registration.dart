import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/padding_constant.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';
import 'package:flutter_application_1/core/helpers/validate.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_button.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_fields.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_header.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_text.dart';

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

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Create the JSON data that would be sent to API
      final registrationData = {
        "email": _emailController.text.trim(),
        "username": _usernameController.text.trim(),
        "password": _passwordController.text,
      };

      // Print the JSON data (for demonstration)
      if (kDebugMode) {
        print('Registration Data: $registrationData');
      }

      setState(() {
        _isLoading = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      // Here you would typically navigate to next screen or handle success
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: kDefaultBodyPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),

                // Header
                const CustomHeader(
                  title: 'Welcome to Furcare',
                  subtitle: 'Create your account to get started',
                  subtitleSize: AppTextSize.sm,
                  titleSize: AppTextSize.lg,
                ),
                const SizedBox(height: 48),

                // Email Field
                CustomInputField(
                  label: 'Email Address',
                  hintText: 'Enter your email address',
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
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
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                CustomInputField(
                  label: 'Confirm Password',
                  hintText: 'Confirm your password',
                  controller: _confirmPasswordController,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) =>
                      validateConfirmPassword(_passwordController.text, value),
                ),
                const SizedBox(height: 32),

                // Registration Button
                CustomButton(
                  text: _isLoading ? 'Creating Account...' : 'Create Account',
                  onPressed: _isLoading ? null : _handleRegistration,
                  icon: _isLoading ? null : Icons.person_add_outlined,
                  isLoading: _isLoading,
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
                        // Navigate to login screen
                        Navigator.pop(context);
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
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
      ),
    );
  }
}
