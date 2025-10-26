import 'package:flutter/material.dart';
import 'package:furcare_app/core/enums/text_enum.dart';
import 'package:furcare_app/core/utils/currency.dart';
import 'package:furcare_app/data/models/__admin/admin_statistics_models.dart';
import 'package:furcare_app/presentation/providers/admin/admin_provider.dart';
import 'package:furcare_app/presentation/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final DateTime _selectedDate = DateTime.now();
  final String _selectedPeriod = 'month';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Schedule the data loading after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReportsData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReportsData() async {
    final adminProvider = context.read<AdminProvider>();
    await Future.wait([
      adminProvider.statisticsProvider.fetchStatistics(
        year: _selectedDate.year,
        month: _selectedPeriod == 'month' ? _selectedDate.month : null,
      ),
      adminProvider.applicationProvider.fetchApplications(),
      adminProvider.paymentProvider.fetchPayments(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: RefreshIndicator(
        onRefresh: _loadReportsData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            // _buildHeader(theme),
            // _buildDateFilters(theme),
            _buildTabBar(theme),
            _buildTabContent(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Card(
          child: TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withAlpha(160),
            indicatorColor: theme.colorScheme.primary,
            tabs: const [
              Tab(text: 'Overview', icon: Icon(Icons.dashboard_outlined)),
              Tab(
                text: 'Monthly Revenue Report',
                icon: Icon(Icons.monetization_on_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(ThemeData theme) {
    return SliverFillRemaining(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: TabBarView(
          controller: _tabController,
          children: [_buildOverviewTab(theme), _buildRevenueTab(theme)],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildOverviewStats(theme, adminProvider),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildTopServices(theme, adminProvider)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRecentTransactions(theme, adminProvider),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewStats(ThemeData theme, AdminProvider adminProvider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 15,
      childAspectRatio: 1.9,
      children: [
        // _buildStatCard(
        //   theme,
        //   title: 'Total Revenue',
        //   value: CurrencyUtils.toPHP(
        //     adminProvider.statisticsProvider.totalRevenue,
        //   ),
        //   icon: Icons.monetization_on_outlined,
        //   color: Colors.green,
        //   change: '+12.5%',
        // ),
        _buildStatCard(
          theme,
          title: 'Appointments',
          value: adminProvider.applications.length.toString(),
          icon: Icons.assignment_outlined,
          color: Colors.blue,
          change: '+8.3%',
        ),
        _buildStatCard(
          theme,
          title: 'Payments',
          value: adminProvider.paymentProvider.completedPayments.length
              .toString(),
          icon: Icons.payment_outlined,
          color: Colors.purple,
          change: '+15.2%',
        ),
        _buildStatCard(
          theme,
          title: 'Active Users',
          value: adminProvider.userProvider.activeCount.toString(),
          icon: Icons.people_outline,
          color: Colors.orange,
          change: '+5.7%',
        ),
      ],
    );
  }

  Widget _buildStatCard(
    ThemeData theme, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String change,
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CustomText.body(
                    change,
                    size: AppTextSize.xs,
                    color: Colors.green,
                    fontWeight: AppFontWeight.semibold.value,
                  ),
                ),
              ],
            ),
            const Spacer(),
            CustomText.title(
              value,
              size: AppTextSize.lg,
              fontWeight: AppFontWeight.black.value,
              color: color,
            ),
            const SizedBox(height: 4),
            CustomText.body(title, fontWeight: AppFontWeight.semibold.value),
          ],
        ),
      ),
    );
  }

  Widget _buildTopServices(ThemeData theme, AdminProvider adminProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.title(
              'Top Services',
              fontWeight: AppFontWeight.bold.value,
            ),
            const SizedBox(height: 20),
            _buildServiceRankItem(
              theme,
              'Grooming',
              adminProvider.applicationProvider.groomingCount,
              Colors.orange,
              1,
            ),
            const SizedBox(height: 12),
            _buildServiceRankItem(
              theme,
              'Boarding',
              adminProvider.applicationProvider.boardingCount,
              Colors.purple,
              2,
            ),
            const SizedBox(height: 12),
            _buildServiceRankItem(
              theme,
              'Home Service',
              adminProvider.applicationProvider.homeServiceCount,
              Colors.blue,
              3,
            ),
            const SizedBox(height: 12),
            _buildServiceDistribution(adminProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRankItem(
    ThemeData theme,
    String name,
    int count,
    Color color,
    int rank,
  ) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CustomText.body(
              rank.toString(),
              size: AppTextSize.xs,
              fontWeight: AppFontWeight.bold.value,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: CustomText.body(name)),
        CustomText.body(
          count.toString(),
          fontWeight: AppFontWeight.bold.value,
          color: color,
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(
    ThemeData theme,
    AdminProvider adminProvider,
  ) {
    final recentPayments = adminProvider.paymentProvider.recentPayments;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.title(
              'Recent Transactions',
              fontWeight: AppFontWeight.bold.value,
            ),
            const SizedBox(height: 20),
            if (recentPayments.isEmpty)
              Center(
                child: CustomText.body(
                  'No recent transactions',
                  color: theme.colorScheme.onSurface.withAlpha(160),
                ),
              )
            else
              ...recentPayments.take(5).map((payment) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: payment.isCompleted
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText.body(
                              payment.user.username,
                              size: AppTextSize.sm,
                              fontWeight: AppFontWeight.semibold.value,
                            ),
                            CustomText.body(
                              payment.applicationTypeFromModel,
                              size: AppTextSize.xs,
                              color: theme.colorScheme.onSurface.withAlpha(160),
                            ),
                          ],
                        ),
                      ),
                      CustomText.body(
                        CurrencyUtils.toPHP(payment.amount),
                        size: AppTextSize.sm,
                        fontWeight: AppFontWeight.bold.value,
                        color: Colors.green.shade700,
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueTab(ThemeData theme) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // _buildRevenueOverview(theme, adminProvider),
              // const SizedBox(height: 24),
              // _buildPaymentMethods(theme, adminProvider),
              // const SizedBox(height: 24),
              _buildRevenueTrend(adminProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceDistribution(AdminProvider adminProvider) {
    final stats = adminProvider.statistics?.yearlyTotals;
    if (stats == null) return const SizedBox();

    final data = [
      {'service': 'Grooming', 'value': stats.grooming.transactions},
      {'service': 'Boarding', 'value': stats.boarding.transactions},
      {'service': 'Home Service', 'value': stats.homeService.transactions},
    ];

    return SizedBox(
      height: 250,
      child: SfCircularChart(
        legend: const Legend(isVisible: true),
        series: <CircularSeries>[
          DoughnutSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (d, _) => d['service'] as String,
            yValueMapper: (d, _) => d['value'] as int,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodChart(AdminProvider adminProvider) {
    final data = [
      {
        'method': 'GCash',
        'count': adminProvider.paymentProvider.gcashPayments.length,
      },
      {
        'method': 'Cash',
        'count': adminProvider.paymentProvider.cashPayments.length,
      },
    ];

    return SizedBox(
      height: 250,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        series: <CartesianSeries<Map<String, dynamic>, String>>[
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: data,
            xValueMapper: (d, _) => d['method'] as String,
            yValueMapper: (d, _) => d['count'] as int,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTrend(AdminProvider adminProvider) {
    final stats = adminProvider.statistics;
    final data = stats?.monthlyBreakdown ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 550,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries<MonthlyBreakdown, String>>[
                  LineSeries<MonthlyBreakdown, String>(
                    dataSource: data,
                    xValueMapper: (m, _) => m.month,
                    yValueMapper: (m, _) => m.total.revenue,
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.green,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildRevenueOverview(ThemeData theme, AdminProvider adminProvider) {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(24),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           CustomText.title(
  //             'Payments Overview',
  //             fontWeight: AppFontWeight.bold.value,
  //           ),
  //           const SizedBox(height: 20),
  //           Row(
  //             children: [
  //               // Expanded(
  //               //   child: _buildRevenueMetric(
  //               //     theme,
  //               //     'Total Revenue',
  //               //     CurrencyUtils.toPHP(
  //               //       adminProvider.statisticsProvider.totalRevenue,
  //               //     ),
  //               //     Colors.green,
  //               //   ),
  //               // ),
  //               Expanded(
  //                 child: _buildRevenueMetric(
  //                   theme,
  //                   'Paid Amount',
  //                   CurrencyUtils.toPHP(adminProvider.totalPaidAmount),
  //                   Colors.blue,
  //                 ),
  //               ),
  //               Expanded(
  //                 child: _buildRevenueMetric(
  //                   theme,
  //                   'Outstanding',
  //                   CurrencyUtils.toPHP(adminProvider.totalOutstandingAmount),
  //                   Colors.orange,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildRevenueMetric(
  //   ThemeData theme,
  //   String title,
  //   String value,
  //   Color color,
  // ) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     margin: const EdgeInsets.symmetric(horizontal: 8),
  //     decoration: BoxDecoration(
  //       color: color.withAlpha(20),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: color.withAlpha(70)),
  //     ),
  //     child: Column(
  //       children: [
  //         CustomText.title(
  //           value,
  //           size: AppTextSize.lg,
  //           fontWeight: AppFontWeight.black.value,
  //           color: color,
  //         ),
  //         const SizedBox(height: 4),
  //         CustomText.body(title, size: AppTextSize.sm, color: color),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPaymentMethods(ThemeData theme, AdminProvider adminProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.title(
              'Payment Methods',
              fontWeight: AppFontWeight.bold.value,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildPaymentMethodCard(
                    theme,
                    'GCash',
                    adminProvider.paymentProvider.gcashPayments.length,
                    Icons.phone_android,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPaymentMethodCard(
                    theme,
                    'Cash',
                    adminProvider.paymentProvider.cashPayments.length,
                    Icons.payments_outlined,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildPaymentMethodChart(adminProvider)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    ThemeData theme,
    String method,
    int count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          CustomText.title(
            count.toString(),
            size: AppTextSize.xl,
            fontWeight: AppFontWeight.black.value,
            color: color,
          ),
          CustomText.body(method, fontWeight: AppFontWeight.semibold.value),
        ],
      ),
    );
  }
}
