/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

class TimeInterval {
  static DateTime timeIntervalSince(DateTime dateTime, {int year = 1970, bool isUtc = false}) {
    assert(dateTime != null);
    assert(year >= 1970);
    assert(isUtc != null);
    if (isUtc) {
      return DateTime.utc(
        dateTime.year - (year - 1970),
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
        dateTime.millisecond,
        dateTime.microsecond,
      );
    } else {
      return DateTime(
        dateTime.year - (year - 1970),
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
        dateTime.millisecond,
        dateTime.microsecond,
      );
    }
  }

  static DateTime timeIntervalSinceAsIOS(DateTime dateTime, {int year = 2001, bool isUtc = false}) {
    assert(dateTime != null);
    final currentYear = dateTime.year;
    final currentMonth = dateTime.month;
    if (currentYear % 4 == 0 && currentYear % 100 != 0 && currentMonth <= 2) {
      dateTime = dateTime.subtract(const Duration(days: 1));
    }
    return timeIntervalSince(dateTime, year: year, isUtc: isUtc);
  }
}
