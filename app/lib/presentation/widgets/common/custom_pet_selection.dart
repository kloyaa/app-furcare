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
        Pet selectedPetData = Pet(id: "", name: "", specie: "", gender: "");

        if (petProvider.isFetchingPets) {
          return const CompanionSelectionSkeleton();
        }

        if (petProvider.pets.isNotEmpty) {
          selectedPetData = petProvider.pets.firstWhere(
            (pet) => pet.id == widget.selectedPet,
            orElse: () => petProvider.pets.first,
          );
        }

        // Auto-select first pet if none selected
        if (petProvider.pets.isNotEmpty &&
            widget.selectedPet != selectedPetData.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onPetSelected(selectedPetData.id, selectedPetData);
          });
        }

        if (petProvider.pets.isEmpty) {
          return Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest.withAlpha(77),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomButton(
                text: "Manage Pets",
                icon: Icons.arrow_forward_outlined,
                onPressed: () => context.push(CustomerRoute.createPet),
                isLoading: false,
                isOutlined: true,
                isEnabled: true,
              ),
            ),
          );
        }

        return Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest.withAlpha(77),
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
                    widget.onAccordionToggle(!widget.isPetAccordionExpanded);
                  },
                  child: Row(
                    children: [
                      Icon(getSpecieIcon(selectedPetData.specie)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.title("Pet", size: AppTextSize.md),
                            if (!widget.isPetAccordionExpanded) ...[
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
                          color: theme.colorScheme.primary.withAlpha(26),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: AnimatedRotation(
                          turns: widget.isPetAccordionExpanded ? 0.5 : 0,
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
                    heightFactor: widget.isPetAccordionExpanded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: AnimatedOpacity(
                      opacity: widget.isPetAccordionExpanded ? 1.0 : 0.0,
                      duration: Duration(
                        milliseconds: widget.isPetAccordionExpanded ? 350 : 200,
                      ),
                      curve: widget.isPetAccordionExpanded
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
                                    color: widget.selectedPet == pet.id
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.withAlpha(77),
                                    width: widget.selectedPet == pet.id ? 2 : 1,
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).primaryColor.withAlpha(26),
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
                                    onChanged: (value) {
                                      widget.onPetSelected(value, pet);
                                      widget.onAccordionToggle(
                                        false,
                                      ); // Close accordion after selection
                                    },
                                  ),
                                  onTap: () {
                                    widget.onPetSelected(pet.id, pet);
                                    widget.onAccordionToggle(
                                      false,
                                    ); // Close accordion after selection
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
}
