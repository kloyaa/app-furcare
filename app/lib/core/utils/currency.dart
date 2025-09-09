import 'package:intl/intl.dart';

class CurrencyUtils {
  static String toPHP(num amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'en_PH',
      symbol: 'PHP ',
    );
    return formatCurrency.format(amount);
  }
}
