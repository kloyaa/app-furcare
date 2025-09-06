import 'package:furcare_app/core/enums/state.dart';
import 'package:furcare_app/data/models/__admin/admin_statistics_models.dart';
import 'package:furcare_app/data/repositories/admin/admin_repository.dart';
import 'package:furcare_app/presentation/providers/admin/base_admin_provider.dart';

class AdminStatisticsProvider extends BaseAdminProvider {
  final AdminRepository _repository;

  AdminStatisticsProvider({required AdminRepository repository})
    : _repository = repository;

  AdminState _state = AdminState.initial;
  AdminStatistics? _statistics;

  // Getters
  AdminState get state => _state;
  bool get isLoading => _state == AdminState.loading;
  AdminStatistics? get statistics => _statistics;

  // Analytics
  double get totalRevenue => _statistics?.yearlyTotals.revenue ?? 0.0;
  int get totalTransactions => _statistics?.yearlyTotals.transactions ?? 0;
  String get mostPopularService =>
      _statistics?.yearlyTotals.mostPopularServiceName ?? 'N/A';

  MonthlyBreakdown? get currentMonth => _statistics?.currentMonth;
  List<MonthlyBreakdown> get activeMonths => _statistics?.activeMonths ?? [];

  // Methods
  Future<void> fetchStatistics({int? year, int? month}) async {
    _setState(AdminState.loading);

    final result = await _repository.getStatistics(year: year, month: month);

    result.fold(
      (failure) {
        handleError(failure.message, failure.code);
        _setState(AdminState.error);
      },
      (statistics) {
        _statistics = statistics;
        _setState(AdminState.fetched);
      },
    );
  }

  MonthlyBreakdown? getMonthStats(int monthNumber) {
    try {
      return _statistics?.monthlyBreakdown.firstWhere(
        (month) => month.monthNumber == monthNumber,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> refresh() => fetchStatistics();

  void _setState(AdminState newState) {
    _state = newState;
    notifyListeners();
  }
}
