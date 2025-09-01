import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateTime convertStringToDateTime(String dateString) {
    try {
      // For "September 16, 2025" format
      final formatter = DateFormat('MMMM dd, yyyy');
      return formatter.parse(dateString);
    } catch (e) {
      // Fallback to current date
      return DateTime.now();
    }
  }
}
