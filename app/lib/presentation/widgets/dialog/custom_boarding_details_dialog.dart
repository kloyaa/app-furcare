import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/helpers/formatters.dart';
import 'package:furcare_app/data/models/appointment_models.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';

class BoardingAppointmentPreviewDialog extends StatelessWidget {
  final BoardingAppointment appointment;

  const BoardingAppointmentPreviewDialog({
    super.key,
    required this.appointment,
  });

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
              color: Colors.black.withOpacity(0.2),
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
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.hotel_rounded,
                    color: colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.title(
                          'Boarding Appointment',
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
                    // Pet Information
                    if (appointment.pet != null) ...[
                      _buildSection('Pet Information', [
                        _buildInfoRow(
                          'Name',
                          appointment.pet!.name,
                          Icons.pets,
                          colorScheme,
                        ),
                        _buildInfoRow(
                          'Species',
                          appointment.pet!.specie,
                          Icons.category,
                          colorScheme,
                        ),
                        _buildInfoRow(
                          'Gender',
                          appointment.pet!.gender,
                          Icons.info,
                          colorScheme,
                        ),
                      ], colorScheme),
                      const SizedBox(height: 24),
                    ] else ...[
                      _buildSection('Pet Information', [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.error.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: colorScheme.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Pet information is not available for this appointment',
                                  style: TextStyle(
                                    color: colorScheme.onErrorContainer,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ], colorScheme),
                      const SizedBox(height: 24),
                    ],

                    // Boarding Details
                    _buildSection('Boarding Details', [
                      _buildInfoRow(
                        'Check-in Date',
                        formatDateToLong(
                          DateTime.parse(appointment.schedule.date),
                        ),
                        Icons.calendar_today,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Check-in Time',
                        appointment.schedule.time,
                        Icons.access_time,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Duration',
                        '${appointment.schedule.days} days',
                        Icons.schedule,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Status',
                        appointment.status.toUpperCase(),
                        Icons.flag,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),

                    // Cage Information
                    _buildSection('Cage Information', [
                      _buildInfoRow(
                        'Size',
                        appointment.cage.size,
                        Icons.hotel,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Daily Rate',
                        formatToPhpCurrency(appointment.cage.price),
                        Icons.attach_money,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Current Occupancy',
                        '${appointment.cage.occupant}/${appointment.cage.max}',
                        Icons.group,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),

                    // Branch Information
                    _buildSection('Branch Information', [
                      _buildInfoRow(
                        'Name',
                        appointment.branch.name,
                        Icons.store,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Address',
                        appointment.branch.address,
                        Icons.location_on,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Phone',
                        appointment.branch.phone,
                        Icons.phone,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Status',
                        appointment.branch.open ? 'Open' : 'Closed',
                        Icons.schedule,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),

                    // Health & Special Requirements
                    _buildSection('Health & Requirements', [
                      _buildHealthRow(
                        'Anti-Rabies Vaccination Requested',
                        appointment.requestAntiRabiesVaccination,
                        colorScheme,
                      ),
                    ], colorScheme),

                    // Instructions
                    if (appointment.instructions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSection('Special Instructions', [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            appointment.instructions,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ], colorScheme),
                    ],

                    // Pricing Summary
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      child: Divider(
                        color: colorScheme.outline.withOpacity(0.3),
                      ),
                    ),

                    _buildSection('Pricing Summary', [
                      _buildPricingRow(
                        'Cage (${appointment.cage.size})',
                        '${formatToPhpCurrency(appointment.cage.price)} x ${appointment.schedule.days} days',
                        formatToPhpCurrency(
                          appointment.cage.price * appointment.schedule.days,
                        ),
                        colorScheme,
                      ),
                      if (appointment.requestAntiRabiesVaccination) ...[
                        _buildPricingRow(
                          'Anti-Rabies Vaccination',
                          'Additional service',
                          'Included',
                          colorScheme,
                        ),
                      ],
                    ], colorScheme),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Divider(
                        color: colorScheme.primary.withOpacity(0.3),
                        thickness: 2,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          Text(
                            formatToPhpCurrency(appointment.totalPrice),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.7),
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
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (value ? Colors.green : Colors.red).withOpacity(0.1),
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

  Widget _buildPricingRow(
    String service,
    String description,
    String price,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long,
            size: 20,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
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
