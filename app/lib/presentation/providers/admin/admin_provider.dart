import 'package:flutter/foundation.dart';
import 'package:furcare_app/data/models/__admin/admin_application_models.dart';
import 'package:furcare_app/data/models/__admin/admin_payment_models.dart';
import 'package:furcare_app/data/models/__admin/admin_statistics_models.dart';
import 'package:furcare_app/data/models/__admin/admin_user_models.dart';
import 'package:furcare_app/data/repositories/admin/admin_repository.dart';

enum AdminState { initial, loading, success, error, fetched }

class AdminProvider with ChangeNotifier {
  final AdminRepository _adminRepository;

  AdminProvider({required AdminRepository adminRepository})
    : _adminRepository = adminRepository;

  // States
  AdminState _usersState = AdminState.initial;
  AdminState _applicationsState = AdminState.initial;
  AdminState _statisticsState = AdminState.initial;
  AdminState _paymentsState = AdminState.initial;

  // Data
  List<AdminUser> _users = [];
  AdminApplicationsResponse? _applicationsResponse;
  AdminStatistics? _statistics;
  List<AdminApplicationPayment> _payments = [];

  // Error handling
  String? _errorMessage;
  String? _errorCode;

  // Getters
  AdminState get usersState => _usersState;
  AdminState get applicationsState => _applicationsState;
  AdminState get statisticsState => _statisticsState;
  AdminState get paymentsState => _paymentsState;

  List<AdminUser> get users => _users;
  AdminApplicationsResponse? get applicationsResponse => _applicationsResponse;
  List<AdminApplication> get applications =>
      _applicationsResponse?.applications ?? [];
  AdminPagination? get applicationsPagination =>
      _applicationsResponse?.pagination;
  AdminStatistics? get statistics => _statistics;
  List<AdminApplicationPayment> get payments => _payments;

  String? get error => _errorMessage;
  String? get errorCode => _errorCode;

  bool get isLoadingUsers => _usersState == AdminState.loading;
  bool get isLoadingApplications => _applicationsState == AdminState.loading;
  bool get isLoadingStatistics => _statisticsState == AdminState.loading;
  bool get isLoadingPayments => _paymentsState == AdminState.loading;

  // Users methods
  Future<void> fetchUsers({
    int? page,
    int? limit,
    String? search,
    bool? isActive,
  }) async {
    _setUsersState(AdminState.loading);

    final result = await _adminRepository.getUsers(
      page: page,
      limit: limit,
      search: search,
      isActive: isActive,
    );

    result.fold(
      (failure) {
        _handleError(failure.message, failure.code);
        _setUsersState(AdminState.error);
      },
      (users) {
        _users = users;
        _setUsersState(AdminState.fetched);
      },
    );
  }

  // Applications methods
  Future<void> fetchApplications({
    int page = 1,
    int limit = 50,
    String? applicationType,
    String? status,
    String? paymentStatus,
  }) async {
    _setApplicationsState(AdminState.loading);

    final result = await _adminRepository.getApplications(
      page: page,
      limit: limit,
      applicationType: applicationType,
      status: status,
      paymentStatus: paymentStatus,
    );

    result.fold(
      (failure) {
        _handleError(failure.message, failure.code);
        _setApplicationsState(AdminState.error);
      },
      (response) {
        _applicationsResponse = response;
        _setApplicationsState(AdminState.fetched);
      },
    );
  }

  // Statistics methods
  Future<void> fetchStatistics({int? year, int? month}) async {
    _setStatisticsState(AdminState.loading);

    final result = await _adminRepository.getStatistics(
      year: year,
      month: month,
    );

    result.fold(
      (failure) {
        _handleError(failure.message, failure.code);
        _setStatisticsState(AdminState.error);
      },
      (statistics) {
        _statistics = statistics;
        _setStatisticsState(AdminState.fetched);
      },
    );
  }

  // Payments methods
  Future<void> fetchPayments({
    int? page,
    int? limit,
    String? paymentMethod,
    String? paymentStatus,
    String? applicationId,
  }) async {
    _setPaymentsState(AdminState.loading);

    final result = await _adminRepository.getPayments(
      page: page,
      limit: limit,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      applicationId: applicationId,
    );

    result.fold(
      (failure) {
        _handleError(failure.message, failure.code);
        _setPaymentsState(AdminState.error);
      },
      (payments) {
        _payments = payments;
        _setPaymentsState(AdminState.fetched);
      },
    );
  }

