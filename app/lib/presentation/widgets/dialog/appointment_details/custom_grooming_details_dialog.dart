import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/application.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/data/models/grooming/grooming.dart';
import 'package:furcare_app/presentation/providers/payment_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GroomingAppointmentPreviewDialog extends StatefulWidget {
  final GroomingAppointment appointment;

  const GroomingAppointmentPreviewDialog({
    super.key,
    required this.appointment,
  });

  @override
  State<GroomingAppointmentPreviewDialog> createState() =>
      _GroomingAppointmentPreviewDialogState();
}

class _GroomingAppointmentPreviewDialogState
    extends State<GroomingAppointmentPreviewDialog> {
  void _handlePay() {
    PaymentSettingsProvider provider = context.read<PaymentSettingsProvider>();

    provider.setAmount(widget.appointment.remainingBalance);
    provider.setApplication(widget.appointment.id);
    provider.setApplicationType(ApplicationModel.grooming);

    context.push(CustomerRoute.payment.paymentMethods);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
      child: Container(
        width: screenSize.width * 0.95,
        height: screenSize.height * 0.95,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(26),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        CustomText.title(
                          'Appointment Details',
                          size: AppTextSize.md,
                        ),
                        CustomText.body(
                          'Scroll down to view details',
                          size: AppTextSize.xs,
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: colorScheme.onSurface),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection('Pet Information', [
                      _buildInfoRow(
                        'Name',
                        widget.appointment.pet.name,
                        Icons.pets,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Species',
                        widget.appointment.pet.specie,
                        Icons.category,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Gender',
                        widget.appointment.pet.gender,
                        Icons.info,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),
                    _buildSection('Appointment Details', [
                      _buildInfoRow(
                        'Schedule',
                        widget.appointment.schedule.schedule,
                        Icons.access_time,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Status',
                        widget.appointment.status.toUpperCase(),
                        Icons.flag,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Total Price',
                        CurrencyUtils.toPHP(widget.appointment.totalPrice),
                        Icons.attach_money,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),
                    _buildSection('Branch Information', [
                      _buildInfoRow(
                        'Name',
                        widget.appointment.branch.name,
                        Icons.store,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Address',
                        widget.appointment.branch.address,
                        Icons.location_on,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Phone',
                        widget.appointment.branch.phone,
                        Icons.phone,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Status',
                        widget.appointment.branch.open ? 'Open' : 'Closed',
                        Icons.schedule,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),
                    _buildSection('Health Information', [
                      _buildHealthRow(
                        'Has Allergy',
                        widget.appointment.hasAllergy,
                        colorScheme,
                      ),
                      _buildHealthRow(
                        'On Medication',
                        widget.appointment.isOnMedication,
                        colorScheme,
                      ),
                      _buildHealthRow(
                        'Anti-Rabies Vaccination',
                        widget.appointment.hasAntiRabbiesVaccination,
                        colorScheme,
                      ),
                    ], colorScheme),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      child: Divider(),
                    ),
                    if (widget.appointment.groomingOptions.isNotEmpty) ...[
                      _buildSection(
                        'Services',
                        widget.appointment.groomingOptions
                            .map(
                              (option) => _buildServiceRow(
                                option.name,
                                CurrencyUtils.toPHP(option.price),
                                colorScheme,
                              ),
                            )
                            .toList(),
                        colorScheme,
                      ),
                    ],
                    if (widget.appointment.groomingPreferences.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSection(
                        'Preferences',
                        widget.appointment.groomingPreferences
                            .map(
                              (option) => _buildServiceRow(
                                option.name,
                                CurrencyUtils.toPHP(option.price),
                                colorScheme,
                              ),
                            )
                            .toList(),
                        colorScheme,
                      ),
                    ],
                    const SizedBox(height: 24),
                    _buildSection('Schedule ', [
                      _buildServiceRow(
                        'Price',
                        CurrencyUtils.toPHP(widget.appointment.schedule.price),
                        colorScheme,
                      ),
                    ], colorScheme),

                    SizedBox(height: 12),
                    _buildTotalSummary(colorScheme),
                  ],
                ),
              ),
            ),
            // Footer
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSummary(ColorScheme colorScheme) {
    if (widget.appointment.remainingBalance == 0) {
      return SizedBox(width: double.infinity);
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          child: Divider(),
        ),
        CustomButton(
          text:
              "Pay ${CurrencyUtils.toPHP(widget.appointment.remainingBalance)}",
          textSize: AppTextSize.md,
          height: 64,
          onPressed: () => _handlePay(),
          icon: Icons.payment_outlined,
          isOutlined: false,
        ),
      ],
    );
  }

  Widget _buildSection(
    String title,
    List<Widget> children,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurface.withAlpha(153)),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha(179),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthRow(String label, bool value, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            size: 20,
            color: value ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha(179),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (value ? Colors.green : Colors.red).withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value ? 'Yes' : 'No',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: value ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(
    String service,
    String price,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.design_services,
            size: 20,
            color: colorScheme.onSurface.withAlpha(153),
          ),
          SizedBox(
            width: 200,
            child: Text(
              service,
              maxLines: 2,

              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha(179),
              ),
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
