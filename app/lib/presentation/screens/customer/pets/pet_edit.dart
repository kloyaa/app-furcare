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
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CompanionEdit extends StatefulWidget {
  const CompanionEdit({super.key});

  @override
  State<CompanionEdit> createState() => _CompanionEditState();
}

class _CompanionEditState extends State<CompanionEdit> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _specieController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedSize = 'Small';

  final List<String> _genderOptions = ['Male', 'Female'];
  final List<String> _petSizeOptions = ['sm', 'md', 'lg'];

  String? _lastShownErrorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPetData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specieController.dispose();
    super.dispose();
  }

  void _loadPetData() {
    final extras = GoRouterState.of(context).extra as Pet;
    _nameController.text = extras.name;
    _specieController.text = extras.specie;
    setState(() {
      _selectedGender = extras.gender;
      _selectedSize = extras.size;
    });
  }

  Future<void> _handleEdit(PetProvider provider) async {
    final extras = GoRouterState.of(context).extra as Pet;
    if (_formKey.currentState!.validate()) {
      _lastShownErrorMessage = null;
      final UpdatePet pet = UpdatePet(
        id: extras.id,
        name: _nameController.text,
        specie: _specieController.text,
        gender: _selectedGender,
        size: _selectedSize,
      );
      await provider.updatePet(pet);
      if (mounted) {
        showCustomSnackBar(
          context,
          "${_nameController.text} was updated successfully!",
        );
      }
    }
  }

  String _readableSize(String size) {
    switch (size) {
      case 'sm':
        return 'Small';
      case 'md':
        return 'Medium';
      default:
        return 'Large';
    }
  }

  void _resetForm() {
    _nameController.clear();
    _specieController.clear();
    setState(() {
      _selectedGender = 'Male';
      _selectedSize = 'Small';
    });
  }

  Widget _buildRadioGroup({
    required String title,
    required List<String> options,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.title(
          title,
          size: AppTextSize.md,
          fontWeight: AppFontWeight.semibold.value,
          color: theme.colorScheme.onSurface,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(77)),
          ),
          child: Column(
            children: options.map((option) {
              return RadioListTile<String>(
                title: CustomText.title(
                  title == "Size" ? _readableSize(option) : option,
                  size: AppTextSize.sm,
                  fontWeight: AppFontWeight.normal.value,
                  color: theme.colorScheme.onSurface,
                ),
                value: option,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: theme.colorScheme.primary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  // Inside the _CompanionEditState class

  void _showPreviewDialog(PetProvider provider) {
    final extras = GoRouterState.of(context).extra as Pet;

    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText.title(
          'Changes',
          size: AppTextSize.mlg,
          fontWeight: AppFontWeight.semibold.value,
          color: theme.colorScheme.onSurface,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.title(
              'Name',
              size: AppTextSize.sm,
              fontWeight: AppFontWeight.bold.value,
              color: theme.colorScheme.onSurface.withAlpha(204),
            ),
            CustomText.title(
              '${extras.name} ➝ ${_nameController.text}',
              size: AppTextSize.md,
              fontWeight: AppFontWeight.normal.value,
              color: theme.colorScheme.onSurface.withAlpha(204),
            ),

            const SizedBox(height: 8),
            CustomText.title(
              'Specie',
              size: AppTextSize.sm,
              fontWeight: AppFontWeight.bold.value,
              color: theme.colorScheme.onSurface.withAlpha(204),
            ),
            CustomText.title(
              '${extras.specie} ➝ ${_specieController.text}',
              size: AppTextSize.md,
              fontWeight: AppFontWeight.normal.value,
              color: theme.colorScheme.onSurface.withAlpha(204),
            ),
            const SizedBox(height: 8),
            CustomText.title(
              'Gender',
              size: AppTextSize.sm,
              fontWeight: AppFontWeight.bold.value,
              color: theme.colorScheme.onSurface.withAlpha(204),
            ),
            CustomText.title(
              '${extras.gender} ➝ $_selectedGender',
              size: AppTextSize.md,
              fontWeight: AppFontWeight.normal.value,
              color: theme.colorScheme.onSurface.withAlpha(204),
            ),
            const SizedBox(height: 8),
            CustomText.title(
              'Size',
              size: AppTextSize.sm,
              fontWeight: AppFontWeight.bold.value,
              color: theme.colorScheme.onSurface.withAlpha(204),
            ),
            CustomText.title(
              '${_readableSize(extras.size)} ➝ ${_readableSize(_selectedSize)}',
              size: AppTextSize.md,
              fontWeight: AppFontWeight.normal.value,
              color: theme.colorScheme.onSurface.withAlpha(204),
            ),
          ],
        ),
        actions: [
          CustomButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
            isOutlined: true,
            isEnabled: true,
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Confirm',
            onPressed: () {
              Navigator.pop(context);
              _handleEdit(provider);
            },
            isEnabled: !provider.isUpdatingPet,
            isLoading: provider.isUpdatingPet,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.title(
                  'Edit Companion',
                  size: AppTextSize.lg,
                  fontWeight: AppFontWeight.semibold.value,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(height: 8),
                CustomText.title(
                  'Update your pet’s information',
                  size: AppTextSize.sm,
                  fontWeight: AppFontWeight.normal.value,
                  color: theme.colorScheme.onSurface.withAlpha(179),
                ),
                const SizedBox(height: 32),
                CustomInputField(
                  label: 'Name',
                  hintText: 'Enter pet name',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: validateCompanionName,
                  isRequired: true,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  label: 'Species',
                  hintText: 'Enter pet species',
                  controller: _specieController,
                  prefixIcon: Icons.pets_outlined,
                  validator: validateSpecie,
                  isRequired: true,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                _buildRadioGroup(
                  title: 'Gender',
                  options: _genderOptions,
                  groupValue: _selectedGender,
                  onChanged: (v) => setState(() => _selectedGender = v!),
                ),
                const SizedBox(height: 20),
                _buildRadioGroup(
                  title: 'Size',
                  options: _petSizeOptions,
                  groupValue: _selectedSize,
                  onChanged: (v) => setState(() => _selectedSize = v!),
                ),
                const SizedBox(height: 32),
                Consumer<PetProvider>(
                  builder: (context, provider, child) {
                    if (provider.error != null &&
                        provider.error != _lastShownErrorMessage) {
                      _lastShownErrorMessage = provider.error;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        showCustomSnackBar(
                          context,
                          provider.error!,
                          isError: true,
                        );
                      });
                    }
                    return CustomButton(
                      text: "Submit",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _lastShownErrorMessage = null;
                          _showPreviewDialog(provider);
                        }
                      },
                      isEnabled: !provider.isUpdatingPet,
                      icon: Icons.pets_outlined,
                      isLoading: provider.isUpdatingPet,
                    );
                  },
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
