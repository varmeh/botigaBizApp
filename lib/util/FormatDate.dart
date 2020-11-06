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

  DateTime convertStringToDate(String date) {
    if (date == TODAY) {
      return DateTime.now();
    }
    return DateFormat('d MMM, y').parse(date);
  }

  String getRequestFormatDate() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String getShortDateFromDate(String slectedDate) {
    List<String> dateArr = slectedDate.split(",");
    if (dateArr.length > 0) {
      return dateArr.first;
    }
    return '';
  }
}

class FormatDate {
  static String getLongformatDateWithTime(DateTime date) {
    return DateFormat("d MMM, y hh:mm a").format(date);
  }

  static String getDate(DateTime date) {
    return DateFormat("d MMM").format(date);
  }

  static String getTodayOrSelectedDate(DateTime date) {
    final now = new DateTime.now();
    String currentDate = DateFormat('d MMM, y').format(now);
    String selectedDate = DateFormat('d MMM, y').format(date);
    if (currentDate == selectedDate) {
      return TODAY;
    }
    return selectedDate;
  }

  static DateTime convertStringToDate(String date) {
    if (date == TODAY) {
      return DateTime.now();
    }
    return DateFormat('d MMM, y').parse(date);
  }

  static String getRequestFormatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String getShortDateFromDate(String slectedDate) {
    List<String> dateArr = slectedDate.split(",");
    if (dateArr.length > 0) {
      return dateArr.first;
    }
    return '';
  }
}
