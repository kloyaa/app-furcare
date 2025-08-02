import 'package:flutter/material.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/helpers/validate.dart';
import 'package:furcare_app/data/models/client_models.dart';
import 'package:furcare_app/presentation/providers/client_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_fields.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/common/default_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomerUpdateProfileScreen extends StatefulWidget {
  const CustomerUpdateProfileScreen({super.key});

  @override
  State<CustomerUpdateProfileScreen> createState() =>
      _CustomerUpdateProfileScreenState();
}

class _CustomerUpdateProfileScreenState
    extends State<CustomerUpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

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

      await clientProvider.updateProfile(request);
      await clientProvider.getProfile(); // Refresh profile after creation

      if (mounted) {
        context.pop();
      }
    }
  }

  // Add this method to initialize controllers with existing data
  void _initializeControllers(Client client) {
    if (_fullNameController.text.isEmpty) {
      _fullNameController.text = client.fullName;
    }
    if (_addressController.text.isEmpty) {
      _addressController.text = client.address;
    }
    if (_phoneNumberController.text.isEmpty) {
      _phoneNumberController.text = client.contact.phoneNumber;
    }
    if (_facebookUrlController.text.isEmpty) {
      _facebookUrlController.text = client.contact.facebookUrl ?? '';
    }
    if (_messengerUrlController.text.isEmpty) {
      _messengerUrlController.text = client.contact.messengerUrl ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(leading: SizedBox()),
      body: Consumer<ClientProvider>(
        builder: (context, clientProvider, child) {
          final Client client = clientProvider.client;

          _initializeControllers(client);

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
                    'Edit Profile',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CustomText.body(
                    'Update your profile information',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                    maxLines: 3,
                    isRequired: true,
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
                    label: 'Facebook Profile (Optional)',
                    hintText: 'https://www.facebook.com/yourprofile',
                    controller: _facebookUrlController,
                    prefixIcon: Icons.facebook_outlined,
                    keyboardType: TextInputType.url,
                    validator: validateFacebookUrl,
                    isRequired: false,
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
                    isRequired: false,
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  CustomButton(
                    text: 'Update Profile',
                    onPressed: () => _handleSubmit(clientProvider),
                    icon: Icons.save_outlined,
                    isLoading: clientProvider.isLoading,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Cancel',
                    onPressed: () => context.pop(),
                    icon: Icons.cancel_outlined,
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
