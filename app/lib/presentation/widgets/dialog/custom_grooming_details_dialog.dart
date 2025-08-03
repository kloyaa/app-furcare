import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/helpers/formatters.dart';
import 'package:furcare_app/data/models/appointment_models.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';

class GroomingAppointmentPreviewDialog extends StatelessWidget {
  final GroomingAppointment appointment;

  const GroomingAppointmentPreviewDialog({
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
                        appointment.pet.name,
                        Icons.pets,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Species',
                        appointment.pet.specie,
                        Icons.category,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Gender',
                        appointment.pet.gender,
                        Icons.info,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),
                    _buildSection('Appointment Details', [
                      _buildInfoRow(
                        'Schedule',
                        appointment.schedule.schedule,
                        Icons.access_time,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Status',
                        appointment.status.toUpperCase(),
                        Icons.flag,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Total Price',
                        formatToPhpCurrency(appointment.totalPrice),
                        Icons.attach_money,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),
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
                    _buildSection('Health Information', [
                      _buildHealthRow(
                        'Has Allergy',
                        appointment.hasAllergy,
                        colorScheme,
                      ),
                      _buildHealthRow(
                        'On Medication',
                        appointment.isOnMedication,
                        colorScheme,
                      ),
                      _buildHealthRow(
                        'Anti-Rabies Vaccination',
                        appointment.hasAntiRabbiesVaccination,
                        colorScheme,
                      ),
                    ], colorScheme),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      child: Divider(),
                    ),
                    if (appointment.groomingOptions.isNotEmpty) ...[
                      _buildSection(
                        'Services',
                        appointment.groomingOptions
                            .map(
                              (option) => _buildServiceRow(
                                option.name,
                                formatToPhpCurrency(option.price),
                                colorScheme,
                              ),
                            )
                            .toList(),
                        colorScheme,
                      ),
                    ],
                    if (appointment.groomingPreferences.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSection(
                        'Preferences',
                        appointment.groomingPreferences
                            .map(
                              (option) => _buildServiceRow(
                                option.name,
                                formatToPhpCurrency(option.price),
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
                        formatToPhpCurrency(appointment.schedule.price),
                        colorScheme,
                      ),
                    ], colorScheme),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      child: Divider(),
                    ),

                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText.title(
                            color: colorScheme.primary,
                            formatToPhpCurrency(appointment.totalPrice),
                          ),
                        ],
                      ),
                    ),
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
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
          SizedBox(
            width: 200,
            child: Text(
              service,
              maxLines: 2,

              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.7),
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
