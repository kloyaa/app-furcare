import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/presentation/providers/admin/admin_application_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_statistics_provider.dart';
import 'package:furcare_app/presentation/routes/admin_router.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  Future<void> _loadDashboardData() async {
    final adminProvider = context.read<AdminProvider>();

    await Future.wait([
      adminProvider.applicationProvider.fetchApplications(),
      adminProvider.paymentProvider.fetchPayments(),
      adminProvider.statisticsProvider.fetchStatistics(),
      adminProvider.userProvider.fetchUsers(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(theme),
              const SizedBox(height: 24),
              _buildStatsGrid(theme),
              const SizedBox(height: 24),
              _buildChartsSection(theme),
              // const SizedBox(height: 24),
              // _buildRecentActivity(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.title(
                  'Welcome back, Admin!',
                  size: AppTextSize.xl,
                  color: Colors.white,
                  fontWeight: AppFontWeight.black.value,
                ),
                const SizedBox(height: 8),
                CustomText.body(
                  'Here\'s what\'s happening with FurCare today.',
                  color: Colors.white.withAlpha(240),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.dashboard_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ThemeData theme) {
    return Consumer<AdminApplicationProvider>(
      builder: (context, appProvider, child) {
        final applications = appProvider.applications;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              theme,
              title: 'Total Appointments',
              value: applications.length.toString(),
              icon: Icons.calendar_today_outlined,
              color: Colors.pink,
              subtitle: 'All time',
            ),
            _buildStatCard(
              theme,
              title: 'Grooming Services',
              value: appProvider.groomingCount.toString(),
              icon: Icons.pets_outlined,
              color: Colors.orange,
              subtitle: 'Active bookings',
            ),
            _buildStatCard(
              theme,
              title: 'Boarding Services',
              value: appProvider.boardingCount.toString(),
              icon: Icons.hotel_outlined,
              color: Colors.purple,
              subtitle: 'Current guests',
            ),
            _buildStatCard(
              theme,
              title: 'Home Services',
              value: appProvider.homeServiceCount.toString(),
              icon: Icons.home_outlined,
              color: Colors.blue,
              subtitle: 'Current guests',
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    ThemeData theme, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                CustomText.body(
                  subtitle,
                  size: AppTextSize.xs,
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomText.title(
              value,
              size: AppTextSize.xl,
              fontWeight: AppFontWeight.black.value,
              color: color,
            ),
            const SizedBox(height: 4),
            CustomText.body(title, fontWeight: AppFontWeight.bold.value),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildRevenueChart(theme)),
        const SizedBox(width: 16),
        Expanded(child: _buildServiceDistribution(theme)),
      ],
    );
  }

  Widget _buildRevenueChart(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText.title(
                      'Payments',
                      fontWeight: AppFontWeight.bold.value,
                    ),
                    const SizedBox(height: 4),
                    CustomText.body(
                      'Monthly revenue trends',
                      size: AppTextSize.sm,
                      color: theme.colorScheme.onSurface.withAlpha(160),
                    ),
                  ],
                ),
                const Icon(Icons.trending_up_outlined, color: Colors.green),
              ],
            ),
            const SizedBox(height: 24),
            Consumer<AdminStatisticsProvider>(
              builder: (context, statsProvider, child) {
                final statistics = statsProvider.statistics;

                if (statistics != null) {
                  return SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText.title(
                          CurrencyUtils.toPHP(statistics.yearlyTotals.revenue),
                          size: AppTextSize.xl,
                          fontWeight: AppFontWeight.black.value,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(height: 8),
                        CustomText.body(
                          'Total Revenue ${statistics.year}',
                          color: theme.colorScheme.onSurface.withAlpha(160),
                        ),
                        const SizedBox(height: 16),
                        CustomText.body(
                          '${statistics.yearlyTotals.transactions} Transactions',
                          size: AppTextSize.sm,
                          color: theme.colorScheme.onSurface.withAlpha(220),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withAlpha(
                      70,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurface.withAlpha(70),
                        ),
                        const SizedBox(height: 12),
                        CustomText.body(
                          'Loading Revenue Data...',
                          color: theme.colorScheme.onSurface.withAlpha(160),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDistribution(ThemeData theme) {
    return Consumer<AdminApplicationProvider>(
      builder: (context, appProvider, child) {
        final groomingCount = appProvider.groomingCount;
        final boardingCount = appProvider.boardingCount;
        final homeServiceCount = appProvider.homeServiceCount;
        final totalCount = groomingCount + boardingCount + homeServiceCount;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.title(
                  'Service Distribution',
                  fontWeight: AppFontWeight.bold.value,
                ),
                const SizedBox(height: 4),
                CustomText.body(
                  'Popular services',
                  size: AppTextSize.sm,
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
                const SizedBox(height: 24),
                _buildServiceItem(
                  theme,
                  'Grooming',
                  groomingCount,
                  Colors.orange,
                  totalCount > 0 ? totalCount : 1,
                ),
                const SizedBox(height: 16),
                _buildServiceItem(
                  theme,
                  'Boarding',
                  boardingCount,
                  Colors.purple,
                  totalCount > 0 ? totalCount : 1,
                ),
                const SizedBox(height: 16),
                _buildServiceItem(
                  theme,
                  'Home Service',
                  homeServiceCount,
                  Colors.blue,
                  totalCount > 0 ? totalCount : 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceItem(
    ThemeData theme,
    String name,
    int count,
    Color color,
    int total,
  ) {
    final percentage = total > 0 ? (count / total) : 0.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText.body(name),
            CustomText.body(
              count.toString(),
              fontWeight: AppFontWeight.bold.value,
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: color.withAlpha(40),
          valueColor: AlwaysStoppedAnimation(color),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  // Widget _buildRecentActivity(ThemeData theme) {
  //   return Consumer<AdminApplicationProvider>(
  //     builder: (context, appProvider, child) {
  //       final applications = appProvider.applications;

  //       final grooming = applications
  //           .where((a) => a.applicationType.toLowerCase() == 'grooming')
  //           .take(5)
  //           .toList();
  //       final boarding = applications
  //           .where((a) => a.applicationType.toLowerCase() == 'boarding')
  //           .take(5)
  //           .toList();
  //       final homeService = applications
  //           .where(
  //             (a) =>
  //                 a.applicationType.toLowerCase() == 'home service' ||
  //                 a.applicationType.toLowerCase() == 'homeservice',
  //           )
  //           .take(5)
  //           .toList();

  //       // Merge & sort by createdAt (descending)
  //       final recentApplications = [...grooming, ...boarding, ...homeService]
  //         ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  //       return Card(
  //         child: Padding(
  //           padding: const EdgeInsets.all(24),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       CustomText.title(
  //                         'Recent Applications',
  //                         fontWeight: AppFontWeight.bold.value,
  //                       ),
  //                       const SizedBox(height: 4),
  //                       CustomText.body(
  //                         'Latest customer applications (per service)',
  //                         size: AppTextSize.sm,
  //                         color: theme.colorScheme.onSurface.withAlpha(160),
  //                       ),
  //                     ],
  //                   ),
  //                   TextButton(
  //                     onPressed: () => context.go(AdminRoute.appointments),
  //                     child: CustomText.body(
  //                       'View All',
  //                       color: theme.colorScheme.primary,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               if (recentApplications.isEmpty)
  //                 Container(
  //                   height: 100,
  //                   decoration: BoxDecoration(
  //                     color: theme.colorScheme.surfaceContainerHighest
  //                         .withAlpha(70),
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Center(
  //                     child: CustomText.body(
  //                       'No recent applications',
  //                       color: theme.colorScheme.onSurface.withAlpha(160),
  //                     ),
  //                   ),
  //                 )
  //               else
  //                 ...recentApplications.map((application) {
  //                   return Padding(
  //                     padding: const EdgeInsets.only(bottom: 12),
  //                     child: ListTile(
  //                       leading: CircleAvatar(
  //                         backgroundColor: _getServiceColor(
  //                           application.applicationType,
  //                         ).withAlpha(20),
  //                         child: Icon(
  //                           _getServiceIcon(application.applicationType),
  //                           color: _getServiceColor(
  //                             application.applicationType,
  //                           ),
  //                           size: 20,
  //                         ),
  //                       ),
  //                       title: CustomText.body(
  //                         application.user.username,
  //                         fontWeight: AppFontWeight.bold.value,
  //                       ),
  //                       subtitle: CustomText.body(
  //                         application.createdAt.split('T')[0],
  //                         size: AppTextSize.sm,
  //                         color: theme.colorScheme.onSurface.withAlpha(160),
  //                       ),
  //                     ),
  //                   );
  //                 }),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Color _getServiceColor(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'grooming':
        return Colors.orange;
      case 'boarding':
        return Colors.purple;
      case 'home service':
      case 'homeservice':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType.toLowerCase()) {
      case 'grooming':
        return Icons.pets_outlined;
      case 'boarding':
        return Icons.hotel_outlined;
      case 'home service':
      case 'homeservice':
        return Icons.home_outlined;
      default:
        return Icons.bookmark_outline;
    }
  }
}
