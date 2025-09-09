import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/validate.dart';
import 'package:furcare_app/data/models/pet_models.dart';
import 'package:furcare_app/presentation/providers/pet_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_fields.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/common/default_snackbar.dart';
import 'package:provider/provider.dart';

class CompanionCreationScreen extends StatefulWidget {
  const CompanionCreationScreen({super.key});

  @override
  State<CompanionCreationScreen> createState() =>
      _CompanionCreationScreenState();
}

class _CompanionCreationScreenState extends State<CompanionCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specieController = TextEditingController();

  String _selectedGender = 'Male';
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  // Track the last error message shown to prevent duplicate snackbars
  String? _lastShownErrorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _specieController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate(PetProvider petProvider) async {
    if (_formKey.currentState!.validate()) {
      _lastShownErrorMessage = null;

      final RequestPet pet = RequestPet(
        name: _nameController.text,
        specie: _specieController.text,
        gender: _selectedGender,
      );
      await petProvider.createPet(pet);

      if (mounted) {
        showCustomSnackBar(
          context,
          "${_nameController.text} was added successfully!",
        );
      }

      _resetForm();
    }
  }

  void _resetForm() {
    _nameController.clear();
    _specieController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                CustomText.title(
                  'New Pet',
                  size: AppTextSize.lg,
                  fontWeight: AppFontWeight.semibold.value,
                  color: theme.colorScheme.onSurface,
                ),

                const SizedBox(height: 8),

                CustomText.title(
                  'Fill in the details below to add your pet',
                  size: AppTextSize.sm,
                  fontWeight: AppFontWeight.normal.value,
                  color: theme.colorScheme.onSurface.withAlpha(179),
                ),

                const SizedBox(height: 32),

                // Name Field
                CustomInputField(
                  label: 'Name',
                  hintText: 'Enter pet name',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: validateCompanionName,
                  isRequired: true,
                ),

                const SizedBox(height: 20),

                // Species Field
                CustomInputField(
                  label: 'Species',
                  hintText: 'Enter pet species',
                  controller: _specieController,
                  prefixIcon: Icons.pets_outlined,
                  validator: validateSpecie,
                  isRequired: true,
                ),

                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.title(
                      'Gender',
                      size: AppTextSize.md,
                      fontWeight: AppFontWeight.semibold.value,
                      color: theme.colorScheme.onSurface,
                    ),

                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withAlpha(77),
                        ),
                      ),
                      child: Column(
                        children: _genderOptions.map((gender) {
                          return RadioListTile<String>(
                            title: CustomText.title(
                              gender,
                              size: AppTextSize.sm,
                              fontWeight: AppFontWeight.normal.value,
                              color: theme.colorScheme.onSurface,
                            ),
                            value: gender,
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            activeColor: theme.colorScheme.primary,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Action Buttons
                Consumer<PetProvider>(
                  builder: (context, petProvider, child) {
                    final hasError = petProvider.error != null;
                    if (hasError &&
                        petProvider.error != _lastShownErrorMessage) {
                      _lastShownErrorMessage = petProvider.error;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showCustomSnackBar(
                          context,
                          petProvider.error!,
                          isError: true,
                        );
                      });
                    }
                    return CustomButton(
                      text: "Submit",
                      onPressed: () => _handleCreate(petProvider),
                      isEnabled: true,
                      icon: Icons.pets_outlined,
                      isLoading: petProvider.isCreatingPet,
                    );
                  },
                ),
                const SizedBox(height: 16),
                CustomButton(
                  text: "Reset",
                  onPressed: () => _resetForm(),
                  isEnabled: true,
                  icon: Icons.refresh_rounded,
                  isOutlined: true,
                  isLoading: false,
                ),

                const SizedBox(height: 24),

                // Preview Section
                if (_nameController.text.isNotEmpty ||
                    _specieController.text.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withAlpha(77),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withAlpha(51),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.title(
                          'Preview',
                          size: AppTextSize.md,
                          fontWeight: AppFontWeight.semibold.value,
                          color: theme.colorScheme.onSurface,
                        ),

                        const SizedBox(height: 8),

                        if (_nameController.text.isNotEmpty)
                          CustomText.title(
                            'Name: ${_nameController.text}',
                            size: AppTextSize.sm,
                            fontWeight: AppFontWeight.normal.value,
                            color: theme.colorScheme.onSurface.withAlpha(204),
                          ),

                        if (_specieController.text.isNotEmpty)
                          CustomText.title(
                            'Species: ${_specieController.text}',
                            size: AppTextSize.sm,
                            fontWeight: AppFontWeight.normal.value,
                            color: theme.colorScheme.onSurface.withAlpha(204),
                          ),

                        CustomText.title(
                          'Gender: $_selectedGender',
                          size: AppTextSize.sm,
                          fontWeight: AppFontWeight.normal.value,
                          color: theme.colorScheme.onSurface.withAlpha(204),
                        ),
                      ],
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
