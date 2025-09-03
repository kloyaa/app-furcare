import 'package:equatable/equatable.dart';
import 'package:furcare_app/data/models/payment/payment_customer_details.dart';

class PaymentProcessRequest extends Equatable {
  final GatewayData gatewayData;

  const PaymentProcessRequest({required this.gatewayData});

  Map<String, dynamic> toJson() {
    return {'gatewayData': gatewayData.toJson()};
  }

  @override
  List<Object?> get props => [gatewayData];
}

class GatewayData extends Equatable {
  final String merchant;
  final String reference;
  final PaymentCustomerDetails customerDetails;
  final Map<String, dynamic>? additionalInfo;

  const GatewayData({
    required this.merchant,
    required this.reference,
    required this.customerDetails,
    this.additionalInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchant': merchant,
      'reference': reference,
      'customerDetails': customerDetails.toJson(),
      'additionalInfo': additionalInfo ?? {},
    };
  }

  @override
  List<Object?> get props => [
    merchant,
    reference,
    customerDetails,
    additionalInfo,
  ];
}
