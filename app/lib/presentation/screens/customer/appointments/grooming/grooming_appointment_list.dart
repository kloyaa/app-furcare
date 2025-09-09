import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/core/utils/widget.dart';
import 'package:furcare_app/data/models/grooming/grooming.dart';
import 'package:furcare_app/presentation/providers/appointment_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/dialog/appointment_details/custom_grooming_details_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    Future.microtask(() {
      if (mounted) {
        context.read<AppointmentProvider>().getGroomingAppointments();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomListAppBar(title: 'Grooming Appointments'),
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await context.read<AppointmentProvider>().getGroomingAppointments();
        },
        color: colorScheme.primary,
        child: Consumer<AppointmentProvider>(
          builder: (context, appointmentProvider, child) {
            final appointments = appointmentProvider.groomingAppointments;

            if (appointmentProvider.isFetchingAppointments) {
              return Center(child: const CircularProgressIndicator());
            }

            if (appointments.isEmpty) {
              return _EmptyState(colorScheme: colorScheme);
            }

            _fadeController.forward();

            return FadeTransition(
              opacity: _fadeAnimation,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 200 + (index * 50)),
                    curve: Curves.easeOutBack,
                    child: _AppointmentCard(
                      appointment: appointment,
                      isDark: isDark,
                      colorScheme: colorScheme,
                      onTap: () => _showAppointmentDialog(context, appointment),
                      statusColor: getStatusColor(
                        appointment.status,
                        colorScheme,
                      ),
                      speciesIcon: getSpecieIcon(appointment.pet.specie),
                      index: index,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          context.push(CustomerRoute.create.grooming);
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        heroTag: "grooming_fab",
        child: Icon(Icons.add_rounded),
      ),
    );
  }

  void _showAppointmentDialog(
    BuildContext context,
    GroomingAppointment appointment,
  ) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) =>
          GroomingAppointmentPreviewDialog(appointment: appointment),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ColorScheme colorScheme;

  const _EmptyState({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.pets_outlined,
              size: 64,
              color: colorScheme.primary.withAlpha(179),
            ),
          ),
          const SizedBox(height: 24),
          CustomText.body(
            'No appointments found',
            style: TextStyle(
              color: colorScheme.onSurface.withAlpha(179),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first grooming appointment',
            style: TextStyle(
              color: colorScheme.onSurface.withAlpha(128),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatefulWidget {
  final GroomingAppointment appointment;
  final bool isDark;
  final ColorScheme colorScheme;
  final VoidCallback onTap;
  final Color statusColor;
  final IconData speciesIcon;
  final int index;

  const _AppointmentCard({
    required this.appointment,
    required this.isDark,
    required this.colorScheme,
    required this.onTap,
    required this.statusColor,
    required this.speciesIcon,
    required this.index,
  });

  @override
  State<_AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<_AppointmentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.forward();
    HapticFeedback.selectionClick();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  // Helper methods for payment status
  Color _getPaymentStatusColor() {
    switch (widget.appointment.paymentStatus) {
      case 'fully_paid':
        return Colors.green;
      case 'partially_paid':
        return Colors.orange;
      case 'overpaid':
        return Colors.blue;
      case 'unpaid':
      default:
        return Colors.red;
    }
  }

  IconData _getPaymentStatusIcon() {
    switch (widget.appointment.paymentStatus) {
      case 'fully_paid':
        return Icons.check_circle_rounded;
      case 'partially_paid':
        return Icons.schedule_rounded;
      case 'overpaid':
        return Icons.trending_up_rounded;
      case 'unpaid':
      default:
        return Icons.warning_rounded;
    }
  }

  String _getPaymentStatusText() {
    switch (widget.appointment.paymentStatus) {
      case 'fully_paid':
        return 'Fully Paid';
      case 'partially_paid':
        return 'Partially Paid';
      case 'overpaid':
        return 'Overpaid';
      case 'unpaid':
      default:
        return 'Unpaid';
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentStatusColor = _getPaymentStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isPressed
                    ? widget.colorScheme.surfaceContainerHighest.withAlpha(128)
                    : widget.colorScheme.surfaceContainerHighest.withAlpha(77),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isPressed
                      ? widget.colorScheme.primary.withAlpha(77)
                      : widget.colorScheme.outline.withAlpha(26),
                ),
                boxShadow: _isPressed
                    ? [
                        BoxShadow(
                          color: widget.colorScheme.primary.withAlpha(26),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'pet_icon_${widget.appointment.id}',
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.colorScheme.primary.withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            widget.speciesIcon,
                            color: widget.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.appointment.pet.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: widget.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${widget.appointment.pet.specie} • ${widget.appointment.pet.gender}',
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.colorScheme.onSurface.withAlpha(
                                  153,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.statusColor.withAlpha(51),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.appointment.status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: widget.statusColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: widget.colorScheme.onSurface.withAlpha(102),
                      ),
                    ],
                  ),
                  widget.appointment.pet.name == "Record not found"
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.colorScheme.surfaceContainerHighest
                                .withAlpha(153),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 24,
                                color: widget.colorScheme.primary,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: CustomText.body(
                                  "Record not found, the companion was possibly removed from the system",
                                  size: AppTextSize.xs,
                                  fontWeight: AppFontWeight.black.value,
                                  style: TextStyle(
                                    color: widget.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(height: 15),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: widget.colorScheme.onSurface.withAlpha(153),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.appointment.schedule.schedule,
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.colorScheme.onSurface.withAlpha(204),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: widget.colorScheme.onSurface.withAlpha(153),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.appointment.branch.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.colorScheme.onSurface.withAlpha(204),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Enhanced Payment Status Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: paymentStatusColor.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: paymentStatusColor.withAlpha(51),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Payment Status Header
                        Row(
                          children: [
                            Icon(
                              _getPaymentStatusIcon(),
                              size: 18,
                              color: paymentStatusColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getPaymentStatusText(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: paymentStatusColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              CurrencyUtils.toPHP(
                                widget.appointment.totalPrice,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),

                        // Payment Details
                        if (widget.appointment.paymentStatus != 'unpaid') ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Paid Amount',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: widget.colorScheme.onSurface
                                            .withAlpha(153),
                                      ),
                                    ),
                                    Text(
                                      CurrencyUtils.toPHP(
                                        widget.appointment.paidAmount,
                                      ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.appointment.remainingBalance > 0) ...[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Remaining',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: widget.colorScheme.onSurface
                                              .withAlpha(153),
                                        ),
                                      ),
                                      Text(
                                        CurrencyUtils.toPHP(
                                          widget.appointment.remainingBalance,
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else if (widget.appointment.paymentStatus ==
                                  'overpaid') ...[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Overpaid',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: widget.colorScheme.onSurface
                                              .withAlpha(153),
                                        ),
                                      ),
                                      Text(
                                        CurrencyUtils.toPHP(
                                          widget.appointment.paidAmount -
                                              widget.appointment.totalPrice,
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],

                        // Progress Bar for Partial Payments
                        if (widget.appointment.paymentStatus ==
                            'partially_paid') ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value:
                                  widget.appointment.paidAmount /
                                  widget.appointment.totalPrice,
                              backgroundColor: widget.colorScheme.outline
                                  .withAlpha(51),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.orange,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
