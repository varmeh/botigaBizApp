import 'package:intl/intl.dart';

const TODAY = 'TODAY';

extension DateExtension on DateTime {
  String getLongformatDateWithTime() {
    return DateFormat('d MMM, y hh:mm a').format(this.toLocal());
  }

  String getDate() {
    return DateFormat('d MMM').format(this.toLocal());
  }

  String getTodayOrSelectedDate() {
    final now = new DateTime.now();
    String currentDate = DateFormat('d MMM').format(now.toLocal());
    String selectedDate = DateFormat('d MMM').format(this.toLocal());
    if (currentDate == selectedDate) {
      return TODAY;
    }
    return selectedDate;
  }

  String getRequestFormatDate() {
    return DateFormat('yyyy-MM-dd').format(this.toLocal());
  }
}
