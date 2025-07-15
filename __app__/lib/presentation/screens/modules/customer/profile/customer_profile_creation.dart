import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/padding_constant.dart';
import 'package:flutter_application_1/core/helpers/validate.dart';
import 'package:flutter_application_1/data/models/client_models.dart';
import 'package:flutter_application_1/presentation/providers/auth_provider.dart';
import 'package:flutter_application_1/presentation/providers/client_provider.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_appbar.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_button.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_confirm_dialog.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_fields.dart';
import 'package:flutter_application_1/presentation/widgets/common/default_snackbar.dart';
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
  final _facebookUrlController = TextEditingController();
  final _messengerUrlController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _facebookUrlController.dispose();
    _messengerUrlController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  void _handleSubmit(ClientProvider clientProvider) async {
    if (_formKey.currentState!.validate()) {
      final fullName = _fullNameController.text.trim();
      final address = _addressController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final facebookUrl = _facebookUrlController.text.trim();
      final messengerUrl = _messengerUrlController.text.trim();

      // Call the provider to create the profile
      final ClientRequest request = ClientRequest(
        fullName: fullName,
        address: address,
        contact: Contact(
          phoneNumber: phoneNumber,
          facebookUrl: facebookUrl.isNotEmpty ? facebookUrl : '',
          messengerUrl: messengerUrl.isNotEmpty ? messengerUrl : '',
        ),
      );

      await clientProvider.createProfile(request);

      if (mounted) {
        context.go("/home");
      }
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
                  const Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
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
                    maxLines: 3,
                  ),
                  const SizedBox(height: 30),

                  // Contact Information Section
                  const Text(
                    'Contact Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
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
                  ),
                  const SizedBox(height: 20),

                  // Facebook URL Field (Optional)
                  CustomInputField(
                    label: 'Facebook Profile (Optional)',
                    hintText: 'https://www.facebook.com/yourprofile',
                    controller: _facebookUrlController,
                    prefixIcon: Icons.facebook_outlined,
                    keyboardType: TextInputType.url,
                    validator: validateFacebookUrl,
                  ),
                  const SizedBox(height: 20),

                  // Messenger URL Field (Optional)
                  CustomInputField(
                    label: 'Messenger Link (Optional)',
                    hintText: 'https://m.me/yourprofile',
                    controller: _messengerUrlController,
                    prefixIcon: Icons.chat_outlined,
                    keyboardType: TextInputType.url,
                    validator: validateMessengerUrl,
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
