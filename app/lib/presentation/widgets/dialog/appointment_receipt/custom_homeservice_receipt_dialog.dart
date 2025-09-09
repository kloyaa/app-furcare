import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/core/utils/theme.dart';
import 'package:furcare_app/data/models/home_service/home_service.dart'
    show HomeServiceSchedule;
import 'package:furcare_app/data/models/home_service/home_service_request.dart';
import 'package:furcare_app/data/models/pet_models.dart';
import 'package:furcare_app/presentation/providers/appointment_provider.dart';
import 'package:furcare_app/presentation/providers/branch_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_confirm_dialog.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/dialog/custom_branch_selection_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeServiceReceiptDialog extends StatefulWidget {
  final Pet? selectedPet;
  final String? schedule;
  final String? selectedTime;
  final DateTime? selectedDay;
  final int totalPrice;

  const HomeServiceReceiptDialog({
    super.key,
    required this.selectedPet,
    required this.schedule,
    required this.selectedTime,
    required this.selectedDay,
    required this.totalPrice,
  });

  @override
  State<HomeServiceReceiptDialog> createState() =>
      _HomeServiceReceiptDialogState();

  static void show({
    required String? schedule,
    required BuildContext context,
    required Pet? selectedPet,
    required String? selectedTime,
    required DateTime? selectedDay,
    required int totalPrice,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return HomeServiceReceiptDialog(
          schedule: schedule,
          selectedPet: selectedPet,
          selectedTime: selectedTime,
          selectedDay: selectedDay,
          totalPrice: totalPrice,
        );
      },
    );
  }
}

class _HomeServiceReceiptDialogState extends State<HomeServiceReceiptDialog> {
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
          },
        ),
      );
    }

    if (selectedBranch != null) {
      // // Create your home service appointment payload here
      final payload = HomeServiceAppointmentRequest(
        branch: branchProvider.selectedBranch!.id,
        pet: widget.selectedPet!.id,
        schedule: HomeServiceSchedule(
          date: widget.schedule ?? '',
          time: widget.selectedTime ?? '',
        ),
      );

      if (mounted) {
        await context.read<AppointmentProvider>().createHomeServiceAppointment(
          payload,
        );
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
          height: screenSize.height * 0.8,
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
                        const SizedBox(height: 8),
                        Icon(
                          Icons.home_repair_service,
                          size: 48,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Home Service Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Please review your appointment details',
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
                              widget.selectedPet?.name ?? 'Not Selected',
                            ),
                            _buildReceiptRow(
                              'Species',
                              widget.selectedPet?.specie ?? 'N/A',
                            ),
                            _buildReceiptRow(
                              'Gender',
                              widget.selectedPet?.gender ?? 'N/A',
                            ),
                          ],
                        ),
                        theme: theme,
                      ),

                      const SizedBox(height: 16),

                      // Appointment Details
                      _buildReceiptSection(
                        title: 'Appointment Details',
                        icon: Icons.calendar_today,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildReceiptRow('Date', '${widget.schedule}'),
                            _buildReceiptRow(
                              'Time',
                              widget.selectedTime ?? 'Not Selected',
                            ),
                          ],
                        ),
                        theme: theme,
                      ),

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
                            CustomText.body(
                              CurrencyUtils.toPHP(widget.totalPrice),
                              fontWeight: AppFontWeight.bold.value,
                              color: colorScheme.onErrorContainer,
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
                          title: 'Home Service Booked!',
                          message:
                              'Your home service appointment has been successfully booked.',
                          confirmText: 'OK',
                          confirmColor: ThemeHelper.getOnBackgroundTextColor(
                            context,
                          ),
                          cancelText: "",
                          onConfirm: () {
                            Navigator.of(context)
                              ..pop() // Close dialog
                              ..pop(); // Close booking screen
                            context.push(CustomerRoute.me.homeService);
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
                  icon: Icons.home_repair_service,
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

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 120,
            child: CustomText.body(
              label,
              fontWeight: AppFontWeight.bold.value,
              size: AppTextSize.xs,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(
            width: 140,
            child: CustomText.body(
              value,
              size: AppTextSize.xs,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
