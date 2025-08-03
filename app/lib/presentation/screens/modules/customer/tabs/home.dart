import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:furcare_app/core/constants/padding_constant.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/helpers/content.dart';
import 'package:furcare_app/core/helpers/formatters.dart';
import 'package:furcare_app/core/helpers/widget_helpers.dart';
import 'package:furcare_app/core/helpers/widget_image_list.dart';
import 'package:furcare_app/data/models/pet_service.models.dart';
import 'package:furcare_app/presentation/providers/pet_service_provider.dart';
import 'package:furcare_app/presentation/screens/modules/customer/tabs/widgets/appointments/shimmer.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:furcare_app/presentation/widgets/dialog/custom_my_appointments_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
  late Animation<double> _glowAnimation;
  late String _currentFunFact; // Store the fun fact so it doesn't change

  // Mock booking counts for each service
  final Map<String, int> bookingCounts = const {
    "PET_GROOMING": 3,
    "PET_BOARDING": 1,
    "HOME_SERVICE": 2,
    "BRANCH_LOCATION": 0,
    "PET_TRAINING": 0,
  };

  // Mock recent bookings data
  final List<Map<String, dynamic>> recentBookings = const [
    {
      "id": "booking_001",
      "serviceKey": "PET_GROOMING",
      "serviceName": "Grooming",
      "createdAt": "2024-07-10T14:30:00Z",
      "status": "completed",
    },
    {
      "id": "booking_002",
      "serviceKey": "HOME_SERVICE",
      "serviceName": "Home Service",
      "createdAt": "2024-07-12T09:15:00Z",
      "status": "pending",
    },
    {
      "id": "booking_003",
      "serviceKey": "PET_BOARDING",
      "serviceName": "Boarding",
      "createdAt": "2024-07-08T16:45:00Z",
      "status": "completed",
    },
    {
      "id": "booking_004",
      "serviceKey": "PET_TRAINING",
      "serviceName": "Training",
      "createdAt": "2024-07-14T11:20:00Z",
      "status": "active",
    },
    {
      "id": "booking_005",
      "serviceKey": "PET_GROOMING",
      "serviceName": "Grooming",
      "createdAt": "2024-07-09T13:00:00Z",
      "status": "completed",
    },
    {
      "id": "booking_006",
      "serviceKey": "HOME_SERVICE",
      "serviceName": "Home Service",
      "createdAt": "2024-07-11T10:30:00Z",
      "status": "active",
    },
    {
      "id": "booking_007",
      "serviceKey": "PET_BOARDING",
      "serviceName": "Boarding",
      "createdAt": "2024-07-07T15:45:00Z",
      "status": "completed",
    },
    {
      "id": "booking_008",
      "serviceKey": "PET_TRAINING",
      "serviceName": "Training",
      "createdAt": "2024-07-13T08:15:00Z",
      "status": "pending",
    },
    {
      "id": "booking_009",
      "serviceKey": "PET_GROOMING",
      "serviceName": "Grooming",
      "createdAt": "2024-07-06T12:30:00Z",
      "status": "completed",
    },
    {
      "id": "booking_010",
      "serviceKey": "HOME_SERVICE",
      "serviceName": "Home Service",
      "createdAt": "2024-07-05T14:00:00Z",
      "status": "completed",
    },
  ];

  void _handleNavigateToPetServices(String code) {
    print("code: $code");
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

    _currentFunFact = PetMessages.getRandomFunFact();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
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
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer.withOpacity(0.8),
                      colorScheme.surfaceContainerHighest,
                    ],
                  ),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.15),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Decorative elements
                    Positioned(
                      right: -20,
                      top: 20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: 30,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.secondary.withOpacity(0.1),
                        ),
                      ),
                    ),

                    // Main content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withOpacity(
                                        0.3,
                                      ),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.pets,
                                  size: 32,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText.title(
                                      'Pet Services',
                                      size: AppTextSize.lg,
                                    ),
                                    CustomText.body(
                                      PetMessages.getRandomPetMessage(),
                                      size: AppTextSize.xs,
                                      fontWeight: AppFontWeight.normal.value,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              CustomText.body(
                                'New Appointments?',
                                size: AppTextSize.sm,
                                fontWeight: AppFontWeight.bold.value,
                              ),
                            ],
                          ),
                          Consumer<PetServiceProvider>(
                            builder: (context, petServiceProvider, child) {
                              if (petServiceProvider.isInitial ||
                                  petServiceProvider.isFetching) {
                                return ServicesGridSkeleton();
                              }
                              List<PetService> petServices =
                                  petServiceProvider.petServices;
                              return GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 2.0,
                                children: petServices
                                    .where(
                                      (service) =>
                                          service.code != 'BRANCH_LOCATION',
                                    )
                                    .map((service) {
                                      final count =
                                          bookingCounts[service.code] ?? 0;
                                      return GestureDetector(
                                        onTap: () =>
                                            _handleNavigateToPetServices(
                                              service.code,
                                            ),
                                        child: Opacity(
                                          opacity: service.available
                                              ? 1.0
                                              : 0.3,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: count > 0
                                                  ? colorScheme.primaryContainer
                                                        .withOpacity(0.8)
                                                  : colorScheme
                                                        .surfaceContainerLow,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: count > 0
                                                    ? colorScheme.primary
                                                          .withOpacity(0.4)
                                                    : colorScheme.outline
                                                          .withOpacity(0.2),
                                                width: 1.5,
                                              ),
                                              boxShadow: count > 0
                                                  ? [
                                                      BoxShadow(
                                                        color: colorScheme
                                                            .primary
                                                            .withOpacity(0.2),
                                                        spreadRadius: 1,
                                                        blurRadius: 4,
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                      ),
                                                    ]
                                                  : null,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: count > 0
                                                          ? colorScheme.primary
                                                                .withOpacity(
                                                                  0.2,
                                                                )
                                                          : colorScheme
                                                                .surfaceContainerHigh,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      getServiceIcon(
                                                        service.code,
                                                      ),
                                                      size: 16,
                                                      color: count > 0
                                                          ? colorScheme.primary
                                                          : colorScheme
                                                                .onSurfaceVariant,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        CustomText.body(
                                                          service.name,
                                                          size: AppTextSize.xs,
                                                          fontWeight:
                                                              AppFontWeight
                                                                  .bold
                                                                  .value,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        if (count > 0)
                                                          CustomText.body(
                                                            '$count Active',
                                                            size:
                                                                AppTextSize.xss,
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (count > 0)
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            colorScheme.error,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        count.toString(),
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: colorScheme
                                                              .onError,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.shadow.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                        // Glowing shadow that pulses
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary
                              .withOpacity(0.3 * _glowAnimation.value),
                          blurRadius: 15 * _glowAnimation.value,
                          spreadRadius: 2 * _glowAnimation.value,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.lightbulb_outline,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText.body(
                                'Fun Fact',
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              CustomText.body(
                                _currentFunFact,
                                size: AppTextSize.xs,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 400,
                child: CarouselView(
                  controller: _carouselController,
                  scrollDirection: Axis.horizontal,
                  itemExtent: 300,
                  shrinkExtent: 200,
                  children: carouselItemsAlwaysRandom(),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Recent Appointments Section
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title and view all button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.history,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              CustomText('Recent Appointments'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              context.push("/appointments");
                            },
                            child: CustomText.body('View all'),
                          ),
                        ],
                      ),

                      // Recent bookings list
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recentBookings.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final booking = recentBookings[index];
                          final createdAt = DateTime.parse(
                            booking['createdAt'],
                          );
                          final formattedDate = formatDateToLong(createdAt);
                          final formattedTime = DateFormat(
                            'h:mm a',
                          ).format(createdAt);

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.outline.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Service icon
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer
                                        .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    getServiceIcon(booking['serviceKey']),
                                    size: 24,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Booking details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        booking['serviceName'],
                                        size: AppTextSize.sm,
                                        fontWeight: AppFontWeight.bold.value,
                                      ),
                                      const SizedBox(height: 4),
                                      CustomText(
                                        '$formattedDate • $formattedTime',
                                        size: AppTextSize.xs,
                                        fontWeight: AppFontWeight.normal.value,
                                      ),
                                    ],
                                  ),
                                ),
                                // Status indicator
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                      booking['status'],
                                      colorScheme,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomText.body(
                                    booking['status'].toUpperCase(),
                                    size: AppTextSize.xss,
                                    fontWeight: AppFontWeight.bold.value,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom spacing
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
