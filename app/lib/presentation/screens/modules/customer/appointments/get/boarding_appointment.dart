import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/helpers/formatters.dart';
import 'package:furcare_app/core/helpers/widget_helpers.dart';
import 'package:furcare_app/data/models/appointment_models.dart';
import 'package:furcare_app/presentation/providers/appointment_provider.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/screens/modules/customer/appointments/create/widgets/boarding/skeleton.dart';
import 'package:furcare_app/presentation/widgets/common/custom_appbar.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/dialog/custom_boarding_details_dialog.dart';
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
        context.read<AppointmentProvider>().getBoardingAppointments();
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
      appBar: CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          HapticFeedback.lightImpact();
          await context.read<AppointmentProvider>().getBoardingAppointments();
        },
        color: colorScheme.primary,
        child: Consumer<AppointmentProvider>(
          builder: (context, appointmentProvider, child) {
            final appointments = appointmentProvider.boardingAppointments;

            if (appointmentProvider.isFetchingAppointments) {
              return const BoardingApplicationsSkeleton();
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
                      speciesIcon: appointment.pet != null
                          ? getSpecieIcon(appointment.pet!.specie)
                          : Icons.pets,
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
          context.push(CustomerRoute.createBoardingppointment);
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        heroTag: "boarding_fab",
        child: Icon(Icons.add_rounded),
      ),
    );
  }

  void _showAppointmentDialog(
    BuildContext context,
    BoardingAppointment appointment,
  ) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) =>
          BoardingAppointmentPreviewDialog(appointment: appointment),
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
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.hotel_outlined,
              size: 64,
              color: colorScheme.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          CustomText.body(
            'No boarding appointments found',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first boarding appointment',
            style: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatefulWidget {
  final BoardingAppointment appointment;
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

  @override
  Widget build(BuildContext context) {
    final pet = widget.appointment.pet;
    final schedule = widget.appointment.schedule;
    final scheduleDatetime = DateTime.parse(schedule.date);
    final formattedDate = formatDateToLong(scheduleDatetime);

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
                    ? widget.colorScheme.surfaceContainerHighest.withOpacity(
                        0.5,
                      )
                    : widget.colorScheme.surfaceContainerHighest.withOpacity(
                        0.3,
                      ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isPressed
                      ? widget.colorScheme.primary.withOpacity(0.3)
                      : widget.colorScheme.outline.withOpacity(0.1),
                ),
                boxShadow: _isPressed
                    ? [
                        BoxShadow(
                          color: widget.colorScheme.primary.withOpacity(0.1),
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
                            color: widget.colorScheme.primary.withOpacity(0.1),
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
                              pet.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: widget.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${pet.specie} • ${pet.gender}',
                              style: TextStyle(
                                fontSize: 14,
                                color: widget.colorScheme.onSurface.withOpacity(
                                  0.7,
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
                          color: widget.statusColor.withOpacity(0.2),
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
                    ],
                  ),
                  widget.appointment.pet.name == "Record not found"
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.colorScheme.surfaceContainerHighest
                                .withOpacity(0.6),
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
                  // Boarding specific details
                  Row(
                    children: [
                      Icon(
                        Icons.hotel,
                        size: 16,
                        color: widget.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.appointment.cage.size} Cage',
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: widget.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${schedule.days} days',
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: widget.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$formattedDate at ${schedule.time}',
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: widget.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.appointment.branch.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.colorScheme.onSurface.withOpacity(
                              0.8,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatToPhpCurrency(widget.appointment.totalPrice),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.colorScheme.primary,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: widget.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ],
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
