import 'package:equatable/equatable.dart';

class AdminStatistics extends Equatable {
  final int year;
  final List<MonthlyBreakdown> monthlyBreakdown;
  final YearlyTotals yearlyTotals;

  const AdminStatistics({
    required this.year,
    required this.monthlyBreakdown,
    required this.yearlyTotals,
  });

  factory AdminStatistics.fromJson(Map<String, dynamic> json) {
    return AdminStatistics(
      year: json['year'] as int? ?? DateTime.now().year,
      monthlyBreakdown:
          (json['monthlyBreakdown'] as List<dynamic>?)
              ?.map(
                (item) =>
                    MonthlyBreakdown.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      yearlyTotals: YearlyTotals.fromJson(
        json['yearlyTotals'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'monthlyBreakdown': monthlyBreakdown
          .map((month) => month.toJson())
          .toList(),
      'yearlyTotals': yearlyTotals.toJson(),
    };
  }

  // Helper methods
  List<MonthlyBreakdown> get activeMonths =>
      monthlyBreakdown.where((month) => month.total.transactions > 0).toList();

  MonthlyBreakdown? get currentMonth {
    final currentMonthNumber = DateTime.now().month;
    try {
      return monthlyBreakdown.firstWhere(
        (month) => month.monthNumber == currentMonthNumber,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [year, monthlyBreakdown, yearlyTotals];
}

class MonthlyBreakdown extends Equatable {
  final String month;
  final int monthNumber;
  final ServiceStatistics grooming;
  final ServiceStatistics boarding;
  final ServiceStatistics homeService;
  final ServiceStatistics total;

  const MonthlyBreakdown({
    required this.month,
    required this.monthNumber,
    required this.grooming,
    required this.boarding,
    required this.homeService,
    required this.total,
  });

  factory MonthlyBreakdown.fromJson(Map<String, dynamic> json) {
    return MonthlyBreakdown(
      month: json['month'] as String? ?? '',
      monthNumber: json['monthNumber'] as int? ?? 0,
      grooming: ServiceStatistics.fromJson(
        json['grooming'] as Map<String, dynamic>? ?? {},
      ),
      boarding: ServiceStatistics.fromJson(
        json['boarding'] as Map<String, dynamic>? ?? {},
      ),
      homeService: ServiceStatistics.fromJson(
        json['homeService'] as Map<String, dynamic>? ?? {},
      ),
      total: ServiceStatistics.fromJson(
        json['total'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'monthNumber': monthNumber,
      'grooming': grooming.toJson(),
      'boarding': boarding.toJson(),
      'homeService': homeService.toJson(),
      'total': total.toJson(),
    };
  }

  bool get hasActivity => total.transactions > 0;

  ServiceStatistics get mostPopularService {
    if (grooming.transactions >= boarding.transactions &&
        grooming.transactions >= homeService.transactions) {
      return grooming;
    } else if (boarding.transactions >= homeService.transactions) {
      return boarding;
    } else {
      return homeService;
    }
  }

  @override
  List<Object?> get props => [
    month,
    monthNumber,
    grooming,
    boarding,
    homeService,
    total,
  ];
}

class ServiceStatistics extends Equatable {
  final int transactions;
  final double revenue;

  const ServiceStatistics({required this.transactions, required this.revenue});

  factory ServiceStatistics.fromJson(Map<String, dynamic> json) {
    return ServiceStatistics(
      transactions: json['transactions'] as int? ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'transactions': transactions, 'revenue': revenue};
  }

  double get averageTransactionValue =>
      transactions > 0 ? revenue / transactions : 0.0;

  @override
  List<Object?> get props => [transactions, revenue];
}

class YearlyTotals extends Equatable {
  final int transactions;
  final double revenue;
  final ServiceStatistics grooming;
  final ServiceStatistics boarding;
  final ServiceStatistics homeService;

  const YearlyTotals({
    required this.transactions,
    required this.revenue,
    required this.grooming,
    required this.boarding,
    required this.homeService,
  });

  factory YearlyTotals.fromJson(Map<String, dynamic> json) {
    return YearlyTotals(
      transactions: json['transactions'] as int? ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      grooming: ServiceStatistics.fromJson(
        json['grooming'] as Map<String, dynamic>? ?? {},
      ),
      boarding: ServiceStatistics.fromJson(
        json['boarding'] as Map<String, dynamic>? ?? {},
      ),
      homeService: ServiceStatistics.fromJson(
        json['homeService'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions': transactions,
      'revenue': revenue,
      'grooming': grooming.toJson(),
      'boarding': boarding.toJson(),
      'homeService': homeService.toJson(),
    };
  }

  double get averageTransactionValue =>
      transactions > 0 ? revenue / transactions : 0.0;

  ServiceStatistics get mostPopularService {
    if (grooming.transactions >= boarding.transactions &&
        grooming.transactions >= homeService.transactions) {
      return grooming;
    } else if (boarding.transactions >= homeService.transactions) {
      return boarding;
    } else {
      return homeService;
    }
  }

  String get mostPopularServiceName {
    if (grooming.transactions >= boarding.transactions &&
        grooming.transactions >= homeService.transactions) {
      return 'Grooming';
    } else if (boarding.transactions >= homeService.transactions) {
      return 'Boarding';
    } else {
      return 'Home Service';
    }
  }

  @override
  List<Object?> get props => [
    transactions,
    revenue,
    grooming,
    boarding,
    homeService,
  ];
}
