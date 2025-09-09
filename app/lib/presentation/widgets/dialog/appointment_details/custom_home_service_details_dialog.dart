import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/application.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/core/utils/date.dart';
import 'package:furcare_app/data/models/home_service/home_service.dart';
import 'package:furcare_app/presentation/providers/payment_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeServiceAppointmentPreviewDialog extends StatefulWidget {
  final HomeServiceAppointment appointment;

  const HomeServiceAppointmentPreviewDialog({
    super.key,
    required this.appointment,
  });

  @override
  State<HomeServiceAppointmentPreviewDialog> createState() =>
      _HomeServiceAppointmentPreviewDialogState();
}

class _HomeServiceAppointmentPreviewDialogState
    extends State<HomeServiceAppointmentPreviewDialog> {
  void _handlePay() {
    PaymentSettingsProvider provider = context.read<PaymentSettingsProvider>();

    provider.setAmount(widget.appointment.remainingBalance);
    provider.setApplication(widget.appointment.id);
    provider.setApplicationType(ApplicationModel.homeService);

    context.push(CustomerRoute.payment.paymentMethods);
  }

  String _formatSchedule() {
    final date = DateTimeUtils.formatDateToLong(
      DateTime.parse(widget.appointment.schedule.date),
    );
    final time = widget.appointment.schedule.time;
    return '$date at $time';
  }

  String _formatCreatedDate() {
    return DateFormat('MMM dd, yyyy').format(widget.appointment.createdAt);
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
                    Icons.home_work_rounded,
                    color: colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        CustomText.title(
                          'Home Service Details',
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
                        widget.appointment.pet.gender.toLowerCase() == 'male'
                            ? Icons.male
                            : Icons.female,
                        colorScheme,
                      ),
                    ], colorScheme),
                    const SizedBox(height: 24),
                    _buildSection('Schedule Information', [
                      _buildInfoRow(
                        'Date & Time',
                        _formatSchedule(),
                        Icons.access_time,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Booked On',
                        _formatCreatedDate(),
                        Icons.calendar_today,
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
                      if (widget.appointment.branch.phone.isNotEmpty)
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
                    _buildSection('Appointment Details', [
                      _buildInfoRow(
                        'Status',
                        widget.appointment.status.toUpperCase(),
                        Icons.flag,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'Appointment ID',
                        '#${widget.appointment.id.substring(0, 8).toUpperCase()}',
                        Icons.tag,
                        colorScheme,
                      ),
                      _buildInfoRow(
                        'User ID',
                        widget.appointment.user.substring(0, 8).toUpperCase(),
                        Icons.person,
                        colorScheme,
                      ),
                    ], colorScheme),

                    // Show warning if pet record not found
                    if (widget.appointment.pet.name == "Record not found")
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange.withAlpha(100),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Pet record not found. The companion may have been removed from the system.',
                                style: TextStyle(
                                  color: Colors.orange.withAlpha(200),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Total Price
                    _buildTotalSummary(colorScheme),
                  ],
                ),
              ),
            ),
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
}
