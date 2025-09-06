import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/default_models.dart';

class PaymentResponseData extends Equatable {
  final String application;
  final String applicationModel;
  final String user;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;
  final dynamic paymentGatewayResponse; // Can be null or object
  final String paymentType;
  final String? notes;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v;

  const PaymentResponseData({
    required this.application,
    required this.applicationModel,
    required this.user,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paymentGatewayResponse,
    required this.paymentType,
    this.notes,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PaymentResponseData.fromJson(Map<String, dynamic> json) {
    return PaymentResponseData(
      application: json['application'] as String? ?? '',
      applicationModel: json['applicationModel'] as String? ?? '',
      user: json['user'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      paymentStatus: json['paymentStatus'] as String? ?? '',
      paymentGatewayResponse: json['paymentGatewayResponse'],
      paymentType: json['paymentType'] as String? ?? '',
      notes: json['notes'] as String?,
      id: json['_id'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      v: json['__v'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application': application,
      'applicationModel': applicationModel,
      'user': user,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'paymentGatewayResponse': paymentGatewayResponse,
      'paymentType': paymentType,
      'notes': notes,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  PaymentResponseData copyWith({
    String? application,
    String? applicationModel,
    String? user,
    double? amount,
    String? paymentMethod,
    String? paymentStatus,
    dynamic paymentGatewayResponse,
    String? paymentType,
    String? notes,
    String? id,
    String? createdAt,
    String? updatedAt,
    int? v,
  }) {
    return PaymentResponseData(
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
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  @override
  List<Object?> get props => [
    application,
    applicationModel,
    user,
    amount,
    paymentMethod,
    paymentStatus,
    paymentGatewayResponse,
    paymentType,
    notes,
    id,
    createdAt,
    updatedAt,
    v,
  ];
}

class PaymentResponse extends DefaultResponse {
  final PaymentResponseData data;

  const PaymentResponse({
    required super.message,
    required super.code,
    required this.data,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      message: json['message'] as String? ?? '',
      code: json['code'] as String? ?? '',
      data: PaymentResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'message': message, 'code': code, 'data': data.toJson()};
  }

  PaymentResponse copyWith({
    String? message,
    String? code,
    PaymentResponseData? data,
  }) {
    return PaymentResponse(
      message: message ?? this.message,
      code: code ?? this.code,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [message, code, data];
}
