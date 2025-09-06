import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/state.dart';
import 'package:furcare_app/data/models/__admin/admin_create_user_models.dart';
import 'package:furcare_app/data/models/__admin/admin_user_models.dart';
import 'package:furcare_app/presentation/providers/admin/admin_user_provider.dart';
import 'package:provider/provider.dart';

class UpdateUserDialog extends StatefulWidget {
  final AdminUser user;

  const UpdateUserDialog({super.key, required this.user});

  @override
  State<UpdateUserDialog> createState() => _UpdateUserDialogState();
}

class _UpdateUserDialogState extends State<UpdateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  late final TextEditingController _facebookController;

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _fullNameFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _facebookFocus = FocusNode();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    // Pre-fill with existing user data
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController(); // empty by default
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _addressController = TextEditingController(text: widget.user.address);
    _phoneController = TextEditingController(
      text: widget.user.contact.phoneNumber,
    );
    _facebookController = TextEditingController(
      text: widget.user.contact.facebookDisplayName,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _facebookController.dispose();

    _emailFocus.dispose();
    _passwordFocus.dispose();
    _fullNameFocus.dispose();
    _addressFocus.dispose();
    _phoneFocus.dispose();
    _facebookFocus.dispose();

    super.dispose();
  }

  Future<void> _handleUpdateUser() async {
    if (!_formKey.currentState!.validate()) return;

    final adminProvider = context.read<AdminUserProvider>();

    final payload = UpdateUserInfoRequest(
      user: widget.user.id,
      email: _emailController.text.trim(),
      password: _passwordController.text.isEmpty
          ? ""
          : _passwordController.text,
      fullName: _fullNameController.text.trim(),
      address: _addressController.text.trim(),
      contact: CreateUserContact(
        phoneNumber: _phoneController.text.trim(),
        facebookDisplayName: _facebookController.text.isEmpty
            ? "No Facebook"
            : _facebookController.text.trim(),
      ),
    );

    await adminProvider.updateUser(payload);

    if (mounted) {
      if (adminProvider.updateState == AdminState.success) {
        Navigator.of(context).pop(true); // return success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User updated successfully")),
        );
      }
    }
  }

  void _validateStepAndProceed() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      if (_currentStep < 2) {
        setState(() => _currentStep += 1);
      } else {
        _handleUpdateUser();
      }
    } else {
      _focusFirstInvalidField();
    }
  }

  void _focusFirstInvalidField() {
    if (_emailController.text.isEmpty) {
      setState(() => _currentStep = 0);
      _emailFocus.requestFocus();
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
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Edit User",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Form(
                key: _formKey,
                child: Stepper(
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
                    final isLoading = adminProvider.isUpdating;

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
                              : Text(isLastStep ? "Save" : "Next"),
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
                              controller: _emailController,
                              focusNode: _emailFocus,
                              label: "Email",
                              icon: Icons.email_outlined,
                              validator: (v) =>
                                  v == null || v.isEmpty ? "Required" : null,
                            ),
                            const SizedBox(height: 16),
                            _buildPasswordField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              label: "Password (leave blank to keep same)",
                              isVisible: _isPasswordVisible,
                              onToggleVisibility: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
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
                              label: "Full Name",
                              icon: Icons.badge_outlined,
                              validator: (v) =>
                                  v == null || v.isEmpty ? "Required" : null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _addressController,
                              focusNode: _addressFocus,
                              label: "Address",
                              icon: Icons.location_on_outlined,
                              validator: (v) =>
                                  v == null || v.isEmpty ? "Required" : null,
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
                              label: "Phone Number",
                              icon: Icons.phone_outlined,
                              validator: (v) =>
                                  v == null || v.isEmpty ? "Required" : null,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _facebookController,
                              focusNode: _facebookFocus,
                              label: "Facebook Display Name (Optional)",
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
                if (adminProvider.error == null) return Container();

                String errorMessage = adminProvider.error ?? "";

                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
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
    required IconData icon,
    String? Function(String?)? validator,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return "$label is required";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
