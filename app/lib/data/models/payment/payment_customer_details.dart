import 'package:equatable/equatable.dart';

class PaymentCustomerDetails extends Equatable {
  final String fullName;
  final String address;

  const PaymentCustomerDetails({required this.fullName, required this.address});

  factory PaymentCustomerDetails.fromJson(Map<String, dynamic> json) {
    return PaymentCustomerDetails(
      fullName: json['fullName'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'fullName': fullName, 'address': address};
  }

  PaymentCustomerDetails copyWith({String? fullName, String? address}) {
    return PaymentCustomerDetails(
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [fullName, address];
}
