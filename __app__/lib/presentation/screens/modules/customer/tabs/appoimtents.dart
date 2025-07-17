import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/padding_constant.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';
import 'package:flutter_application_1/core/helpers/content.dart';
import 'package:flutter_application_1/core/helpers/formatters.dart';
import 'package:flutter_application_1/data/models/pet_service.models.dart';
import 'package:flutter_application_1/presentation/providers/pet_service_provider.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentTabScreen extends StatefulWidget {
  const AppointmentTabScreen({super.key});

  @override
  State<AppointmentTabScreen> createState() => _AppointmentTabScreenState();
}

class _AppointmentTabScreenState extends State<AppointmentTabScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
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
    if (code == "PET_GROOMING") {
      context.push('/appointments/grooming');
    }
  }

  @override
  void initState() {
    super.initState();

    // Get the fun fact ONCE and store it
    _currentFunFact = PetMessages.getRandomFunFact();

    // Initialize the glow animation controller
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create a smooth in-out animation
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Start the repeating animation
    _glowController.repeat(reverse: true);

    Future.microtask(() {
      if (mounted) {
        context.read<PetServiceProvider>().getPetServices();
      }
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                'My Appointments',
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
                                                      _getServiceIcon(
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
                            key: Key('services-grid-'),
                            child: ServicesGridSkeleton(),
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
                                    _getServiceIcon(booking['serviceKey']),
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
                                    color: _getStatusColor(
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
    );
  }

  IconData _getServiceIcon(String serviceKey) {
    switch (serviceKey) {
      case 'PET_GROOMING':
        return Icons.content_cut;
      case 'PET_BOARDING':
        return Icons.home;
      case 'HOME_SERVICE':
        return Icons.local_shipping;
      case 'BRANCH_LOCATION':
        return Icons.location_on;
      case 'PET_TRAINING':
        return Icons.school;
      default:
        return Icons.pets;
    }
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'completed':
        return colorScheme.primary;
      case 'active':
        return const Color(0xFF4CAF50); // Green
      case 'pending':
        return const Color(0xFFFF9800); // Orange
      default:
        return colorScheme.onSurfaceVariant;
    }
  }
}

// Shimmer effect widget
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor =
        widget.baseColor ??
        theme.colorScheme.surfaceContainerHigh.withOpacity(0.3);
    final highlightColor =
        widget.highlightColor ?? theme.colorScheme.surface.withOpacity(0.8);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [0.0, 0.5, 1.0],
              transform: GradientRotation(_animation.value * 0.5),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// Individual skeleton item for the grid
class ServiceSkeletonItem extends StatelessWidget {
  const ServiceSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Icon skeleton
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ShimmerEffect(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Text skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Service name skeleton
                  ShimmerEffect(
                    child: Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Secondary text skeleton
                  ShimmerEffect(
                    child: Container(
                      height: 8,
                      width: 60,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Grid skeleton for the services
class ServicesGridSkeleton extends StatelessWidget {
  final int itemCount;

  const ServicesGridSkeleton({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.0,
      children: List.generate(
        itemCount,
        (index) => const ServiceSkeletonItem(),
      ),
    );
  }
}
