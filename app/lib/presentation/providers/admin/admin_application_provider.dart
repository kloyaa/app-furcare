import 'package:furcare_app/core/enums/state.dart';
import 'package:furcare_app/data/models/__admin/admin_application_models.dart';
import 'package:furcare_app/data/repositories/admin/admin_repository.dart';
import 'package:furcare_app/presentation/providers/admin/base_admin_provider.dart';

class AdminApplicationProvider extends BaseAdminProvider {
  final AdminRepository _repository;

  AdminApplicationProvider({required AdminRepository repository})
    : _repository = repository;

  AdminState _state = AdminState.initial;
  AdminApplicationsResponse? _response;

  // Filters
  String? _typeFilter;
  String? _statusFilter;
  String? _paymentStatusFilter;

  // Getters
  AdminState get state => _state;
  bool get isLoading => _state == AdminState.loading;

  AdminApplicationsResponse? get response => _response;
  List<AdminApplication> get applications => _response?.applications ?? [];
  AdminPagination? get pagination => _response?.pagination;

  String? get typeFilter => _typeFilter;
  String? get statusFilter => _statusFilter;
  String? get paymentStatusFilter => _paymentStatusFilter;

  // Analytics
  int get totalCount => applications.length;
  int get groomingCount => applications
      .where((app) => app.applicationType.toLowerCase() == 'grooming')
      .length;
  int get boardingCount => applications
      .where((app) => app.applicationType.toLowerCase() == 'boarding')
      .length;
  int get homeServiceCount => applications
      .where(
        (app) =>
            app.applicationType.toLowerCase() == 'homeservice' ||
            app.applicationType.toLowerCase() == 'home_service',
      )
      .length;

  List<AdminApplication> get pendingApplications => applications
      .where((app) => app.status.toLowerCase() == 'pending')
      .toList();

  List<AdminApplication> get unpaidApplications =>
      applications.where((app) => app.isUnpaid).toList();

  // Methods
  Future<void> fetchApplications({
    int page = 1,
    int limit = 50,
    String? applicationType,
    String? status,
    String? paymentStatus,
  }) async {
    _setState(AdminState.loading);

    _typeFilter = applicationType;
    _statusFilter = status;
    _paymentStatusFilter = paymentStatus;

    final result = await _repository.getApplications(
      page: page,
      limit: limit,
      applicationType: applicationType,
      status: status,
      paymentStatus: paymentStatus,
    );

    result.fold(
      (failure) {
        handleError(failure.message, failure.code);
        _setState(AdminState.error);
      },
      (response) {
        _response = response;
        _setState(AdminState.fetched);
      },
    );
  }

  // Filter methods
  void filterByType(String? type) => fetchApplications(applicationType: type);
  void filterByStatus(String? status) => fetchApplications(status: status);
  void filterByPaymentStatus(String? paymentStatus) =>
      fetchApplications(paymentStatus: paymentStatus);

  void clearFilters() {
    _typeFilter = null;
    _statusFilter = null;
    _paymentStatusFilter = null;
    fetchApplications();
  }

  // Pagination
  Future<void> loadNextPage() async {
    if (_response?.pagination.hasNextPage ?? false) {
      final nextPage = _response!.pagination.currentPage + 1;
      await fetchApplications(
        page: nextPage,
        applicationType: _typeFilter,
        status: _statusFilter,
        paymentStatus: _paymentStatusFilter,
      );
    }
  }

  Future<void> loadPreviousPage() async {
    if (_response?.pagination.hasPreviousPage ?? false) {
      final previousPage = _response!.pagination.currentPage - 1;
      await fetchApplications(
        page: previousPage,
        applicationType: _typeFilter,
        status: _statusFilter,
        paymentStatus: _paymentStatusFilter,
      );
    }
  }

  // Refresh
  Future<void> refresh() async {
    await fetchApplications(
      applicationType: _typeFilter,
      status: _statusFilter,
      paymentStatus: _paymentStatusFilter,
    );
  }

  void _setState(AdminState newState) {
    _state = newState;
    notifyListeners();
  }
}
