import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/application.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/boarding.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/core/utils/date.dart';
import 'package:furcare_app/data/models/boarding/boarding.dart';
import 'package:furcare_app/data/models/boarding/boarding_request.dart';
import 'package:furcare_app/presentation/providers/appointment_provider.dart';
import 'package:furcare_app/presentation/providers/payment_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_button.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
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
  bool _needsUpdate = false;

  int _currentExtensionDays = 0;
  static const int maxExtensionDays = 12;
  bool _isProcessingExtension = false;
  int _lastSentExtensionDays = 0;

  void _increaseExtension() {
    if (_currentExtensionDays < maxExtensionDays && !_isProcessingExtension) {
      setState(() {
        _currentExtensionDays++;
        _needsUpdate = true;
      });
      _handleExtensionChange('add', 1);
    }
  }

  void _decreaseExtension() {
    if (_currentExtensionDays > 0 && !_isProcessingExtension) {
      setState(() {
        _currentExtensionDays--;
        _needsUpdate = true;
      });
      _handleExtensionChange('minus', 1);
    }
  }

  Future<void> _handleExtensionChange(String type, int count) async {
    if (_isProcessingExtension) return;

    setState(() {
      _isProcessingExtension = true;
    });

    try {
      widget.onExtensionChanged?.call(_currentExtensionDays);

      final payload = AppointmentExtensionRequest(
        application: widget.appointment.id,
        count: count,
        type: type,
      );

      await context
          .read<AppointmentProvider>()
          .createBoardingAppointmentExtension(payload);

      _lastSentExtensionDays = _currentExtensionDays;
    } catch (e) {
      setState(() {
        _currentExtensionDays = _lastSentExtensionDays;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update extension: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingExtension = false;
        });
      }
    }
  }

  void _handlePay() {
    final provider = context.read<PaymentSettingsProvider>();

    provider.setAmount(widget.appointment.remainingBalance);
    provider.setApplication(widget.appointment.id);
    provider.setApplicationType(ApplicationModel.boarding);

    context.push(CustomerRoute.payment.paymentMethods);
  }

  @override
  void initState() {
    super.initState();
    // Initialize with current extension days from API
    _currentExtensionDays = widget.appointment.currentExtensionDays;
    _lastSentExtensionDays = _currentExtensionDays;
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
            _buildHeader(colorScheme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPetInformation(colorScheme),
                    const SizedBox(height: 24),
                    _buildBoardingDetails(colorScheme),
                    const SizedBox(height: 24),
                    _buildExtensionSection(colorScheme),
                    const SizedBox(height: 24),
                    _buildCageInformation(colorScheme),
                    const SizedBox(height: 24),
                    _buildBranchInformation(colorScheme),
                    const SizedBox(height: 24),
                    _buildHealthRequirements(colorScheme),
                    if (widget.appointment.instructions.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _buildSpecialInstructions(colorScheme),
                    ],
                    if (widget.appointment.hasExtensions) ...[
                      const SizedBox(height: 24),
                      _buildExtensionHistory(colorScheme),
                    ],

                    _buildPricingSummary(colorScheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
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
          Icon(Icons.hotel_rounded, color: colorScheme.primary, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.title('Boarding Appointment', size: AppTextSize.md),
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
    );
  }

  Widget _buildPetInformation(ColorScheme colorScheme) {
    return _buildSection('Pet Information', [
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
    ], colorScheme);
  }

  Widget _buildBoardingDetails(ColorScheme colorScheme) {
    return _buildSection('Boarding Details', [
      _buildInfoRow(
        'Check-in Date',
        DateTimeUtils.formatDateToLong(
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
        '${widget.appointment.schedule.originalDays ?? widget.appointment.schedule.days} day(s)',
        Icons.schedule,
        colorScheme,
      ),
      _buildInfoRow(
        'Current Duration',
        '${widget.appointment.schedule.days} day(s)',
        Icons.update,
        colorScheme,
      ),
      _buildInfoRow(
        'Status',
        widget.appointment.status.toUpperCase(),
        Icons.flag,
        colorScheme,
      ),
    ], colorScheme);
  }

  Widget _buildExtensionSection(ColorScheme colorScheme) {
    return _buildSection('Extension of Stay', [
      _buildExtensionControl(colorScheme),
    ], colorScheme);
  }

  Widget _buildCageInformation(ColorScheme colorScheme) {
    return _buildSection('Cage Information', [
      _buildInfoRow(
        'Size',
        widget.appointment.cage.size,
        Icons.hotel,
        colorScheme,
      ),
      _buildInfoRow(
        'Daily Rate',
        CurrencyUtils.toPHP(widget.appointment.cage.price),
        Icons.attach_money,
        colorScheme,
      ),
      _buildInfoRow(
        'Current Occupancy',
        '${widget.appointment.cage.occupant}/${widget.appointment.cage.max}',
        Icons.group,
        colorScheme,
      ),
    ], colorScheme);
  }

  Widget _buildBranchInformation(ColorScheme colorScheme) {
    return _buildSection('Branch Information', [
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
    ], colorScheme);
  }

  Widget _buildHealthRequirements(ColorScheme colorScheme) {
    return _buildSection('Health & Requirements', [
      _buildHealthRow(
        'Anti-Rabies Vaccination Requested',
        widget.appointment.requestAntiRabiesVaccination,
        colorScheme,
      ),
    ], colorScheme);
  }

  Widget _buildSpecialInstructions(ColorScheme colorScheme) {
    return _buildSection('Special Instructions', [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outline.withAlpha(51)),
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
    ], colorScheme);
  }

  Widget _buildExtensionHistory(ColorScheme colorScheme) {
    return _buildSection('Extension History', [
      Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outline.withAlpha(51)),
        ),
        child: Column(
          children: widget.appointment.extensions.asMap().entries.map((entry) {
            final index = entry.key;
            final extension = entry.value;
            final isLast = index == widget.appointment.extensions.length - 1;

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: colorScheme.outline.withAlpha(26),
                        ),
                      ),
              ),
              child: Row(
                children: [
                  Icon(
                    extension.type == 'add'
                        ? Icons.add_circle
                        : Icons.remove_circle,
                    color: extension.type == 'add' ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          extension.type == 'add'
                              ? 'Added ${extension.days} day(s)'
                              : 'Removed ${extension.days} day(s)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          BoardingUtils.formatDateTimeToShort(
                            extension.timestamp,
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${extension.priceChange >= 0 ? '+' : ''}${CurrencyUtils.toPHP(extension.priceChange.abs())}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: extension.priceChange >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ], colorScheme);
  }

  Widget _buildPricingSummary(ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          child: Divider(color: colorScheme.outline.withAlpha(77)),
        ),
        _buildSection('Pricing Summary', [
          _buildPricingRow(
            'Original Booking',
            '${CurrencyUtils.toPHP(widget.appointment.cage.price)} x ${widget.appointment.schedule.originalDays ?? widget.appointment.schedule.days} day(s1)',
            CurrencyUtils.toPHP(widget.appointment.originalPrice),
            colorScheme,
          ),
          if (widget.appointment.extensionDays > 0) ...[
            _buildPricingRow(
              'Extension Cost',
              '${CurrencyUtils.toPHP(widget.appointment.cage.price)} x ${widget.appointment.extensionDays} days',
              CurrencyUtils.toPHP(widget.appointment.extensionPrice),
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
        SizedBox(height: 12),
        _buildDurationSummary(colorScheme),

        _needsUpdate
            ? _buildDismissButton(colorScheme)
            : _buildTotalSummary(colorScheme),
      ],
    );
  }

  Widget _buildDurationSummary(ColorScheme colorScheme) {
    return Row(
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
          '${widget.appointment.schedule.days} days',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ],
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

  Widget _buildDismissButton(ColorScheme colorScheme) {
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
          text: "Submit Request",
          textSize: AppTextSize.md,
          height: 64,
          onPressed: () => context.pop(),
          icon: Icons.send_outlined,
          isOutlined: false,
        ),
      ],
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
                            : 'Current: $_currentExtensionDays | Max: $maxExtensionDays days',
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
                _buildExtensionButtons(colorScheme),
              ],
            ),
            if (_currentExtensionDays > 0) ...[
              const SizedBox(height: 12),
              _buildExtensionCostDisplay(colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExtensionButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        IconButton(
          onPressed: _currentExtensionDays > 0 && !_isProcessingExtension
              ? _decreaseExtension
              : null,
          icon: Icon(
            Icons.remove_circle_outline,
            color: _currentExtensionDays > 0 && !_isProcessingExtension
                ? colorScheme.primary
                : colorScheme.onSurface.withAlpha(77),
          ),
        ),
        Container(
          width: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outline.withAlpha(77)),
          ),
          child: Text(
            '$_currentExtensionDays',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        IconButton(
          onPressed:
              _currentExtensionDays < maxExtensionDays &&
                  !_isProcessingExtension
              ? _increaseExtension
              : null,
          icon: Icon(
            Icons.add_circle_outline,
            color:
                _currentExtensionDays < maxExtensionDays &&
                    !_isProcessingExtension
                ? colorScheme.primary
                : colorScheme.onSurface.withAlpha(77),
          ),
        ),
      ],
    );
  }

  Widget _buildExtensionCostDisplay(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withAlpha(51),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Current Extension Cost:',
            style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
          ),
          Text(
            CurrencyUtils.toPHP(
              widget.appointment.cage.price * _currentExtensionDays,
            ),
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