  // Individual fetch methods
  Future<AdminUser?> fetchUserById(String userId) async {
    final result = await _adminRepository.getUserById(userId);
    return result.fold((failure) {
      _handleError(failure.message, failure.code);
      return null;
    }, (user) => user);
  }

  Future<AdminApplication?> fetchApplicationById(String applicationId) async {
    final result = await _adminRepository.getApplicationById(applicationId);
    return result.fold((failure) {
      _handleError(failure.message, failure.code);
      return null;
    }, (application) => application);
  }

  Future<AdminApplicationPayment?> fetchPaymentById(String paymentId) async {
    final result = await _adminRepository.getPaymentById(paymentId);
    return result.fold((failure) {
      _handleError(failure.message, failure.code);
      return null;
    }, (payment) => payment);
  }

  // Filter methods
  void filterApplicationsByType(String? type) {
    fetchApplications(applicationType: type);
  }

  void filterApplicationsByStatus(String? status) {
    fetchApplications(status: status);
  }

  void filterApplicationsByPaymentStatus(String? paymentStatus) {
    fetchApplications(paymentStatus: paymentStatus);
  }

  void filterPaymentsByMethod(String? method) {
    fetchPayments(paymentMethod: method);
  }

  void filterPaymentsByStatus(String? status) {
    fetchPayments(paymentStatus: status);
  }

  void searchUsers(String? search) {
    fetchUsers(search: search);
  }

  void filterUsersByStatus(bool? isActive) {
    fetchUsers(isActive: isActive);
  }

  // Pagination methods
  Future<void> loadNextPageApplications() async {
    if (_applicationsResponse?.pagination.hasNextPage ?? false) {
      final nextPage = _applicationsResponse!.pagination.currentPage + 1;
      await fetchApplications(page: nextPage);
    }
  }

  Future<void> loadPreviousPageApplications() async {
    if (_applicationsResponse?.pagination.hasPreviousPage ?? false) {
      final previousPage = _applicationsResponse!.pagination.currentPage - 1;
      await fetchApplications(page: previousPage);
    }
  }

  // State setters
  void _setUsersState(AdminState newState) {
    _usersState = newState;
    notifyListeners();
  }

  void _setApplicationsState(AdminState newState) {
    _applicationsState = newState;
    notifyListeners();
  }

  void _setStatisticsState(AdminState newState) {
    _statisticsState = newState;
    notifyListeners();
  }

  void _setPaymentsState(AdminState newState) {
    _paymentsState = newState;
    notifyListeners();
  }

  // Error handling
  void _handleError(String message, String? code) {
    _errorMessage = message;
    _errorCode = code;
  }

  void clearError() {
    _errorMessage = null;
    _errorCode = null;
    notifyListeners();
  }

  // Refresh methods
  Future<void> refreshAll() async {
    await Future.wait([
      fetchUsers(),
      fetchApplications(),
      fetchStatistics(),
      fetchPayments(),
    ]);
  }

  Future<void> refreshUsers() async {
    await fetchUsers();
  }

  Future<void> refreshApplications() async {
    await fetchApplications();
  }

  Future<void> refreshStatistics() async {
    await fetchStatistics();
  }

  Future<void> refreshPayments() async {
    await fetchPayments();
  }

  // Analytics helper methods
  double get totalRevenue => _statistics?.yearlyTotals.revenue ?? 0.0;
  int get totalTransactions => _statistics?.yearlyTotals.transactions ?? 0;

  String get mostPopularService =>
      _statistics?.yearlyTotals.mostPopularServiceName ?? 'N/A';

  double get averageTransactionValue =>
      totalTransactions > 0 ? totalRevenue / totalTransactions : 0.0;

  int get activeUsersCount => _users.where((user) => user.isActive).length;
  int get inactiveUsersCount => _users.where((user) => !user.isActive).length;
  int get totalUsersCount => _users.length;

  List<AdminApplication> get pendingApplications => applications
      .where((app) => app.status.toLowerCase() == 'pending')
      .toList();

  List<AdminApplication> get approvedApplications => applications
      .where((app) => app.status.toLowerCase() == 'approved')
      .toList();

  List<AdminApplication> get rejectedApplications => applications
      .where((app) => app.status.toLowerCase() == 'rejected')
      .toList();

  List<AdminApplication> get unpaidApplications =>
      applications.where((app) => app.isUnpaid).toList();

