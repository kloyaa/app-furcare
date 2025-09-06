enum PaymentMethod {
  gcash('gcash'),
  bankTransfer('bank_transfer'),
  cash('cash'),
  paypal('paypal');

  const PaymentMethod(this.value);
  final String value;
}

enum PaymentType {
  fullPayment('full_payment'),
  partialPayment('partial_payment'),
  deposit('deposit');

  const PaymentType(this.value);
  final String value;
}
