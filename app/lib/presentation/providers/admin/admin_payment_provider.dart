import 'package:furcare_app/core/enums/state.dart';
import 'package:furcare_app/data/models/__admin/admin_payment_models.dart';
import 'package:furcare_app/data/repositories/admin/admin_repository.dart';
import 'package:furcare_app/presentation/providers/admin/base_admin_provider.dart';

class AdminPaymentProvider extends BaseAdminProvider {
  final AdminRepository _repository;

  AdminPaymentProvider({required AdminRepository repository})
    : _repository = repository;

  AdminState _state = AdminState.initial;
  List<AdminApplicationPayment> _payments = [];

  String? _methodFilter;
  String? _statusFilter;

  // Getters
  AdminState get state => _state;
  bool get isLoading => _state == AdminState.loading;
  List<AdminApplicationPayment> get payments => _payments;

  String? get methodFilter => _methodFilter;
  String? get statusFilter => _statusFilter;

  // Analytics
  List<AdminApplicationPayment> get completedPayments =>
      _payments.where((payment) => payment.isCompleted).toList();

  List<AdminApplicationPayment> get gcashPayments =>
      _payments.where((payment) => payment.isGCash).toList();

  List<AdminApplicationPayment> get cashPayments =>
      _payments.where((payment) => payment.isCash).toList();

  List<AdminApplicationPayment> get recentPayments =>
      completedPayments.take(10).toList();

  // Methods
  Future<void> fetchPayments({
    int? page,
    int? limit,
    String? paymentMethod,
    String? paymentStatus,
    String? applicationId,
  }) async {
    _setState(AdminState.loading);

    _methodFilter = paymentMethod;
    _statusFilter = paymentStatus;

    final result = await _repository.getPayments(
      page: page,
      limit: limit,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
      applicationId: applicationId,
    );

    result.fold(
      (failure) {
        handleError(failure.message, failure.code);
        _setState(AdminState.error);
      },
      (payments) {
        _payments = payments;
        _setState(AdminState.fetched);
      },
    );
  }

  // Filter methods
  void filterByMethod(String? method) => fetchPayments(paymentMethod: method);
  void filterByStatus(String? status) => fetchPayments(paymentStatus: status);

  void clearFilters() {
    _methodFilter = null;
    _statusFilter = null;
    fetchPayments();
  }

  // Refresh
  Future<void> refresh() =>
      fetchPayments(paymentMethod: _methodFilter, paymentStatus: _statusFilter);

  void _setState(AdminState newState) {
    _state = newState;
    notifyListeners();
  }
}
