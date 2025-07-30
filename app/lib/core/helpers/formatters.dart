import 'package:intl/intl.dart';

String formatDateToLong(DateTime date) {
  final formatter = DateFormat('MMMM d, y');
  return formatter.format(date);
}

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

String formatToPhpCurrency(num amount) {
  final formatCurrency = NumberFormat.currency(locale: 'en_PH', symbol: 'PHP ');
  return formatCurrency.format(amount);
}
