import 'package:flutter/material.dart';
import 'package:furcare_app/data/models/__admin/admin_create_user_models.dart';
import 'package:furcare_app/presentation/providers/admin/admin_user_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key});

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _facebookController = TextEditingController();

  // Focus nodes
  final _usernameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _fullNameFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _facebookFocus = FocusNode();

  // Password visibility toggles
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _handleCreateUser() async {
    if (_formKey.currentState!.validate()) {
      final adminProvider = context.read<AdminUserProvider>();

      final payload = CreateUserRequest(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        address: _addressController.text.trim(),
        contact: CreateUserContact(
          phoneNumber: _phoneController.text.trim(),
          facebookDisplayName: _facebookController.text.isEmpty
              ? "No Facebook"
              : _facebookController.text.trim(),
        ),
      );

      await adminProvider.createUser(payload);
    }
  }

  void _validateStepAndProceed() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (_currentStep < 2) {
        setState(() => _currentStep += 1);
      } else {
        _handleCreateUser();
      }
    } else {
      _focusFirstInvalidField();
    }
  }

  void _focusFirstInvalidField() {
    if (_usernameController.text.isEmpty) {
      setState(() => _currentStep = 0);
      _usernameFocus.requestFocus();
    } else if (_emailController.text.isEmpty) {
      setState(() => _currentStep = 0);
      _emailFocus.requestFocus();
    } else if (_passwordController.text.isEmpty) {
      setState(() => _currentStep = 0);
      _passwordFocus.requestFocus();
    } else if (_confirmPasswordController.text.isEmpty ||
        _confirmPasswordController.text != _passwordController.text) {
      setState(() => _currentStep = 0);
      _confirmPasswordFocus.requestFocus();
    } else if (_fullNameController.text.isEmpty) {
      setState(() => _currentStep = 1);
      _fullNameFocus.requestFocus();
    } else if (_addressController.text.isEmpty) {
      setState(() => _currentStep = 1);
      _addressFocus.requestFocus();
    } else if (_phoneController.text.isEmpty) {
      setState(() => _currentStep = 2);
      _phoneFocus.requestFocus();
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _facebookController.dispose();

    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _fullNameFocus.dispose();
    _addressFocus.dispose();
    _phoneFocus.dispose();
    _facebookFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Create Staff Account",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: Form(
                key: _formKey,
                child: Stepper(
                  type: StepperType.vertical,
                  currentStep: _currentStep,
                  onStepContinue: _validateStepAndProceed,
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep -= 1);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  controlsBuilder: (context, details) {
                    final adminProvider = context.watch<AdminUserProvider>();

                    final isLastStep = _currentStep == 2;
                    final isLoading = adminProvider.isCreating;

                    return Row(
                      children: [
                        ElevatedButton(
                          onPressed: isLoading ? null : details.onStepContinue,
                          child: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(isLastStep ? "Submit" : "Next"),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: isLoading ? null : details.onStepCancel,
                          child: Text(_currentStep == 0 ? "Cancel" : "Back"),
                        ),
                      ],
                    );
                  },
                  steps: [
                    Step(
                      title: const Text("Account Information"),
                      isActive: _currentStep >= 0,
                      content: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _usernameController,
                              focusNode: _usernameFocus,
                              label: 'Username',
                              hint: 'Enter username',
                              icon: Icons.person_outline,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              label: 'Email',
                              hint: 'Enter email',
                              icon: Icons.email_outlined,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildPasswordField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              label: 'Password',
                              hint: 'Enter password',
                              isVisible: _isPasswordVisible,
                              onToggleVisibility: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildPasswordField(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              label: 'Confirm Password',
                              hint: 'Re-enter password',
                              isVisible: _isConfirmPasswordVisible,
                              onToggleVisibility: () => setState(
                                () => _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible,
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Required';
                                } else if (v != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Step(
                      title: const Text("Personal Information"),
                      isActive: _currentStep >= 1,
                      content: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _fullNameController,
                              focusNode: _fullNameFocus,
                              label: 'Full Name',
                              hint: 'Enter full name',
                              icon: Icons.badge_outlined,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _addressController,
                              focusNode: _addressFocus,
                              label: 'Address',
                              hint: 'Enter complete address',
                              icon: Icons.location_on_outlined,
                              maxLines: 2,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Step(
                      title: const Text("Contact Information"),
                      isActive: _currentStep >= 2,
                      content: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              label: 'Phone Number',
                              hint: 'Ex: 09991234567',
                              icon: Icons.phone_outlined,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _facebookController,
                              focusNode: _facebookFocus,
                              label: 'Facebook Display Name (Optional)',
                              hint: 'Enter Facebook display name',
                              icon: Icons.facebook_outlined,
                              required: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Consumer<AdminUserProvider>(
              builder: (context, adminProvider, child) {
                if (adminProvider.error == null) {
                  return Container();
                }
                String errorMessage = adminProvider.error ?? "";

                if (adminProvider.error ==
                    "Account already registered, Please try logging in.") {
                  errorMessage = "Account already exists.";
                }

                return Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomText(errorMessage, color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool required = true,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      validator: required ? validator : null,
      maxLines: maxLines,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
