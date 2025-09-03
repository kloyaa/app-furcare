import 'package:equatable/equatable.dart';

class PaymentStatisticsId extends Equatable {
  final String status;
  final String method;

  const PaymentStatisticsId({required this.status, required this.method});

  factory PaymentStatisticsId.fromJson(Map<String, dynamic> json) {
    return PaymentStatisticsId(
      status: json['status'] as String? ?? '',
      method: json['method'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'method': method};
  }

  @override
  List<Object?> get props => [status, method];
}

class PaymentStatistics extends Equatable {
  final PaymentStatisticsId id;
  final int count;
  final double totalAmount;

  const PaymentStatistics({
    required this.id,
    required this.count,
    required this.totalAmount,
  });

  factory PaymentStatistics.fromJson(Map<String, dynamic> json) {
    return PaymentStatistics(
      id: PaymentStatisticsId.fromJson(json['_id'] as Map<String, dynamic>),
      count: json['count'] as int? ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id.toJson(), 'count': count, 'totalAmount': totalAmount};
  }

  @override
  List<Object?> get props => [id, count, totalAmount];
}
