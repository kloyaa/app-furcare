import 'package:intl/intl.dart';

class BoardingUtils {
  static String formatDateTimeToShort(DateTime dateTime) {
    return DateFormat('MMM d, yyyy h:mm a').format(dateTime);
  }
}
