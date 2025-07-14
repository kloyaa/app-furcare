import 'package:intl/intl.dart';

String formatDateToLong(DateTime date) {
  final formatter = DateFormat('MMMM d, y');
  return formatter.format(date);
}
