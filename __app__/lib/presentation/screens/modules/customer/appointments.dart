import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/padding_constant.dart';
import 'package:flutter_application_1/core/enums/text_enum.dart';
import 'package:flutter_application_1/core/helpers/formatters.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_appbar.dart';
import 'package:flutter_application_1/presentation/widgets/common/custom_text.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
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
      appBar: CustomAppBar(showThemeToggle: false),
      body: Padding(
        padding: kDefaultBodyPadding,
        child: ListView.separated(
          itemCount: recentBookings.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final booking = recentBookings[index];
            final createdAt = DateTime.parse(booking['createdAt']);
            final formattedDate = formatDateToLong(createdAt);
            final formattedTime = DateFormat('h:mm a').format(createdAt);

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
                      color: colorScheme.primaryContainer.withOpacity(0.5),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
