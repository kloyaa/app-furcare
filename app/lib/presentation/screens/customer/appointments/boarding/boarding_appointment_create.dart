import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/core/utils/date.dart';
import 'package:furcare_app/data/models/pet_models.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';
import 'package:furcare_app/presentation/providers/pet_service_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_cage_selection.dart';
import 'package:furcare_app/presentation/widgets/common/custom_fields.dart';
import 'package:furcare_app/presentation/widgets/common/custom_pet_selection.dart';
import 'package:furcare_app/presentation/widgets/common/custom_select_field.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/dialog/appointment_receipt/custom_boarding_receipt_dialog.dart';
import 'package:provider/provider.dart';

class BoardingApptScreen extends StatefulWidget {
  const BoardingApptScreen({super.key});

  @override
  State<BoardingApptScreen> createState() => _BoardingApptScreenState();
}

class _BoardingApptScreenState extends State<BoardingApptScreen> {
  List<String> times = [
    "7:00 AM",
    "8:00 AM",
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
    "5:00 PM",
    "6:00 PM",
  ];

  final List<String> days = [
    "1 Day",
    "2 Days",
    "3 Days",
    "4 Days",
    "5 Days",
    "6 Days",
    "7 Days",
  ];

  DateTime? selectedDate;

  final DateTime today = DateTime.now();

  final TextEditingController _instructionsController = TextEditingController();

  // Define the missing variables
  Pet? selectedPet;
  String? selectedTime;
  String? selectedDay;

  PetCage? selectedCage;

  Pet? selectedPetObject;
  bool isPetAccordionExpanded = false;
  bool? requestAntiRabiesVaccination = false;

  void handleSelectedCage(PetCage? cage) {
    setState(() {
      selectedCage = cage;
    });
  }

  int get totalPrice {
    if (selectedCage != null && selectedDay != null) {
      return DateTimeUtils.parseDays(selectedDay) * selectedCage!.price;
    }
    return 0;
  }

  bool _canBookAppointment() {
    return selectedPet != null &&
        selectedTime != null &&
        selectedDay != null &&
        selectedCage != null &&
        _instructionsController.text.isNotEmpty;
  }

  void _bookAppointment() {
    _showReceiptDialog();
  }

  void _showReceiptDialog() {
    return BoardingReceiptDialog.show(
      context: context,
      schedule: DateTimeUtils.formatDateToLong(selectedDate ?? today),
      selectedPet: selectedPet,
      selectedTime: selectedTime,
      selectedDay: selectedDay,
      selectedCage: selectedCage,
      instructions: _instructionsController.text,
      requestAntiRabiesVaccination: requestAntiRabiesVaccination,
      totalPrice: totalPrice,
    );
  }

  @override
  void initState() {
    super.initState();
    selectedDate = today;

    if (mounted) {
      Future.microtask(() {
        if (mounted) {
          context.read<PetServiceProvider>().getPetCages();
        }
      });
    }

    _instructionsController.text = 'Not applicable';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomListAppBar(title: 'Appointment Details'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Selection Section
            PetSelectionAccordion(
              selectedPet: selectedPet?.id,
              selectedPetObject: selectedPetObject,
              isPetAccordionExpanded: isPetAccordionExpanded,
              onPetSelected: (petId, petObject) {
                setState(() {
                  selectedPet = petObject;
                });
              },
              onAccordionToggle: (isExpanded) {
                setState(() {
                  isPetAccordionExpanded = isExpanded;
                });
              },
            ),
            const SizedBox(height: 16),
            Container(
              margin: EdgeInsets.only(bottom: 7),
              child: CustomText.body(
                'Select Date',
                size: AppTextSize.xs,
                color: theme.colorScheme.onSurface.withAlpha(128),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(26),
                border: Border.all(
                  color: colorScheme.outline.withAlpha(26),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Make calendar responsive
                    double calendarWidth = constraints.maxWidth;
                    if (calendarWidth > 400) {
                      calendarWidth = 400;
                    }
                    return SizedBox(
                      width: calendarWidth,
                      child: CalendarDatePicker(
                        initialDate: selectedDate ?? today,
                        firstDate: today,
                        lastDate: DateTime(today.year, today.month + 2),
                        onDateChanged: (DateTime date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Consumer<PetServiceProvider>(
              builder: (context, petServiceProvider, child) {
                return CageSelection(
                  selectedCage: selectedCage,
                  isLoading: petServiceProvider.isFetchingPetCages,
                  cages: petServiceProvider.petCages,
                  onCageSelected: handleSelectedCage,
                );
              },
            ),
            const SizedBox(height: 16),
            CustomInputField(
              label: 'Instructions',
              hintText: 'Enter medical instructions',
              controller: _instructionsController,
              prefixIcon: Icons.medical_information_outlined,
              keyboardType: TextInputType.text,
              maxLines: 3,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomSelectField<String>(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                    label: "Time",
                    hintText: "Select time",
                    options: times,
                    selectedValue: selectedTime,
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select time schedule";
                      }
                      return null;
                    },
                    error: selectedTime == null,
                    isRequired: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomSelectField<String>(
                    label: "Days",
                    hintText: "Select days",
                    options: days,
                    selectedValue: selectedDay,
                    onChanged: (value) {
                      setState(() {
                        selectedDay = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return "Please select days";
                      }
                      return null;
                    },
                    error: selectedDay == null,
                    isRequired: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              title: 'Health & Safety',
              icon: Icons.health_and_safety_outlined,
              theme: theme,
              child: _buildHealthQuestion(
                "Request anti-rabies vaccination?",
                requestAntiRabiesVaccination,
                (value) => setState(() => requestAntiRabiesVaccination = value),
              ),
            ),
            const SizedBox(height: 16),
            _buildPriceSummaryAndButton(theme),
          ],
        ),
      ),
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
                  CurrencyUtils.toPHP(totalPrice),
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
}
