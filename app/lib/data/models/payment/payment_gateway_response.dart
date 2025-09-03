import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/payment/payment_customer_details.dart';

class PaymentGatewayResponse extends Equatable {
  final String gateway;
  final String? processedAt;
  final String merchant;
  final String reference;
  final PaymentCustomerDetails customerDetails;

  const PaymentGatewayResponse({
    required this.gateway,
    this.processedAt,
    required this.merchant,
    required this.reference,
    required this.customerDetails,
  });

  factory PaymentGatewayResponse.fromJson(Map<String, dynamic> json) {
    return PaymentGatewayResponse(
      gateway: json['gateway'] as String? ?? '',
      processedAt: json['processedAt'] as String?,
      merchant: json['merchant'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      customerDetails: PaymentCustomerDetails.fromJson(
        json['customerDetails'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gateway': gateway,
      'processedAt': processedAt,
      'merchant': merchant,
      'reference': reference,
      'customerDetails': customerDetails.toJson(),
    };
  }

  PaymentGatewayResponse copyWith({
    String? gateway,
    String? processedAt,
    String? merchant,
    String? reference,
    PaymentCustomerDetails? customerDetails,
  }) {
    return PaymentGatewayResponse(
      gateway: gateway ?? this.gateway,
      processedAt: processedAt ?? this.processedAt,
      merchant: merchant ?? this.merchant,
      reference: reference ?? this.reference,
      customerDetails: customerDetails ?? this.customerDetails,
    );
  }

  @override
  List<Object?> get props => [
    gateway,
    processedAt,
    merchant,
    reference,
    customerDetails,
  ];
}
