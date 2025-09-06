import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/auth_models.dart';
import 'package:furcare_app/data/models/payment/payment_gateway_response.dart';

class Payment extends Equatable {
  final String? id;
  final String application;
  final String applicationModel;
  final User user;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final PaymentGatewayResponse paymentGatewayResponse;
  final String paymentType;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? transactionId;

  const Payment({
    this.id,
    required this.application,
    required this.applicationModel,
    required this.user,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.paymentGatewayResponse,
    required this.paymentType,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.transactionId,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['_id'] as String?,
      application: json['application'] as String? ?? '',
      applicationModel: json['applicationModel'] as String? ?? '',
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      paymentGatewayResponse: PaymentGatewayResponse.fromJson(
        json['paymentGatewayResponse'] as Map<String, dynamic>,
      ),
      paymentType: json['paymentType'] as String? ?? '',
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
      transactionId: json['transactionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'application': application,
      'applicationModel': applicationModel,
      'user': user.toJson(),
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'paymentGatewayResponse': paymentGatewayResponse.toJson(),
      'paymentType': paymentType,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'transactionId': transactionId,
    };
  }

  Payment copyWith({
    String? id,
    String? application,
    String? applicationModel,
    User? user,
    double? amount,
    String? paymentMethod,
    String? paymentStatus,
    PaymentGatewayResponse? paymentGatewayResponse,
    String? paymentType,
    String? notes,
    String? createdAt,
    String? updatedAt,
    int? v,
    String? transactionId,
  }) {
    return Payment(
      id: id ?? this.id,
      application: application ?? this.application,
      applicationModel: applicationModel ?? this.applicationModel,
      user: user ?? this.user,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentGatewayResponse:
          paymentGatewayResponse ?? this.paymentGatewayResponse,
      paymentType: paymentType ?? this.paymentType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    application,
    applicationModel,
    user,
    amount,
    paymentMethod,
    paymentStatus,
    paymentGatewayResponse,
    paymentType,
    notes,
    createdAt,
    updatedAt,
    v,
    transactionId,
  ];
}
