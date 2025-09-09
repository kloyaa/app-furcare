import 'package:furcare_app/core/enums/payment.dart';

String getInitials(String fullName) {
  if (fullName.trim().isEmpty) return '';

  final parts = fullName.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty) return '';

  // Always take the first letter of the first word
  String initials = parts.first[0].toUpperCase();

  // Then if more than one word, take first letter of the second word
  if (parts.length > 1) {
    initials += parts[1][0].toUpperCase();
  }

  return initials;
}

String formatPaymentType(PaymentType type) {
  switch (type) {
    case PaymentType.fullPayment:
      return 'Full Payment';
    case PaymentType.partialPayment:
      return 'Partial Payment';
    default:
      return '';
  }
}
