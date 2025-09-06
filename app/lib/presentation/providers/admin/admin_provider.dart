import 'package:flutter/material.dart';
import 'package:furcare_app/data/models/__admin/admin_application_models.dart';
import 'package:furcare_app/data/models/__admin/admin_payment_models.dart';
import 'package:furcare_app/data/models/__admin/admin_statistics_models.dart';
import 'package:furcare_app/data/models/__admin/admin_user_models.dart';
import 'package:furcare_app/presentation/providers/admin/admin_application_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_payment_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_statistics_provider.dart';
import 'package:furcare_app/presentation/providers/admin/admin_user_provider.dart';

class AdminProvider with ChangeNotifier {
  final AdminUserProvider userProvider;
  final AdminApplicationProvider applicationProvider;
  final AdminStatisticsProvider statisticsProvider;
  final AdminPaymentProvider paymentProvider;

  AdminProvider({
    required this.userProvider,
    required this.applicationProvider,
    required this.statisticsProvider,
    required this.paymentProvider,
  });

  // Quick access getters for backward compatibility
  List<AdminUser> get users => userProvider.users;
  List<AdminApplication> get applications => applicationProvider.applications;
  AdminStatistics? get statistics => statisticsProvider.statistics;
  List<AdminApplicationPayment> get payments => paymentProvider.payments;

  // Combined analytics
  double get totalPaidAmount =>
      applications.fold(0.0, (sum, app) => sum + app.paidAmount);

  double get totalOutstandingAmount =>
      applications.fold(0.0, (sum, app) => sum + app.remainingBalance);

  // Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      userProvider.refreshUsers(),
      applicationProvider.refresh(),
      statisticsProvider.refresh(),
      paymentProvider.refresh(),
    ]);
  }

  // Clear all errors
  void clearAllErrors() {
    userProvider.clearError();
    applicationProvider.clearError();
    statisticsProvider.clearError();
    paymentProvider.clearError();
  }

  // Reset all providers
  void reset() {
    // Reset would be implemented in each provider
    clearAllErrors();
  }
}
