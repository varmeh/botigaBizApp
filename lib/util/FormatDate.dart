import 'package:intl/intl.dart';

const TODAY = 'TODAY';

extension DateFormatter on DateTime {
  String getLongformatDateWithTime() {
    return DateFormat("d MMM, y hh:mm a").format(this);
  }

  String getDate() {
    return DateFormat("d MMM").format(this);
  }

  String getTodayOrSelectedDate() {
    final now = new DateTime.now();
    String currentDate = DateFormat('d MMM').format(now);
    String selectedDate = DateFormat('d MMM').format(this);
    if (currentDate == selectedDate) {
      return TODAY;
    }
    return selectedDate;
  }

  String getRequestFormatDate() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
