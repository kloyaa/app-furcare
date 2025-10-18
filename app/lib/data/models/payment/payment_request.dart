import 'package:equatable/equatable.dart';
import 'package:furcare_app/core/enums/application.dart';
import 'package:furcare_app/core/enums/payment.dart';

class PaymentRequest extends Equatable {
  final String application;
  final ApplicationModel applicationModel;
  final double amount;
  final PaymentMethod paymentMethod;
  final PaymentType paymentType;
  final String accountNumber;

  const PaymentRequest({
    required this.application,
    required this.applicationModel,
    required this.amount,
    required this.paymentMethod,
    required this.paymentType,
    required this.accountNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'application': application,
      'applicationModel': applicationModel.value,
      'amount': amount,
      'paymentMethod': paymentMethod.value,
      'paymentType': paymentType.value,
      'accountNumber': accountNumber,
      'notes': "",
    };
  }

  @override
  List<Object?> get props => [
    application,
    applicationModel,
    amount,
    paymentMethod,
    paymentType,
  ];
}
