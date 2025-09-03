import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/payment/payment.dart';

class Pagination extends Equatable {
  final int current;
  final int total;
  final int count;
  final int totalRecords;

  const Pagination({
    required this.current,
    required this.total,
    required this.count,
    required this.totalRecords,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      current: json['current'] as int? ?? 1,
      total: json['total'] as int? ?? 0,
      count: json['count'] as int? ?? 0,
      totalRecords: json['totalRecords'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'total': total,
      'count': count,
      'totalRecords': totalRecords,
    };
  }

  Pagination copyWith({
    int? current,
    int? total,
    int? count,
    int? totalRecords,
  }) {
    return Pagination(
      current: current ?? this.current,
      total: total ?? this.total,
      count: count ?? this.count,
      totalRecords: totalRecords ?? this.totalRecords,
    );
  }

  @override
  List<Object?> get props => [current, total, count, totalRecords];
}

class Payments extends Equatable {
  final List<Payment> payments;
  final Pagination pagination;

  const Payments({required this.payments, required this.pagination});

  factory Payments.fromJson(Map<String, dynamic> json) {
    return Payments(
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map(
                (paymentJson) =>
                    Payment.fromJson(paymentJson as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payments': payments.map((payment) => payment.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  Payments copyWith({List<Payment>? payments, Pagination? pagination}) {
    return Payments(
      payments: payments ?? this.payments,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [payments, pagination];
}
