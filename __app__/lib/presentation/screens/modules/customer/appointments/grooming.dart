import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/padding_constant.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';
import 'package:flutter_application_1/core/helpers/theme.dart';
import 'package:flutter_application_1/core/helpers/widget_helpers.dart';
import 'package:flutter_application_1/data/models/appointment_models.dart';
import 'package:flutter_application_1/data/models/pet_models.dart';
import 'package:flutter_application_1/data/models/pet_service.models.dart';
import 'package:flutter_application_1/presentation/providers/application_provider.dart';
import 'package:flutter_application_1/presentation/providers/branch_provider.dart';
import 'package:flutter_application_1/presentation/providers/pet_provider.dart';
import 'package:flutter_application_1/presentation/providers/pet_service_provider.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/appointments/widgets/grooming/skeleton.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_appbar.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_branch_selection_modal.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_button.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_confirm_dialog.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GroomingAppointmentScreen extends StatefulWidget {
  const GroomingAppointmentScreen({super.key});

  @override
  State<GroomingAppointmentScreen> createState() =>
      _GroomingAppointmentScreenState();
}

class _GroomingAppointmentScreenState extends State<GroomingAppointmentScreen> {
  String? selectedSchedule;
  Set<String> selectedGroomingOptions = {};
  Set<String> selectedGroomingPreferences = {};
  String? selectedPet;
  Pet? selectedPetObject;
  bool? hasAllergy;
  bool? isOnMedication;
  bool? hasAntiRabbiesVaccination;

