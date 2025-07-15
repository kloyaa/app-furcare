import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/padding_constant.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';
import 'package:flutter_application_1/core/helpers/formatters.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AppointmentTabScreen extends StatelessWidget {
  const AppointmentTabScreen({super.key});

  // Mock data representing the API response
  final List<Map<String, dynamic>> petServices = const [
    {
      "key": "PET_GROOMING",
      "name": "Grooming",
      "description":
          "Professional grooming services for your pets including bathing, haircut, and nail trimming.",
      "available": true,
      "imageUrl": "https://example.com/images/pet-grooming.jpg",
    },
    {
      "key": "PET_BOARDING",
      "name": "Boarding",
      "description":
          "Safe and comfortable boarding facilities for your pets while you are away.",
      "available": true,
      "imageUrl": "https://example.com/images/pet-boarding.jpg",
    },
    {
      "key": "HOME_SERVICE",
      "name": "Home Service",
      "description":
          "Pet care services delivered right at your doorstep for convenience.",
      "available": true,
      "imageUrl": "https://example.com/images/home-service.jpg",
    },
    {
      "key": "PET_TRAINING",
      "name": "Training",
      "description":
          "Basic obedience and advanced training programs for dogs and cats.",
      "available": true,
      "imageUrl": "https://example.com/images/pet-training.jpg",
    },
  ];

  // Mock booking counts for each service
  final Map<String, int> bookingCounts = const {
    "PET_GROOMING": 3,
    "PET_BOARDING": 1,
    "HOME_SERVICE": 2,
    "BRANCH_LOCATION": 0,
    "PET_TRAINING": 1,
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
                                      'Your furry friends deserve the best',
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
                                'Active Bookings',
                                size: AppTextSize.sm,
                                fontWeight: AppFontWeight.bold.value,
                              ),
                            ],
                          ),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.0,
                            children: petServices
                                .where(
                                  (service) =>
                                      service['key'] != 'BRANCH_LOCATION',
                                )
                                .map((service) {
                                  final count =
                                      bookingCounts[service['key']] ?? 0;
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: count > 0
                                          ? colorScheme.primaryContainer
                                                .withOpacity(0.8)
                                          : colorScheme.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: count > 0
                                            ? colorScheme.primary.withOpacity(
                                                0.4,
                                              )
                                            : colorScheme.outline.withOpacity(
                                                0.2,
                                              ),
                                        width: 1.5,
                                      ),
                                      boxShadow: count > 0
                                          ? [
                                              BoxShadow(
                                                color: colorScheme.primary
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: count > 0
                                                  ? colorScheme.primary
                                                        .withOpacity(0.2)
                                                  : colorScheme
                                                        .surfaceContainerHigh,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              _getServiceIcon(service['key']),
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
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CustomText.body(
                                                  service['name'],
                                                  size: AppTextSize.xs,
                                                  fontWeight:
                                                      AppFontWeight.bold.value,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                if (count > 0)
                                                  CustomText.body(
                                                    '$count Active',
                                                    size: AppTextSize.xss,
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
                                                color: colorScheme.error,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                count.toString(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: colorScheme.onError,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Services List with enhanced design
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // Enhanced Service Icon
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primaryContainer,
                                  colorScheme.primaryContainer.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getServiceIcon('BRANCH_LOCATION'),
                              size: 36,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Enhanced Service Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Branch Location",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Visit our physical branches to avail our wide range of pet services.",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            size: 14,
                                            color: colorScheme.primary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Open Now",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primaryContainer
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
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
