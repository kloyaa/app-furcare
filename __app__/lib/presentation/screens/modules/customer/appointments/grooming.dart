import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/padding_constant.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';
import 'package:flutter_application_1/core/helpers/formatters.dart';
import 'package:flutter_application_1/core/helpers/widget_helpers.dart';
import 'package:flutter_application_1/data/models/pet_models.dart';
import 'package:flutter_application_1/data/models/pet_service.models.dart';
import 'package:flutter_application_1/presentation/providers/pet_provider.dart';
import 'package:flutter_application_1/presentation/providers/pet_service_provider.dart';
import 'package:flutter_application_1/presentation/screens/modules/customer/appointments/widgets/grooming/skeleton.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_appbar.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_button.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_text.dart';
import 'package:flutter_application_1/presentation/widgets/dialog/custom_grooming_receipt_dialog.dart';
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
    GroomingReceiptDialog.show(
      context: context,
      selectedPetObject: selectedPetObject,
      selectedSchedule: selectedSchedule,
      selectedGroomingOptions: selectedGroomingOptions,
      selectedGroomingPreferences: selectedGroomingPreferences,
      hasAllergy: hasAllergy,
      isOnMedication: isOnMedication,
      hasAntiRabbiesVaccination: hasAntiRabbiesVaccination,
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
          color: theme.colorScheme.errorContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText.body(
                  'TOTAL',
                  color: theme.colorScheme.onErrorContainer,
                  fontWeight: AppFontWeight.bold.value,
                ),
                CustomText.body(
                  formatToPhpCurrency(totalPrice),
                  size: AppTextSize.mlg,
                  color: theme.colorScheme.onErrorContainer,
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