  bool isPetAccordionExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        _handleGetPets();
        _handleGetSchedules();
        _handleGetOptions();
        _handleGetPreferences();
      }
    });
  }

  void _handleGetPets() {
    context.read<PetProvider>().getPets();
  }

  void _handleGetSchedules() {
    context.read<PetServiceProvider>().getGroomingSchedules();
  }

  void _handleGetOptions() {
    context.read<PetServiceProvider>().getGroomingOptions();
  }

  void _handleGetPreferences() {
    context.read<PetServiceProvider>().getGroomingPreferences();
  }

  void _bookAppointment() {
    _showReceiptDialog();
  }

  double get totalPrice {
    final schedules = context.read<PetServiceProvider>().groomingSchedules;
    final groomingOptions = context.read<PetServiceProvider>().groomingOptions;
    final groomingPreferences = context
        .read<PetServiceProvider>()
        .groomingPreferences;

    double total = 0;

    // Add schedule price
    final schedule = schedules.firstWhere(
      (s) => s.code == selectedSchedule,
      orElse: () =>
          GroomingSchedule(code: "", schedule: "", price: 0, available: false),
    );
    total += schedule.price;

    // Add grooming options price
    for (String optionCode in selectedGroomingOptions) {
      final option = groomingOptions.firstWhere(
        (o) => o.code == optionCode,
        orElse: () =>
            GroomingOptions(available: true, code: "", name: "", price: 0),
      );
      total += option.price;
    }

    // Add grooming preferences price
    for (String prefCode in selectedGroomingPreferences) {
      final pref = groomingPreferences.firstWhere(
        (p) => p.code == prefCode,
        orElse: () =>
            GroomingPreference(code: "", name: "", price: 0, available: false),
      );
      total += pref.price;
    }

    return total;
  }

  bool _canBookAppointment() {
    return selectedPet != null &&
        selectedSchedule != null &&
        selectedGroomingOptions.isNotEmpty &&
        hasAllergy != null &&
        isOnMedication != null &&
        hasAntiRabbiesVaccination != null;
  }

  Future<void> _processAppointment() async {
    final branchProvider = context.read<BranchProvider>();
    final hasSelectedBranch = branchProvider.hasSelectedBranch;
    final selectedBranch = branchProvider.selectedBranch;

    if (!hasSelectedBranch) {
      context.pop();
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => BranchSelectionModal(
          onBranchSelected: () {
            // Optional: Add any additional logic after branch selection
            // For example, refresh data or show a success message
          },
        ),
      );
    }
    if (selectedBranch != null) {
      final payload = GroomingAppointmentRequest(
        branch: branchProvider.selectedBranch!.id,
        pet: selectedPetObject?.id ?? "",
        groomingOptions: selectedGroomingOptions.toList(),
        groomingPreferences: selectedGroomingPreferences.toList(),
        hasAllergy: hasAllergy!,
        hasAntiRabbiesVaccination: hasAntiRabbiesVaccination ?? false,
        isOnMedication: isOnMedication ?? false,
        scheduleCode: selectedSchedule ?? "",
      );

      print('Payload: $payload');

      if (mounted) {
        context.read<AppointmentProvider>().createGroomingAppointment(payload);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: "Grooming Appointment",
        titleTextStyle: TextStyle(
          fontSize: AppTextSize.sm.size,
          fontWeight: AppFontWeight.semibold.value,
        ),
      ),
      body: SingleChildScrollView(
        padding: kDefaultBodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Selection Section
            _buildPetAccordionCard(theme),
            const SizedBox(height: 16),

            // Schedule Selection Section
            _buildSectionCard(
              title: "Choose Schedule",
              icon: Icons.schedule,
              child: Consumer<PetServiceProvider>(
                builder: (context, petServiceProvider, child) {
                  if (petServiceProvider.isFetchingGroomingSchedules) {
                    return GroomingScheduleSkeleton();
                  }
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: petServiceProvider.groomingSchedules.map((
                      schedule,
                    ) {
                      final isSelected = selectedSchedule == schedule.code;
                      return FilterChip(
                        selected: isSelected,
                        onSelected: schedule.available
                            ? (selected) {
                                setState(() {
                                  selectedSchedule = selected
                                      ? schedule.code
                                      : null;
                                });
                              }
                            : null,
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText.body(
                              schedule.schedule,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            CustomText.body(
                              'PHP ${schedule.price}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: schedule.available
                            ? null
                            : Colors.grey.withOpacity(0.3),
                        selectedColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.2),
                      );
                    }).toList(),
                  );
                },
              ),
              theme: theme,
            ),
            const SizedBox(height: 16),

            // Grooming Options Section
            _buildSectionCard(
              title: "Grooming Options",
              icon: Icons.wash,
              child: Consumer<PetServiceProvider>(
                builder: (context, petServiceProvider, child) {
                  if (petServiceProvider.isFetchingGroomingOptions) {
                    return GroomingOptionsSkeleton();
                  }
                  return Column(
                    children: petServiceProvider.groomingOptions.map((option) {
                      final isSelected = selectedGroomingOptions.contains(
                        option.code,
                      );
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: option.available
                              ? (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedGroomingOptions.add(option.code);
                                    } else {
                                      selectedGroomingOptions.remove(
                                        option.code,
                                      );
                                    }
                                  });
                                }
                              : null,
                          title: CustomText.body(
                            option.name,
                            fontWeight: AppFontWeight.semibold.value,
                          ),
                          subtitle: CustomText.body(
                            'PHP ${option.price}',
                            size: AppTextSize.xs,
                          ),
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              theme: theme,
            ),
            const SizedBox(height: 16),

            // Grooming Preferences Section
            _buildSectionCard(
              title: "Grooming Preferences",
              icon: Icons.content_cut,
              child: Consumer<PetServiceProvider>(
                builder: (context, petServiceProvider, child) {
                  if (petServiceProvider.isFetchingGroomingOptions) {
                    return GroomingOptionsSkeleton();
                  }
                  return Column(
                    children: petServiceProvider.groomingPreferences.map((
                      preference,
                    ) {
                      final isSelected = selectedGroomingPreferences.contains(
                        preference.code,
                      );
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.withOpacity(0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: preference.available
                              ? (value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedGroomingPreferences.add(
                                        preference.code,
                                      );
                                    } else {
                                      selectedGroomingPreferences.remove(
                                        preference.code,
                                      );
                                    }
                                  });
                                }
                              : null,
                          title: CustomText.body(preference.name),
                          subtitle: preference.price > 0
                              ? CustomText.body(
                                  'PHP ${preference.price}',
                                  size: AppTextSize.xs,
                                  fontWeight: AppFontWeight.semibold.value,
                                )
                              : const Text(
                                  'Free',
                                  style: TextStyle(color: Colors.green),
                                ),
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              theme: theme,
            ),
            const SizedBox(height: 16),

            // Health Information Section
            _buildSectionCard(
              title: "Health Information",
              icon: Icons.health_and_safety,
              child: _buildHealthInformation(),
              theme: theme,
            ),
            const SizedBox(height: 24),

            // Price Summary and Book Button
            _buildPriceSummaryAndButton(theme),
          ],
        ),
      ),
    );
  }

  void _showReceiptDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;

            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.all(0),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // close icon
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Close button in top-right corner
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close_outlined),
                            ),
                          ),
                          // Main content
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8), // spacing from top
                              Icon(
                                Icons.receipt_long,
                                size: 48,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Appointment Summary',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Please review your booking details',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Content - Make this scrollable
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pet Information
                            _buildReceiptSection(
                              title: 'Pet Information',
                              icon: Icons.pets,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildReceiptRow(
                                    'Pet Name',
                                    selectedPetObject?.name ?? 'Not Selected',
                                  ),
                                  _buildReceiptRow(
                                    'Specie',
                                    selectedPetObject?.specie ?? 'N/A',
                                  ),
                                  _buildReceiptRow(
                                    'Gender',
                                    selectedPetObject?.gender ?? 'N/A',
                                  ),
                                ],
                              ),
                              theme: theme,
                            ),

                            const SizedBox(height: 16),

                            // Schedule Information
                            _buildReceiptSection(
                              title: 'Schedule',
                              icon: Icons.schedule,
                              content: Consumer<PetServiceProvider>(
                                builder: (context, petServiceProvider, child) {
                                  final schedule = petServiceProvider
                                      .groomingSchedules
                                      .firstWhere(
                                        (s) => s.code == selectedSchedule,
                                        orElse: () => GroomingSchedule(
                                          code: '',
                                          schedule: '',
                                          price: 0,
                                          available: false,
                                        ),
                                      );

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildReceiptRow(
                                        'Date & Time',
                                        schedule.schedule,
                                      ),
                                      _buildReceiptRow(
                                        'Base Price',
                                        'PHP ${schedule.price}',
                                      ),
                                    ],
                                  );
                                },
                              ),
                              theme: theme,
                            ),

                            const SizedBox(height: 16),

                            // Grooming Options - Scrollable Section
                            if (selectedGroomingOptions.isNotEmpty)
                              _buildScrollableReceiptSection(
                                title: 'Grooming Options',
                                icon: Icons.wash,
                                content: Consumer<PetServiceProvider>(
                                  builder:
                                      (context, petServiceProvider, child) {
                                        final selectedOptions =
                                            petServiceProvider.groomingOptions
                                                .where(
                                                  (option) =>
                                                      selectedGroomingOptions
                                                          .contains(
                                                            option.code,
                                                          ),
                                                )
                                                .toList();

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: selectedOptions.map((
                                            option,
                                          ) {
                                            return _buildReceiptRow(
                                              option.name,
                                              'PHP ${option.price}',
                                            );
                                          }).toList(),
                                        );
                                      },
                                ),
                                theme: theme,
                                maxHeight: 120, // Limit height for scrolling
                              ),

                            if (selectedGroomingOptions.isNotEmpty)
                              const SizedBox(height: 16),

                            // Grooming Preferences - Scrollable Section
                            if (selectedGroomingPreferences.isNotEmpty)
                              _buildScrollableReceiptSection(
                                title: 'Grooming Preferences',
                                icon: Icons.content_cut,
                                content: Consumer<PetServiceProvider>(
                                  builder: (context, petServiceProvider, child) {
                                    final selectedPreferences =
                                        petServiceProvider.groomingPreferences
                                            .where(
                                              (pref) =>
                                                  selectedGroomingPreferences
                                                      .contains(pref.code),
                                            )
                                            .toList();

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: selectedPreferences.map((
                                        preference,
                                      ) {
                                        return _buildReceiptRow(
                                          preference.name,
                                          preference.price > 0
                                              ? 'PHP ${preference.price}'
                                              : 'Free',
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                                theme: theme,
                                maxHeight: 120, // Limit height for scrolling
                              ),

                            if (selectedGroomingPreferences.isNotEmpty)
                              const SizedBox(height: 16),

                            // Total Price
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withOpacity(
                                  0.3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: colorScheme.primary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  Consumer<PetServiceProvider>(
                                    builder: (context, petServiceProvider, child) {
                                      double totalPrice = 0;

                                      // Add schedule price
                                      final schedule = petServiceProvider
                                          .groomingSchedules
                                          .firstWhere(
                                            (s) => s.code == selectedSchedule,
                                            orElse: () => GroomingSchedule(
                                              available: true,
                                              code: "",
                                              price: 0,
                                              schedule: "",
                                            ),
                                          );

                                      totalPrice += schedule.price;

                                      // Add grooming options price
                                      for (final option
                                          in petServiceProvider
                                              .groomingOptions) {
                                        if (selectedGroomingOptions.contains(
                                          option.code,
                                        )) {
                                          totalPrice += option.price;
                                        }
                                      }

                                      // Add grooming preferences price
                                      for (final preference
                                          in petServiceProvider
                                              .groomingPreferences) {
                                        if (selectedGroomingPreferences
                                            .contains(preference.code)) {
                                          totalPrice += preference.price;
                                        }
                                      }

                                      return Text(
                                        'PHP ${totalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Action Buttons
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          // OutlinedButton(
                          //   onPressed: isLoading
                          //       ? null
                          //       : () {
                          //           Navigator.of(context).pop();
                          //         },
                          //   style: OutlinedButton.styleFrom(
                          //     padding: const EdgeInsets.symmetric(vertical: 12),
                          //     side: BorderSide(color: colorScheme.outline),
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //   ),
                          //   child: Text(
                          //     'Cancel',
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color: colorScheme.onSurface,
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 12),
                          CustomButton(
                            text: 'Submit',
                            onPressed: () async {
                              setDialogState(() {
                                isLoading = true;
                              });

                              try {
                                await _processAppointment();
                                if (context.mounted) {
                                  context.pop();
                                  ConfirmationDialog.show(
                                    context: context,
                                    title: 'Appointment Booked!',
                                    message:
                                        'Your grooming appointment has been successfully booked.',
                                    confirmText: 'OK',
                                    confirmColor:
                                        ThemeHelper.getOnBackgroundTextColor(
                                          context,
                                        ),
                                    cancelText: "",
                                  );
                                }
                              } catch (e) {
                                setDialogState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            isOutlined: true,
                            icon: Icons.book_outlined,
                            isLoading: isLoading,
                            isEnabled: !isLoading,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper method for scrollable sections
  Widget _buildScrollableReceiptSection({
    required String title,
    required IconData icon,
    required Widget content,
    required ThemeData theme,
    double maxHeight = 120,
  }) {
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                CustomText.body(title, fontWeight: AppFontWeight.bold.value),
                const Spacer(),
                Icon(
                  Icons.unfold_more,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ],
            ),
          ),

          // Scrollable Content with hint
          Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: content,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build receipt sections
  Widget _buildReceiptSection({
    required String title,
    required IconData icon,
    required Widget content,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              CustomText.body(title, fontWeight: AppFontWeight.black.value),
            ],
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  // Helper method to build receipt rows
  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 160,
            child: CustomText.body(
              label,
              fontWeight: AppFontWeight.bold.value,
              size: AppTextSize.xs,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(
            width: 100,
            child: CustomText.body(
              value,
              size: AppTextSize.xs,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetAccordionCard(ThemeData theme) {
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        Pet selectedPetData = Pet(id: "", name: "", specie: "", gender: "");
        if (petProvider.isFetchingPets) {
          return const CompanionSelectionSkeleton();
        }

        if (petProvider.pets.isNotEmpty) {
          selectedPetData = petProvider.pets.firstWhere(
            (pet) => pet.id == selectedPet,
            orElse: () => petProvider.pets.first,
          );
        }

        if (mounted && selectedPet != selectedPetData.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                selectedPetObject = selectedPetData;
                selectedPet = selectedPetData.id;
              });
            }
          });
        }

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Accordion Header
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isPetAccordionExpanded = !isPetAccordionExpanded;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(getSpecieIcon(selectedPetData.specie)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.title("Companion", size: AppTextSize.md),
                            if (!isPetAccordionExpanded) ...[
                              const SizedBox(height: 4),
                              CustomText.body(
                                "${selectedPetData.name} (${selectedPetData.specie})",
                                size: AppTextSize.sm,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: AnimatedRotation(
                          turns: isPetAccordionExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Animated Accordion Content - Top to Bottom Slide
                ClipRect(
                  child: AnimatedAlign(
                    alignment: Alignment.topCenter,
                    heightFactor: isPetAccordionExpanded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: isPetAccordionExpanded ? 1.0 : 0.0,
                      duration: Duration(
                        milliseconds: isPetAccordionExpanded ? 350 : 200,
                      ),
                      curve: isPetAccordionExpanded
                          ? Curves.easeIn
                          : Curves.easeOut,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Column(
                            children: petProvider.pets.map((pet) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: selectedPet == pet.id
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.withOpacity(0.3),
                                    width: selectedPet == pet.id ? 2 : 1,
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.1),
                                    child: Icon(getSpecieIcon(pet.specie)),
                                  ),
                                  title: CustomText.body(
                                    pet.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: CustomText.body(
                                    pet.specie,
                                    size: AppTextSize.xs,
                                  ),
                                  trailing: Radio<String>(
                                    value: pet.id,
                                    groupValue: selectedPet,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPet = value;
                                        isPetAccordionExpanded =
                                            false; // Close accordion after selection
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedPet = pet.id;
                                      isPetAccordionExpanded =
                                          false; // Close accordion after selection
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                CustomText.title(title, size: AppTextSize.md),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildHealthInformation() {
    return Column(
      children: [
        _buildHealthQuestion(
          "Does your pet have any allergies?",
          hasAllergy,
          (value) => setState(() => hasAllergy = value),
        ),
        const SizedBox(height: 16),
        _buildHealthQuestion(
          "Is your pet on any medication?",
          isOnMedication,
          (value) => setState(() => isOnMedication = value),
        ),
        const SizedBox(height: 16),
        _buildHealthQuestion(
          "Does your pet have anti-rabies vaccination?",
          hasAntiRabbiesVaccination,
          (value) => setState(() => hasAntiRabbiesVaccination = value),
        ),
      ],
    );
  }

  Widget _buildHealthQuestion(
    String question,
    bool? value,
    Function(bool?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.body(question),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: CustomText.body(
                  'Yes',
                  fontWeight: AppFontWeight.bold.value,
                ),
                value: true,
                groupValue: value,
                onChanged: onChanged,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: CustomText.body(
                  'No',
                  fontWeight: AppFontWeight.bold.value,
                ),
                value: false,
                groupValue: value,
                onChanged: onChanged,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSummaryAndButton(ThemeData theme) {
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText.body(
                  'PHP ${totalPrice.toStringAsFixed(2)}',
                  size: AppTextSize.md,
                  fontWeight: AppFontWeight.black.value,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Book Appointment',
          onPressed: _canBookAppointment() ? _bookAppointment : null,
          // isLoading: authProvider.isLoading,
          icon: Icons.book_outlined,
          // isEnabled: !authProvider.isLoading,
        ),
      ],
    );
  }
}
