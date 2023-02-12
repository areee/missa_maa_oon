import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat('dd.MM.yyyy HH:mm:ss').format(dateTime);
}
