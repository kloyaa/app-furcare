import 'package:flutter/material.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';
import 'package:furcare_app/presentation/routes/customer_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/common/default_snackbar.dart';
import 'package:go_router/go_router.dart';

class MyAppointmentsDialog extends StatefulWidget {
  final VoidCallback? onClose;
  final List<PetService> petServices;

  const MyAppointmentsDialog({
    super.key,
    this.onClose,
    required this.petServices,
  });

  @override
  State<MyAppointmentsDialog> createState() => _MyAppointmentsDialogState();
}

class _MyAppointmentsDialogState extends State<MyAppointmentsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.bottomCenter,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: screenSize.width,
            constraints: BoxConstraints(maxHeight: screenSize.height * 90),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
                bottom: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 20,
                  right: 20,
                  child: IconButton(
                    onPressed: () => widget.onClose ?? Navigator.pop(context),
                    icon: const Icon(Icons.close_outlined),
                  ),
                ),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 80.0,
                      bottom: 60.0,
                    ), // Adjust padding as needed
                    child: widget.petServices.isEmpty
                        ? _buildEmptyState(colorScheme)
                        : _buildServicesList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 64,
            color: colorScheme.outline.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            'No appointments yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withAlpha(179),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your upcoming appointments will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withAlpha(128),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shrinkWrap: true,
      itemCount: widget.petServices.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final service = widget.petServices[index];
        final reverseIndex = widget.petServices.length - 1 - index;

        return SlideTransition(
          position:
              Tween<Offset>(
                begin: Offset(0, 1.0 + (reverseIndex * 0.1)),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    0.2 + (reverseIndex * 0.1),
                    1.0,
                    curve: Curves.easeOutCubic,
                  ),
                ),
              ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                0.2 + (reverseIndex * 0.1),
                1.0,
                curve: Curves.easeOut,
              ),
            ),
            child: _buildServiceItem(service, index),
          ),
        );
      },
    );
  }

  Widget _buildServiceItem(PetService service, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return IgnorePointer(
      ignoring: service.code.toLowerCase() == "PET_TRAINING",
      child: Opacity(
        opacity: service.code.toLowerCase() == "PET_TRAINING" ? 0.3 : 1.0,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handleServiceTap(service),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outline.withAlpha(26),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.pets,
                      color: colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  CustomText.body(
                    service.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.outline.withAlpha(128),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleServiceTap(PetService service) {
    // Handle service tap
    Navigator.of(context).pop();

    if (service.code == "PET_GROOMING") {
      context.push(CustomerRoute.me.grooming);
    }

    if (service.code == "PET_BOARDING") {
      context.push(CustomerRoute.me.boarding);
    }

    if (service.code == "HOME_SERVICE") {
      context.push(CustomerRoute.me.homeService);
    }

    if (service.code == "PET_TRAINING") {
      return showCustomSnackBar(context, 'This feature is not available yet');
    }
  }
}
