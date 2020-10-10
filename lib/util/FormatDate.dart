import 'package:intl/intl.dart';

class FormatDate {
  static String getLongformatDateWithTime(DateTime date) {
    return DateFormat("d MMM, y hh:mm a").format(date);
  }

  static String getDate(DateTime date) {
    return DateFormat("d MMM").format(date);
  }
}
