import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/padding_constant.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';
import 'package:flutter_application_1/core/helpers/theme.dart';
import 'package:flutter_application_1/data/models/pet_models.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_appbar.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_button.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_confirm_dialog.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_text.dart';

class GroomingAppointmentScreen extends StatefulWidget {
  const GroomingAppointmentScreen({super.key});

  @override
  State<GroomingAppointmentScreen> createState() =>
      _GroomingAppointmentScreenState();
}

class _GroomingAppointmentScreenState extends State<GroomingAppointmentScreen> {
  // Data models
  final List<Schedule> schedules = [
    Schedule(
      code: "SCHEDULE_1",
      schedule: "08:00 AM - 09:00 AM",
      price: 30,
      available: true,
    ),
    Schedule(
      code: "SCHEDULE_2",
      schedule: "10:00 AM - 11:00 AM",
      price: 30,
      available: true,
    ),
    Schedule(
      code: "SCHEDULE_3",
      schedule: "02:00 PM - 03:00 PM",
      price: 35,
      available: true,
    ),
    Schedule(
      code: "SCHEDULE_4",
      schedule: "04:00 PM - 05:00 PM",
      price: 35,
      available: true,
    ),
    Schedule(
      code: "SCHEDULE_5",
      schedule: "05:00 PM - 06:00 PM",
      price: 35,
      available: true,
    ),
  ];

  final List<GroomingOption> groomingOptions = [
    GroomingOption(
      code: "FULL_BATH",
      name: "Full bath (Shampoo, Conditioning and Drying)",
      price: 100,
      available: true,
    ),
    GroomingOption(
      code: "NAIL_TRIM",
      name: "Nail Trimming",
      price: 25,
      available: true,
    ),
    GroomingOption(
      code: "EAR_CLEAN",
      name: "Ear Cleaning",
      price: 20,
      available: true,
    ),
    GroomingOption(
      code: "TEETH_CLEAN",
      name: "Teeth Cleaning",
      price: 40,
      available: true,
    ),
  ];

  final List<GroomingPreference> groomingPreferences = [
    GroomingPreference(
      code: "SHORT_TRIM",
      name: "Short Trim",
      price: 0,
      available: true,
    ),
    GroomingPreference(
      code: "LONG_TRIM",
      name: "Long Trim",
      price: 15,
      available: true,
    ),
    GroomingPreference(
      code: "STYLED_CUT",
      name: "Styled Cut",
      price: 25,
      available: true,
    ),
  ];

  final List<Pet> pets = [
    Pet(
      id: "66b1f3e8c9d4a5b2f1234567",
      name: "Buddy",
      specie: "Dog",
      gender: '',
    ),
    Pet(
      id: "66b1f3e8c9d4a5b2f1234568",
      name: "Whiskers",
      specie: "Cat",
      gender: '',
    ),
    Pet(id: "66b1f3e8c9d4a5b2f1234569", name: "Max", specie: "Dog", gender: ''),
  ];

  // Selection states
  String? selectedSchedule;
  Set<String> selectedGroomingOptions = {};
  Set<String> selectedGroomingPreferences = {};
  String? selectedPet;
  bool? hasAllergy;
  bool? isOnMedication;
  bool? hasAntiRabbiesVaccination;

  double get totalPrice {
    double total = 0;

    // Add schedule price
    final schedule = schedules.firstWhere(
      (s) => s.code == selectedSchedule,
      orElse: () =>
          Schedule(code: "", schedule: "", price: 0, available: false),
    );
    total += schedule.price;

    // Add grooming options price
    for (String optionCode in selectedGroomingOptions) {
      final option = groomingOptions.firstWhere(
        (o) => o.code == optionCode,
        orElse: () =>
            GroomingOption(code: "", name: "", price: 0, available: false),
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

  void _bookAppointment() {
    // Collect all appointment data
    final appointmentData = {
      'pet_id': selectedPet,
      'schedule_code': selectedSchedule,
      'grooming_options': selectedGroomingOptions.toList(),
      'grooming_preferences': selectedGroomingPreferences.toList(),
      'has_allergy': hasAllergy,
      'is_on_medication': isOnMedication,
      'has_anti_rabies_vaccination': hasAntiRabbiesVaccination,
      'total_price': totalPrice,
    };

    // TODO: Send appointmentData to API
    print('Appointment Data: $appointmentData');

    // Show confirmation dialog

    ConfirmationDialog.show(
      context: context,
      title: 'Appointment Booked!',
      message: 'Your grooming appointment has been successfully booked.',
      confirmText: 'OK',
      confirmColor: ThemeHelper.getOnBackgroundTextColor(context),
      cancelText: "",
    );
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
            _buildSectionCard(
              title: "Select Your Pet",
              icon: Icons.pets,
              child: _buildPetSelection(),
              theme: theme,
            ),
            const SizedBox(height: 16),

            // Schedule Selection Section
            _buildSectionCard(
              title: "Choose Schedule",
              icon: Icons.schedule,
              child: _buildScheduleSelection(),
              theme: theme,
            ),
            const SizedBox(height: 16),

            // Grooming Options Section
            _buildSectionCard(
              title: "Grooming Services",
              icon: Icons.wash,
              child: _buildGroomingOptionsSelection(),
              theme: theme,
            ),
            const SizedBox(height: 16),

            // Grooming Preferences Section
            _buildSectionCard(
              title: "Grooming Preferences",
              icon: Icons.content_cut,
              child: _buildGroomingPreferencesSelection(),
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

  Widget _buildPetSelection() {
    return Column(
      children: pets.map((pet) {
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
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(Icons.pets),
            ),
            title: CustomText.body(
              pet.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: CustomText.body(pet.specie, size: AppTextSize.xs),
            trailing: Radio<String>(
              value: pet.id,
              groupValue: selectedPet,
              onChanged: (value) {
                setState(() {
                  selectedPet = value;
                });
              },
            ),
            onTap: () {
              setState(() {
                selectedPet = pet.id;
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScheduleSelection() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: schedules.map((schedule) {
        final isSelected = selectedSchedule == schedule.code;
        return FilterChip(
          selected: isSelected,
          onSelected: schedule.available
              ? (selected) {
                  setState(() {
                    selectedSchedule = selected ? schedule.code : null;
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
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        );
      }).toList(),
    );
  }

  Widget _buildGroomingOptionsSelection() {
    return Column(
      children: groomingOptions.map((option) {
        final isSelected = selectedGroomingOptions.contains(option.code);
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
                        selectedGroomingOptions.remove(option.code);
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
  }

  Widget _buildGroomingPreferencesSelection() {
    return Column(
      children: groomingPreferences.map((preference) {
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
                        selectedGroomingPreferences.add(preference.code);
                      } else {
                        selectedGroomingPreferences.remove(preference.code);
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
                : const Text('Free', style: TextStyle(color: Colors.green)),
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        );
      }).toList(),
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText.title('Total Price:', size: AppTextSize.md),
                CustomText.title(
                  'PHP ${totalPrice.toStringAsFixed(2)}',
                  size: AppTextSize.md,
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

// Data Models
class Schedule {
  final String code;
  final String schedule;
  final double price;
  final bool available;

  Schedule({
    required this.code,
    required this.schedule,
    required this.price,
    required this.available,
  });
}

class GroomingOption {
  final String code;
  final String name;
  final double price;
  final bool available;

  GroomingOption({
    required this.code,
    required this.name,
    required this.price,
    required this.available,
  });
}

class GroomingPreference {
  final String code;
  final String name;
  final double price;
  final bool available;

  GroomingPreference({
    required this.code,
    required this.name,
    required this.price,
    required this.available,
  });
}
