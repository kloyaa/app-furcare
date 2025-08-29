import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/helpers/formatters.dart';
import 'package:furcare_app/data/models/appointment_models.dart';
import 'package:furcare_app/presentation/providers/appointment_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class BoardingAppointmentPreviewDialog extends StatefulWidget {
  final BoardingAppointment appointment;
  final Function(int extensionDays)? onExtensionChanged;

  const BoardingAppointmentPreviewDialog({
    super.key,
    required this.appointment,
    this.onExtensionChanged,
  });

  @override
  State<BoardingAppointmentPreviewDialog> createState() =>
      _BoardingAppointmentPreviewDialogState();
}

class _BoardingAppointmentPreviewDialogState
    extends State<BoardingAppointmentPreviewDialog> {
  int extensionDays = 0;
  static const int maxExtensionDays = 12;
  bool _isProcessingExtension = false; // Add this state variable

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;

    // Calculate total days and price with extension
    final totalDays = widget.appointment.schedule.days + extensionDays;
    final totalPrice = widget.appointment.cage.price * totalDays;

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
                    ...[
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
                    ],

                    // Boarding Details
                    _buildSection('Boarding Details', [
                      _buildInfoRow(
                        'Check-in Date',
                        formatDateToLong(
                          DateTime.parse(widget.appointment.schedule.date),
                        ),
                        Icons.calendar_today,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Check-in Time',
                        widget.appointment.schedule.time,
                        Icons.access_time,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Original Duration',
                        '${widget.appointment.schedule.days} days',
                        Icons.schedule,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Status',
                        widget.appointment.status.toUpperCase(),
                        Icons.flag,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),

                    // Extension Section
                    _buildSection('Extension of Stay', [
                      _buildExtensionControl(colorScheme),
                    ], colorScheme),
                    const SizedBox(height: 24),

                    // Cage Information
                    _buildSection('Cage Information', [
                      _buildInfoRow(
                        'Size',
                        widget.appointment.cage.size,
                        Icons.hotel,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Daily Rate',
                        formatToPhpCurrency(widget.appointment.cage.price),
                        Icons.attach_money,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Current Occupancy',
                        '${widget.appointment.cage.occupant}/${widget.appointment.cage.max}',
                        Icons.group,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),

                    // Branch Information
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

                    // Health & Special Requirements
                    _buildSection('Health & Requirements', [
                      _buildHealthRow(
                        'Anti-Rabies Vaccination Requested',
                        widget.appointment.requestAntiRabiesVaccination,
                        colorScheme,
                      ),
                    ], colorScheme),

                    // Instructions
                    if (widget.appointment.instructions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSection('Special Instructions', [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outline.withAlpha(51),
                            ),
                          ),
                          child: Text(
                            widget.appointment.instructions,
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
                      child: Divider(color: colorScheme.outline.withAlpha(77)),
                    ),

                    _buildSection('Pricing Summary', [
                      _buildPricingRow(
                        'Cage (${widget.appointment.cage.size})',
                        '${formatToPhpCurrency(widget.appointment.cage.price)} x ${widget.appointment.schedule.days} days',
                        formatToPhpCurrency(
                          widget.appointment.cage.price *
                              widget.appointment.schedule.days,
                        ),
                        colorScheme,
                      ),
                      if (extensionDays > 0) ...[
                        _buildPricingRow(
                          'Extension',
                          '${formatToPhpCurrency(widget.appointment.cage.price)} x $extensionDays days',
                          formatToPhpCurrency(
                            widget.appointment.cage.price * extensionDays,
                          ),
                          colorScheme,
                        ),
                      ],
                      if (widget.appointment.requestAntiRabiesVaccination) ...[
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
                        color: colorScheme.primary.withAlpha(77),
                        thickness: 2,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withAlpha(77),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Duration',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                              Text(
                                '$totalDays days',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
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
                                formatToPhpCurrency(totalPrice),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
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

  Widget _buildExtensionControl(ColorScheme colorScheme) {
    return IgnorePointer(
      ignoring: _isProcessingExtension,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withAlpha(51)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Days',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        _isProcessingExtension
                            ? 'Processing...'
                            : 'Max: $maxExtensionDays days',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isProcessingExtension
                              ? colorScheme.primary
                              : colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // Decrease button
                    IconButton(
                      onPressed: extensionDays > 0 ? _decreaseExtension : null,
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: extensionDays > 0
                            ? colorScheme.primary
                            : colorScheme.onSurface.withAlpha(77),
                      ),
                    ),
                    Container(
                      width: 60,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.outline.withAlpha(77),
                        ),
                      ),
                      child: Text(
                        '$extensionDays',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    // Increase button
                    IconButton(
                      onPressed: extensionDays < maxExtensionDays
                          ? _increaseExtension
                          : null,
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: extensionDays < maxExtensionDays
                            ? colorScheme.primary
                            : colorScheme.onSurface.withAlpha(77),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (extensionDays > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Extension Cost:',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      formatToPhpCurrency(
                        widget.appointment.cage.price * extensionDays,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _increaseExtension() {
    if (extensionDays < maxExtensionDays && !_isProcessingExtension) {
      setState(() {
        extensionDays++;
      });
      _handleExtend();
    }
  }

  void _decreaseExtension() {
    if (extensionDays > 0 && !_isProcessingExtension) {
      setState(() {
        extensionDays--;
      });
      _handleExtend();
    }
  }

  void _handleExtend() async {
    if (_isProcessingExtension) {
      return;
    }

    setState(() {
      _isProcessingExtension = true;
    });

    try {
      widget.onExtensionChanged?.call(extensionDays);
      final payload = AppointmentExtensionRequest(
        application: widget.appointment.id,
        count: extensionDays,
      );
      await context
          .read<AppointmentProvider>()
          .createBoardingAppointmentExtension(payload);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingExtension = false;
        });
      }
    }
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
            color: colorScheme.onSurface.withAlpha(153),
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
                    color: colorScheme.onSurface.withAlpha(153),
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
