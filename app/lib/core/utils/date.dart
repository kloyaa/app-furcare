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

  static bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime parseTimeString(String timeString, DateTime baseDate) {
    try {
      final cleanTime = timeString
          .replaceAll('\u202F', ' ') // Replace narrow no-break space
          .replaceAll('\u00A0', ' ') // Replace standard no-break space
          .trim();

      final format = DateFormat.jm(); // Requires intl
      final parsedTime = format.parse(cleanTime);

      return DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        parsedTime.hour,
        parsedTime.minute,
      );
    } catch (e) {
      return DateTime(2000); // fallback, will be filtered out
    }
  }

  static int parseDays(String? input) {
    if (input == null) return 0;

    final match = RegExp(r'\d+').firstMatch(input);
    return match != null ? int.parse(match.group(0)!) : 0;
  }

  static String formatDateToShort(DateTime date) {
    final formatter = DateFormat('MMM d, y h:mm a');
    return formatter.format(date);
  }

  static String formatDateToLong(DateTime date) {
    final formatter = DateFormat('MMM d, yyyy h:mm a');
    return formatter.format(date);
  }
}
