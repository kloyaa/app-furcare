import 'package:flutter/material.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/data/models/pet_models.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_pet_selection.dart';
import 'package:furcare_app/presentation/widgets/common/custom_select_field.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';

class HomeServiceApptScreen extends StatefulWidget {
  const HomeServiceApptScreen({super.key});

  @override
  State<HomeServiceApptScreen> createState() => _HomeServiceApptScreenState();
}

class _HomeServiceApptScreenState extends State<HomeServiceApptScreen> {
  final DateTime today = DateTime.now();

  String? selectedPet;
  Pet? selectedPetObject;
  bool isPetAccordionExpanded = false;
  DateTime? selectedDate;
  String? selectedTime;

  List<String> times = [
    "7:00 AM",
    "7:30 AM",
    "8:00 AM",
    "8:30 AM",
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "12:00 PM",
    "12:30 PM",
    "1:00 PM",
    "1:30 PM",
    "2:00 PM",
    "2:30 PM",
    "3:00 PM",
    "3:30 PM",
    "4:00 PM",
    "4:30 PM",
    "5:00 PM",
    "5:30 PM",
    "6:00 PM",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: "Home Service Appointment",
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
            PetSelectionAccordion(
              selectedPet: selectedPet,
              selectedPetObject: selectedPetObject,
              isPetAccordionExpanded: isPetAccordionExpanded,
              onPetSelected: (petId, petObject) {
                setState(() {
                  selectedPet = petId;
                  selectedPetObject = petObject;
                });
              },
              onAccordionToggle: (isExpanded) {
                setState(() {
                  isPetAccordionExpanded = isExpanded;
                });
              },
            ),
            const SizedBox(height: 16),
            // Date Selection
            Container(
              margin: EdgeInsets.only(bottom: 7),
              child: CustomText.body(
                'Select Date',
                size: AppTextSize.xs,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.1),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
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
            // Time Selection
            CustomSelectField<String>(
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
          ],
        ),
      ),
    );
  }
}
