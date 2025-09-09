import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/validate.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_fields.dart';
import 'package:furcare_app/presentation/widgets/common/custom_header.dart';
import 'package:furcare_app/presentation/widgets/common/default_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Password requirement states
  bool _hasMinLength = false;
  bool _hasMaxLength = true;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  // Track the last error message shown to prevent duplicate snackbars
  String? _lastShownErrorMessage;

  @override
  void initState() {
    super.initState();
    // Add listener to update requirements in real-time
    _newPasswordController.addListener(_updatePasswordRequirements);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordRequirements() {
    final password = _newPasswordController.text;
    setState(() {
      _hasMinLength = password.length >= 6;
      _hasMaxLength = password.length <= 255;
      _hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
      _hasNumber = RegExp(r'\d').hasMatch(password);
      _hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    });
  }

  Future<void> _handleChangePassword(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      // Clear the last shown error when attempting a new password change
      _lastShownErrorMessage = null;

      await authProvider.changePassword(
        currentPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        showThemeToggle: false,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final hasError = authProvider.errorMessage != null;

          // Only show snackbar if there's a new error message
          if (hasError && authProvider.errorMessage != _lastShownErrorMessage) {
            _lastShownErrorMessage = authProvider.errorMessage;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomSnackBar(
                context,
                authProvider.errorMessage!,
                isError: true,
              );
            });
          }

          if (authProvider.isUnauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go("/login");
            });
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    const CustomHeader(
                      title: 'Change Password',
                      subtitle:
                          'Please enter your current password and choose a new one',
                      subtitleSize: AppTextSize.sm,
                      titleSize: AppTextSize.lg,
                    ),
                    const SizedBox(height: 48),

                    // Current Password Field
                    CustomInputField(
                      label: 'Current Password',
                      hintText: 'Enter your current password',
                      controller: _currentPasswordController,
                      prefixIcon: Icons.lock_outline,
                      validator: validateCurrentPassword,
                      isRequired: true,
                      onChanged: (value) {
                        // Clear error when user starts typing
                        if (hasError) {
                          authProvider.clearError();
                          _lastShownErrorMessage = null;
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // New Password Field
                    CustomInputField(
                      label: 'New Password',
                      hintText: 'Enter your new password',
                      controller: _newPasswordController,
                      prefixIcon: Icons.lock_outline,
                      validator: validateNewPassword,
                      onChanged: (value) {
                        // Clear error when user starts typing
                        if (hasError) {
                          authProvider.clearError();
                          _lastShownErrorMessage = null;
                        }
                      },
                      isRequired: true,
                    ),
                    const SizedBox(height: 16),

                    // Password Requirements
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withAlpha(51),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password Requirements:',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRequirement(
                            'At least 6 characters',
                            _hasMinLength,
                            theme,
                          ),
                          _buildRequirement(
                            'Maximum 255 characters',
                            _hasMaxLength,
                            theme,
                          ),
                          _buildRequirement(
                            'Contains uppercase letter',
                            _hasUppercase,
                            theme,
                          ),
                          _buildRequirement(
                            'Contains number',
                            _hasNumber,
                            theme,
                          ),
                          _buildRequirement(
                            'Contains special character',
                            _hasSpecialChar,
                            theme,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Confirm Password Field
                    CustomInputField(
                      label: 'Confirm New Password',
                      hintText: 'Confirm your new password',
                      controller: _confirmPasswordController,
                      prefixIcon: Icons.lock_outline,
                      validator: (value) => validateConfirmPassword(
                        value,
                        _newPasswordController.text,
                      ),
                      onChanged: (value) {
                        // Clear error when user starts typing
                        if (hasError) {
                          authProvider.clearError();
                          _lastShownErrorMessage = null;
                        }
                      },
                      isRequired: true,
                    ),
                    const SizedBox(height: 40),

                    // Change Password Button
                    CustomButton(
                      text: 'Change Password',
                      onPressed: () => _handleChangePassword(authProvider),
                      backgroundColor: theme.colorScheme.primary,
                      textColor: theme.colorScheme.onPrimary,
                      icon: Icons.lock_outline,
                      isLoading: authProvider.isLoading,
                    ),
                    const SizedBox(height: 16),
                    // Cancel Button
                    CustomButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                      textColor: theme.colorScheme.onSurface,
                      icon: Icons.cancel_outlined,
                      isOutlined: true,
                      isEnabled: !authProvider.isLoading,
                    ),
                    const SizedBox(height: 32),

                    // Security Tips
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withAlpha(51),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.security,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Security Tips',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Use a unique password that you don\'t use elsewhere. Consider using a password manager to generate and store strong passwords.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withAlpha(179),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildRequirement(String text, bool isMet, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isMet
                ? Colors.green
                : theme.colorScheme.onSurface.withAlpha(102),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isMet
                  ? Colors.green
                  : theme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }
}
