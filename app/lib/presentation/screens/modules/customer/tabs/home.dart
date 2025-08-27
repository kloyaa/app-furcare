import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/helpers/widget_helpers.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';
import 'package:furcare_app/presentation/providers/pet_service_provider.dart';
import 'package:furcare_app/presentation/screens/modules/customer/tabs/widgets/appointments/shimmer.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/dialog/custom_my_appointments_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _glowController;
  late CarouselController _carouselController;

  // Mock booking counts for each service
  final Map<String, int> bookingCounts = const {
    "PET_GROOMING": 3,
    "PET_BOARDING": 1,
    "HOME_SERVICE": 2,
    "BRANCH_LOCATION": 0,
    "PET_TRAINING": 0,
  };

  void _handleNavigateToPetServices(String code) {
    if (kDebugMode) {
      print("code: $code");
    }
    if (code == "PET_GROOMING") {
      context.push('/appointments/grooming');
    }
    if (code == "PET_BOARDING") {
      context.push('/appointments/boarding');
    }
    if (code == "HOME_SERVICE") {
      context.push('/appointments/home-service');
    }
    if (code == "PET_TRAINING") {
      context.push('/appointments/training');
    }
  }

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowController.repeat(reverse: true);
    _carouselController = CarouselController();
    _bounceController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: -5.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticInOut,
        reverseCurve: Curves.elasticInOut,
      ),
    );

    // Start bouncing every 2.5 seconds
    _startBouncing();

    _carouselController = CarouselController();
    Future.microtask(() {
      if (mounted) {
        context.read<PetServiceProvider>().getPetServices();
      }
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _carouselController.dispose();
    _bounceController.dispose();

    super.dispose();
  }

  void _startBouncing() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _bounceController.forward().then((_) {
          _bounceController.reverse();
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.i("MainTabScreen", stackTrace: StackTrace.empty);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        padding: kDefaultBodyPadding,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Consumer<PetServiceProvider>(
                builder: (context, petServiceProvider, child) {
                  List<PetService> petServices = petServiceProvider.petServices;
                  return GridView.count(
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 4.0,
                    children: petServices.map((service) {
                      final count = bookingCounts[service.code] ?? 0;
                      return GestureDetector(
                        onTap: () => _handleNavigateToPetServices(service.code),
                        child: Opacity(
                          opacity: service.available ? 1.0 : 0.3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: count > 0
                                  ? colorScheme.primaryContainer.withAlpha(204)
                                  : colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: count > 0
                                          ? colorScheme.primary.withAlpha(51)
                                          : colorScheme.surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      getServiceIcon(service.code),
                                      size: 40,
                                      color: count > 0
                                          ? colorScheme.primary
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomText.body(
                                          service.name,
                                          size: AppTextSize.md,
                                          fontWeight: AppFontWeight.bold.value,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (count > 0)
                                          CustomText.body(
                                            '$count Active',
                                            size: AppTextSize.xs,
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (count > 0)
                                    Container(
                                      margin: EdgeInsets.only(right: 14),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.error,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        count.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onError,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimation.value),
            child: FloatingActionButton.extended(
              onPressed: () {
                final petServices = context
                    .read<PetServiceProvider>()
                    .petServices;

                HapticFeedback.lightImpact();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      MyAppointmentsDialog(petServices: petServices),
                );
              },
              icon: const Icon(Icons.bookmark_border_rounded),
              label: const Text('My Appointments'),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
