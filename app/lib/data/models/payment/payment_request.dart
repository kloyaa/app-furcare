import 'package:equatable/equatable.dart';
import 'package:furcare_app/core/enums/payment.dart';

class PaymentRequest extends Equatable {
  final String application;
  final ApplicationModel applicationModel;
  final double amount;
  final String paymentMethod;
  final String paymentType;
  final String? notes;

  const PaymentRequest({
    required this.application,
    required this.applicationModel,
    required this.amount,
    required this.paymentMethod,
    required this.paymentType,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'application': application,
      'applicationModel': applicationModel,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'paymentType': paymentType,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
    application,
    applicationModel,
    amount,
    paymentMethod,
    paymentType,
    notes,
  ];
}
