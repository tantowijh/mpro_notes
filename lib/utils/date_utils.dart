import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);

  if (date.isAfter(today)) {
    return 'Today, ${DateFormat('hh:mm a').format(date)}';
  } else if (date.isAfter(yesterday)) {
    return 'Yesterday, ${DateFormat('hh:mm a').format(date)}';
  } else {
    return DateFormat('MM/dd/yyyy, hh:mm a').format(date);
  }
}