  List<AdminApplication> get partiallyPaidApplications =>
      applications.where((app) => app.isPartiallyPaid).toList();

  List<AdminApplication> get fullyPaidApplications =>
      applications.where((app) => app.isFullyPaid).toList();

  List<AdminApplicationPayment> get completedPayments =>
      _payments.where((payment) => payment.isCompleted).toList();

  List<AdminApplicationPayment> get pendingPayments =>
      _payments.where((payment) => payment.isPending).toList();

  List<AdminApplicationPayment> get failedPayments =>
      _payments.where((payment) => payment.isFailed).toList();

  List<AdminApplicationPayment> get gcashPayments =>
      _payments.where((payment) => payment.isGCash).toList();

  List<AdminApplicationPayment> get cashPayments =>
      _payments.where((payment) => payment.isCash).toList();

  List<AdminApplicationPayment> get recentPayments =>
      completedPayments.take(10).toList();

  // Application type counts
  int get groomingApplicationsCount => applications
      .where((app) => app.applicationType.toLowerCase() == 'grooming')
      .length;

  int get boardingApplicationsCount => applications
      .where((app) => app.applicationType.toLowerCase() == 'boarding')
      .length;

  int get homeServiceApplicationsCount => applications
      .where(
        (app) =>
            app.applicationType.toLowerCase() == 'homeservice' ||
            app.applicationType.toLowerCase() == 'home_service',
      )
      .length;

  // Revenue calculations
  double get totalPaidAmount =>
      applications.fold(0.0, (sum, app) => sum + app.paidAmount);

  double get totalOutstandingAmount =>
      applications.fold(0.0, (sum, app) => sum + app.remainingBalance);

  double get totalApplicationValue =>
      applications.fold(0.0, (sum, app) => sum + app.totalPrice);

  // Monthly statistics helpers
  MonthlyBreakdown? get currentMonthStats => _statistics?.currentMonth;

  List<MonthlyBreakdown> get activeMonths => _statistics?.activeMonths ?? [];

  MonthlyBreakdown? getMonthStats(int monthNumber) {
    try {
      return _statistics?.monthlyBreakdown.firstWhere(
        (month) => month.monthNumber == monthNumber,
      );
    } catch (e) {
      return null;
    }
  }

  // Search and filter state
  String? _currentUserSearch;
  bool? _currentUserActiveFilter;
  String? _currentApplicationTypeFilter;
  String? _currentApplicationStatusFilter;
  String? _currentPaymentStatusFilter;
  String? _currentPaymentMethodFilter;

  // Getters for current filters
  String? get currentUserSearch => _currentUserSearch;
  bool? get currentUserActiveFilter => _currentUserActiveFilter;
  String? get currentApplicationTypeFilter => _currentApplicationTypeFilter;
  String? get currentApplicationStatusFilter => _currentApplicationStatusFilter;
  String? get currentPaymentStatusFilter => _currentPaymentStatusFilter;
  String? get currentPaymentMethodFilter => _currentPaymentMethodFilter;

  // Clear filters
  void clearAllFilters() {
    _currentUserSearch = null;
    _currentUserActiveFilter = null;
    _currentApplicationTypeFilter = null;
    _currentApplicationStatusFilter = null;
    _currentPaymentStatusFilter = null;
    _currentPaymentMethodFilter = null;
    refreshAll();
  }

  void clearUserFilters() {
    _currentUserSearch = null;
    _currentUserActiveFilter = null;
    fetchUsers();
  }

  void clearApplicationFilters() {
    _currentApplicationTypeFilter = null;
    _currentApplicationStatusFilter = null;
    _currentPaymentStatusFilter = null;
    fetchApplications();
  }

  void clearPaymentFilters() {
    _currentPaymentMethodFilter = null;
    _currentPaymentStatusFilter = null;
    fetchPayments();
  }

  // Reset all states and data
  void reset() {
    _usersState = AdminState.initial;
    _applicationsState = AdminState.initial;
    _statisticsState = AdminState.initial;
    _paymentsState = AdminState.initial;

    _users = [];
    _applicationsResponse = null;
    _statistics = null;
    _payments = [];

    _currentUserSearch = null;
    _currentUserActiveFilter = null;
    _currentApplicationTypeFilter = null;
    _currentApplicationStatusFilter = null;
    _currentPaymentStatusFilter = null;
    _currentPaymentMethodFilter = null;

    clearError();
  }
}
