import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/core/utils/theme.dart';
import 'package:furcare_app/data/models/grooming/grooming_request.dart';
import 'package:furcare_app/data/models/pet_models.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';
import 'package:furcare_app/presentation/providers/appointment_provider.dart';
import 'package:furcare_app/presentation/providers/branch_provider.dart';
import 'package:furcare_app/presentation/providers/pet_service_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/dialog/custom_branch_selection_dialog.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_confirm_dialog.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class GroomingReceiptDialog extends StatefulWidget {
  final Pet? selectedPetObject;
  final String? selectedSchedule;
  final Set<String> selectedGroomingOptions;
  final Set<String> selectedGroomingPreferences;
  final bool? hasAllergy;
  final bool? isOnMedication;
  final bool? hasAntiRabbiesVaccination;

  const GroomingReceiptDialog({
    super.key,
    required this.selectedPetObject,
    required this.selectedSchedule,
    required this.selectedGroomingOptions,
    required this.selectedGroomingPreferences,
    required this.hasAllergy,
    required this.isOnMedication,
    required this.hasAntiRabbiesVaccination,
  });

  @override
  State<GroomingReceiptDialog> createState() => _GroomingReceiptDialogState();

  static void show({
    required BuildContext context,
    required Pet? selectedPetObject,
    required String? selectedSchedule,
    required Set<String> selectedGroomingOptions,
    required Set<String> selectedGroomingPreferences,
    required bool? hasAllergy,
    required bool? isOnMedication,
    required bool? hasAntiRabbiesVaccination,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GroomingReceiptDialog(
          selectedPetObject: selectedPetObject,
          selectedSchedule: selectedSchedule,
          selectedGroomingOptions: selectedGroomingOptions,
          selectedGroomingPreferences: selectedGroomingPreferences,
          hasAllergy: hasAllergy,
          isOnMedication: isOnMedication,
          hasAntiRabbiesVaccination: hasAntiRabbiesVaccination,
        );
      },
    );
  }
}

class _GroomingReceiptDialogState extends State<GroomingReceiptDialog> {
  bool isLoading = false;

  Future<void> _processAppointment() async {
    final branchProvider = context.read<BranchProvider>();
    final hasSelectedBranch = branchProvider.hasSelectedBranch;
    final selectedBranch = branchProvider.selectedBranch;

    if (!hasSelectedBranch) {
      context.pop();
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => BranchSelectionDialog(
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
        pet: widget.selectedPetObject?.id ?? "",
        groomingOptions: widget.selectedGroomingOptions.toList(),
        groomingPreferences: widget.selectedGroomingPreferences.toList(),
        hasAllergy: widget.hasAllergy!,
        hasAntiRabbiesVaccination: widget.hasAntiRabbiesVaccination ?? false,
        isOnMedication: widget.isOnMedication ?? false,
        scheduleCode: widget.selectedSchedule ?? "",
      );

      if (mounted) {
        context.read<AppointmentProvider>().createGroomingAppointment(payload);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: screenSize.width * 0.9,
          height: screenSize.height * 0.98,
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(26),
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
                            color: colorScheme.onSurface.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Scrollable Content Section
              Expanded(
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
                              widget.selectedPetObject?.name ?? 'Not Selected',
                            ),
                            _buildReceiptRow(
                              'Specie',
                              widget.selectedPetObject?.specie ?? 'N/A',
                            ),
                            _buildReceiptRow(
                              'Gender',
                              widget.selectedPetObject?.gender ?? 'N/A',
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
                                  (s) => s.code == widget.selectedSchedule,
                                  orElse: () => GroomingSchedule(
                                    code: '',
                                    schedule: '',
                                    price: 0,
                                    available: false,
                                  ),
                                );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (widget.selectedGroomingOptions.isNotEmpty)
                        _buildScrollableReceiptSection(
                          title: 'Grooming Options',
                          icon: Icons.wash,
                          content: Consumer<PetServiceProvider>(
                            builder: (context, petServiceProvider, child) {
                              final selectedOptions = petServiceProvider
                                  .groomingOptions
                                  .where(
                                    (option) => widget.selectedGroomingOptions
                                        .contains(option.code),
                                  )
                                  .toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: selectedOptions.map((option) {
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

                      if (widget.selectedGroomingOptions.isNotEmpty)
                        const SizedBox(height: 16),

                      // Grooming Preferences - Scrollable Section
                      if (widget.selectedGroomingPreferences.isNotEmpty)
                        _buildScrollableReceiptSection(
                          title: 'Preferences',
                          icon: Icons.content_cut,
                          content: Consumer<PetServiceProvider>(
                            builder: (context, petServiceProvider, child) {
                              final selectedPreferences = petServiceProvider
                                  .groomingPreferences
                                  .where(
                                    (pref) => widget.selectedGroomingPreferences
                                        .contains(pref.code),
                                  )
                                  .toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: selectedPreferences.map((preference) {
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

                      if (widget.selectedGroomingPreferences.isNotEmpty)
                        const SizedBox(height: 16),

                      // Total Price
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.primary.withAlpha(77),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText.body(
                              'TOTAL',
                              color: colorScheme.onErrorContainer,
                            ),
                            Consumer<PetServiceProvider>(
                              builder: (context, petServiceProvider, child) {
                                double totalPrice = 0;

                                // Add schedule price
                                final schedule = petServiceProvider
                                    .groomingSchedules
                                    .firstWhere(
                                      (s) => s.code == widget.selectedSchedule,
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
                                    in petServiceProvider.groomingOptions) {
                                  if (widget.selectedGroomingOptions.contains(
                                    option.code,
                                  )) {
                                    totalPrice += option.price;
                                  }
                                }

                                // Add grooming preferences price
                                for (final preference
                                    in petServiceProvider.groomingPreferences) {
                                  if (widget.selectedGroomingPreferences
                                      .contains(preference.code)) {
                                    totalPrice += preference.price;
                                  }
                                }

                                return CustomText.body(
                                  CurrencyUtils.toPHP(totalPrice),
                                  fontWeight: AppFontWeight.bold.value,
                                  color: colorScheme.onErrorContainer,
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

              // Action Buttons Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: CustomButton(
                  text: 'Submit',
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      await _processAppointment();
                      if (context.mounted) {
                        ConfirmationDialog.show(
                          context: context,
                          title: 'Appointment Booked!',
                          message:
                              'Your grooming appointment has been successfully booked.',
                          confirmText: 'OK',
                          confirmColor: ThemeHelper.getOnBackgroundTextColor(
                            context,
                          ),
                          cancelText: "",
                          onConfirm: () {
                            Navigator.of(context)
                              ..pop() // Close dialog
                              ..pop(); // Close booking screen
                            context.push(CustomerRoute.me.grooming);
                          },
                        );
                      }
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  isOutlined: true,
                  icon: Icons.book_outlined,
                  isLoading: isLoading,
                  isEnabled: !isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
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
        border: Border.all(color: colorScheme.outline.withAlpha(51), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withAlpha(77),
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
                  color: colorScheme.onSurface.withAlpha(153),
                ),
              ],
            ),
          ),

          // Scrollable Content with hint
          Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: content,
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
        border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
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
}
