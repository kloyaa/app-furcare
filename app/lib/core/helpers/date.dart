import 'package:intl/intl.dart';

bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime parseTimeString(String timeString, DateTime baseDate) {
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

int parseDays(String? input) {
  if (input == null) return 0;

  final match = RegExp(r'\d+').firstMatch(input);
  return match != null ? int.parse(match.group(0)!) : 0;
}
