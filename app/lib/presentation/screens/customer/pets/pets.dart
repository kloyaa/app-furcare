import 'package:flutter/material.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/theme.dart';
import 'package:furcare_app/core/utils/widget.dart';
import 'package:furcare_app/data/models/pet_models.dart';
import 'package:furcare_app/presentation/providers/pet_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  @override
  void initState() {
    super.initState();
    // Load pets when screen initializes
    Future.microtask(() {
      if (mounted) {
        context.read<PetProvider>().getPets();
      }
    });
  }

  void _handleNavigateCompanionCreationScreen() {
    context.push(CustomerRoute.createPet);
  }

  void _handleEditPet(Pet pet) {
    Navigator.pop(context); // Close modal first
    context.push(CustomerRoute.editPet, extra: pet);

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing ${pet.name}...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleRemovePet(Pet pet) {
    Navigator.pop(context); // Close modal first
    _showRemoveConfirmationDialog(pet);
  }

  void _showPetOptionsDialog(Pet pet) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withAlpha(26),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pet header with avatar
                Container(
                  padding: const EdgeInsets.all(36),
                  child: Row(
                    children: [
                      _buildPetAvatar(pet, theme),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.body(
                              pet.name,
                              size: AppTextSize.md,
                              fontWeight: AppFontWeight.bold.value,
                            ),
                            const SizedBox(height: 4),
                            CustomText.subtitle(
                              '${pet.specie} • ${pet.gender}',
                              size: AppTextSize.sm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withAlpha(51),
                ),

                // Action buttons
                Column(
                  children: [
                    // Edit option
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _handleEditPet(pet),
                        borderRadius: BorderRadius.circular(0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: theme.colorScheme.onPrimaryContainer,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText.body(
                                      'Edit ${pet.name}',
                                      fontWeight: AppFontWeight.bold.value,
                                    ),
                                    const SizedBox(height: 2),
                                    CustomText.body(
                                      'Update pet information',
                                      size: AppTextSize.xs,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: theme.colorScheme.onSurface.withAlpha(
                                  102,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Divider
                    Divider(
                      height: 1,
                      color: theme.colorScheme.outline.withAlpha(26),
                    ),

                    // Remove option
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _handleRemovePet(pet),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  color: theme.colorScheme.onErrorContainer,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText.body(
                                      'Remove ${pet.name}',
                                      fontWeight: AppFontWeight.bold.value,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 2),
                                    CustomText.body(
                                      'Permanently delete this pet',
                                      size: AppTextSize.xs,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: theme.colorScheme.onSurface.withAlpha(
                                  102,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRemoveConfirmationDialog(Pet pet) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withAlpha(26),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Warning icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer.withAlpha(51),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          size: 48,
                          color: theme.colorScheme.error,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Title
                      CustomText(
                        'Remove ${pet.name}?',
                        fontWeight: AppFontWeight.bold.value,
                        size: AppTextSize.mlg,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Message
                      CustomText.body(
                        'This action cannot be undone. ${pet.name} will be permanently removed from your pet list.',
                        size: AppTextSize.xs,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        children: [
                          // Cancel button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: theme.colorScheme.outline.withAlpha(
                                    128,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Remove button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      setDialogState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        await _processPetRemoval(pet);
                                        // Only pop after successful completion
                                        if (context.mounted) {
                                          context.pop();
                                        }
                                      } catch (e) {
                                        // Handle error if needed
                                        setDialogState(() {
                                          isLoading = false;
                                        });
                                        // You might want to show an error message here
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.error,
                                foregroundColor: theme.colorScheme.onError,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: isLoading
                                  ? SpinKitThreeBounce(
                                      color:
                                          ThemeHelper.getOnBackgroundTextColor(
                                            context,
                                          ),
                                      size: 12.0,
                                    )
                                  : const Text(
                                      'Remove',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _processPetRemoval(Pet pet) async {
    if (mounted) {
      await context.read<PetProvider>().deletePet(pet.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        leading: SizedBox(),
        showThemeToggle: false,
        actions: [
          IconButton(
            onPressed: () => context.read<PetProvider>().getPets(),
            icon: Icon(Icons.refresh_rounded, color: theme.colorScheme.primary),
          ),
        ],
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Consumer<PetProvider>(
        builder: (context, petProvider, child) {
          if (petProvider.isFetchingPets) {
            return _buildLoadingSkeletonState(theme);
          }
          return RefreshIndicator(
            onRefresh: () => context.read<PetProvider>().getPets(),
            child: ListView.builder(
              padding: kDefaultBodyPadding,
              itemCount: petProvider.pets.length,
              itemBuilder: (context, index) {
                final pet = petProvider.pets[index];
                return _buildPetCard(pet, theme, isDark);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "pet-fab",
        onPressed: () => _handleNavigateCompanionCreationScreen(),
        icon: const Icon(Icons.add),
        label: const Text('Pet'),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildLoadingSkeletonState(ThemeData theme) {
    return ListView.builder(
      padding: kDefaultBodyPadding,
      itemCount: 6, // Show 6 skeleton items
      itemBuilder: (context, index) {
        return _buildSkeletonCard(theme, index);
      },
    );
  }

  Widget _buildSkeletonCard(ThemeData theme, int index) {
    // Add slight delays to create a wave effect
    return AnimatedContainer(
      duration: Duration(milliseconds: 100 * index),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha(26),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar skeleton with shimmer
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.onSurface.withAlpha(26),
                  theme.colorScheme.onSurface.withAlpha(13),
                  theme.colorScheme.onSurface.withAlpha(26),
                ],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name skeleton
                Container(
                  height: 18,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.onSurface.withAlpha(26),
                        theme.colorScheme.onSurface.withAlpha(13),
                        theme.colorScheme.onSurface.withAlpha(26),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Chips skeleton
                Row(
                  children: [
                    Container(
                      height: 24,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.onSurface.withAlpha(20),
                            theme.colorScheme.onSurface.withAlpha(10),
                            theme.colorScheme.onSurface.withAlpha(20),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 24,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.onSurface.withAlpha(20),
                            theme.colorScheme.onSurface.withAlpha(10),
                            theme.colorScheme.onSurface.withAlpha(20),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arrow skeleton
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.onSurface.withAlpha(20),
                  theme.colorScheme.onSurface.withAlpha(10),
                  theme.colorScheme.onSurface.withAlpha(20),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetCard(Pet pet, ThemeData theme, bool isDark) {
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withAlpha(26), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPetOptionsDialog(pet), // Changed to use dialog
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildPetAvatar(pet, theme),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildInfoChip(
                            pet.specie,
                            Icons.category_outlined,
                            theme,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            pet.gender,
                            _getGenderIcon(pet.gender),
                            theme,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert_rounded,
                  color: theme.colorScheme.onSurface.withAlpha(102),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetAvatar(Pet pet, ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        getSpecieIcon(pet.specie),
        size: 32,
        color: theme.colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getGenderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Icons.male_rounded;
      case 'female':
        return Icons.female_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }
}
