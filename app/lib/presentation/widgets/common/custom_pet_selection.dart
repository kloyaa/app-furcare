import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/widget.dart';
import 'package:furcare_app/data/models/pet_models.dart';
import 'package:furcare_app/presentation/providers/pet_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/screens/customer/appointments/widgets/grooming/skeleton.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PetSelectionAccordion extends StatefulWidget {
  final String? selectedPet;
  final Pet? selectedPetObject;
  final bool isPetAccordionExpanded;
  final Function(String? petId, Pet? petObject) onPetSelected;
  final Function(bool isExpanded) onAccordionToggle;

  const PetSelectionAccordion({
    super.key,
    this.selectedPet,
    this.selectedPetObject,
    required this.isPetAccordionExpanded,
    required this.onPetSelected,
    required this.onAccordionToggle,
  });

  @override
  State<PetSelectionAccordion> createState() => _PetSelectionAccordionState();
}

class _PetSelectionAccordionState extends State<PetSelectionAccordion> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PetProvider>().getPets();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        if (petProvider.isFetchingPets) {
          return const CompanionSelectionSkeleton();
        }

        // No pets available
        if (petProvider.pets.isEmpty) {
          return Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withAlpha(77),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CustomText.body(
                    "You have no pets yet. Please add a pet to continue.",
                    size: AppTextSize.sm,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: "Manage Pets",
                    icon: Icons.arrow_forward_outlined,
                    onPressed: () => context.push(CustomerRoute.createPet),
                    isOutlined: true,
                  ),
                ],
              ),
            ),
          );
        }

        final Pet? selectedPetData = widget.selectedPet == null
            ? null
            : petProvider.pets.firstWhere(
                (pet) => pet.id == widget.selectedPet,
                orElse: () =>
                    Pet(id: '', name: '', specie: '', gender: '', size: ''),
              );

        return Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest.withAlpha(77),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Accordion Header
                GestureDetector(
                  onTap: () =>
                      widget.onAccordionToggle(!widget.isPetAccordionExpanded),
                  child: Row(
                    children: [
                      Icon(
                        selectedPetData != null
                            ? getSpecieIcon(selectedPetData.specie)
                            : Icons.pets_outlined,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.title("Pet", size: AppTextSize.md),
                            if (!widget.isPetAccordionExpanded) ...[
                              const SizedBox(height: 4),
                              CustomText.body(
                                selectedPetData != null
                                    ? "${selectedPetData.name} (${selectedPetData.specie})"
                                    : "No pet selected",
                                size: AppTextSize.sm,
                                color: selectedPetData == null
                                    ? colorScheme.onSurfaceVariant
                                    : null,
                              ),
                            ],
                          ],
                        ),
                      ),
                      AnimatedRotation(
                        turns: widget.isPetAccordionExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Accordion Content
                ClipRect(
                  child: AnimatedAlign(
                    alignment: Alignment.topCenter,
                    heightFactor: widget.isPetAccordionExpanded ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedOpacity(
                      opacity: widget.isPetAccordionExpanded ? 1 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          CustomText.body(
                            "Select a pet from the list below.",
                            size: AppTextSize.xs,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 12),
                          ...petProvider.pets.map((pet) {
                            final bool isSelected =
                                widget.selectedPet == pet.id;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.primaryColor
                                      : Colors.grey.withAlpha(77),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: theme.primaryColor.withAlpha(
                                    26,
                                  ),
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
                                  groupValue: widget.selectedPet,
                                  onChanged: (_) {
                                    widget.onPetSelected(pet.id, pet);
                                    widget.onAccordionToggle(false);
                                  },
                                ),
                                onTap: () {
                                  widget.onPetSelected(pet.id, pet);
                                  widget.onAccordionToggle(false);
                                },
                              ),
                            );
                          }),
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
}
