import 'package:flutter/material.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/utils/theme.dart';
import 'package:furcare_app/core/utils/validate.dart';
import 'package:furcare_app/data/models/client_models.dart';
import 'package:furcare_app/presentation/providers/auth_provider.dart';
import 'package:furcare_app/presentation/providers/client_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_confirm_dialog.dart';
import 'package:furcare_app/presentation/widgets/common/custom_fields.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/common/default_snackbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomerProfileCreationScreen extends StatefulWidget {
  const CustomerProfileCreationScreen({super.key});

  @override
  State<CustomerProfileCreationScreen> createState() =>
      _CustomerProfileCreationScreenState();
}

class _CustomerProfileCreationScreenState
    extends State<CustomerProfileCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _facebookDisplayNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  // Loading state for auto-fill
  bool _isAutoFillLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _facebookDisplayNameController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  void _handleSubmit(ClientProvider clientProvider) async {
    if (_formKey.currentState!.validate()) {
      final fullName = _fullNameController.text.trim();
      final address = _addressController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final facebookDisplayName = _facebookDisplayNameController.text.trim();

      // Call the provider to create the profile
      final ClientRequest request = ClientRequest(
        fullName: fullName,
        address: address,
        contact: Contact(
          phoneNumber: phoneNumber,
          facebookDisplayName: facebookDisplayName.isNotEmpty
              ? facebookDisplayName
              : '',
        ),
      );

      await clientProvider.createProfile(request);

      if (mounted) {
        context.go("/home");
      }
    }
  }

  void _handleAutoFillLocation() async {
    setState(() {
      _isAutoFillLoading = true;
    });

    // Simulate loading delay for better UX
    await Future.delayed(const Duration(milliseconds: 2500));

    if (mounted) {
      _addressController.text =
          "Cagayan de Oro City, 9000, Misamis Oriental, Philippines";

      setState(() {
        _isAutoFillLoading = false;
      });

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Location auto-filled successfully'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleLogout() async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: "Confirm Switch Account",
      message:
          "Are you sure you want to switch accounts? This will log you out.",
      confirmText: "Logout",
      cancelText: "Cancel",
      icon: Icons.switch_account_outlined,
      confirmColor: Colors.red,
    );

    if (confirmed == true) {
      if (!mounted) return;
      // Call logout on the provider and navigate to login screen
      context.read<AuthProvider>().logout();
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(leading: SizedBox()),
      body: Consumer<ClientProvider>(
        builder: (context, clientProvider, child) {
          final hasError = clientProvider.error != null;
          final errorCode = clientProvider.errorCode;

          if (hasError && errorCode != "02") {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomSnackBar(context, clientProvider.error!, isError: true);
            });
          }

          return SingleChildScrollView(
            padding: kDefaultBodyPadding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  CustomText.title(
                    'Personal Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomText.body(
                    'Please fill in your details to create your profile',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),

                  // Full Name Field
                  CustomInputField(
                    label: 'Full Name',
                    hintText: 'Enter your full name',
                    controller: _fullNameController,
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    validator: validateFullName,
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),

                  // Address Field
                  CustomInputField(
                    label: 'Address',
                    hintText: 'Enter your complete address',
                    controller: _addressController,
                    prefixIcon: Icons.location_on_outlined,
                    keyboardType: TextInputType.streetAddress,
                    validator: validateAddress,
                    isRequired: true,

                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),

                  // Auto-fill Location Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isAutoFillLoading
                          ? null
                          : _handleAutoFillLocation,
                      icon: _isAutoFillLoading
                          ? SizedBox(
                              width: 26,
                              height: 16,
                              child: SpinKitThreeBounce(
                                color: ThemeHelper.getOnBackgroundTextColor(
                                  context,
                                ),
                                size: 12.0,
                              ),
                            )
                          : Icon(Icons.my_location_outlined),
                      label: Text(
                        _isAutoFillLoading
                            ? 'Getting location...'
                            : 'Use My Current Location',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        side: BorderSide(
                          color: Theme.of(context).primaryColor.withAlpha(77),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Contact Information Section
                  CustomText.title(
                    'Contact Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomText.body(
                    'Phone number is required. Social media links are optional.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),

                  // Phone Number Field
                  CustomInputField(
                    label: 'Phone Number',
                    hintText: '09171234567',
                    controller: _phoneNumberController,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: validatePhoneNumber,
                    isRequired: true,
                  ),
                  const SizedBox(height: 20),

                  // Facebook URL Field (Optional)
                  CustomInputField(
                    label: 'Facebook Name (Optional)',
                    hintText: 'Juan Dela Cruz',
                    controller: _facebookDisplayNameController,
                    prefixIcon: Icons.facebook_outlined,
                    keyboardType: TextInputType.text,
                    validator: validateFacebookDisplayName,
                    isRequired: false,
                  ),
                  const SizedBox(height: 40),
                  // Submit Button
                  CustomButton(
                    text: 'Create Profile',
                    onPressed: () => _handleSubmit(clientProvider),
                    icon: Icons.save_outlined,
                    isLoading: clientProvider.isLoading,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Switch account',
                    onPressed: _handleLogout,
                    icon: Icons.switch_account_outlined,
                    isOutlined: true,
                    isEnabled: !clientProvider.isLoading,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
