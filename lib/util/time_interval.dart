/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

class TimeInterval {
  static DateTime timeIntervalSince(DateTime dateTime, {int year = 1970, bool isUtc = false}) {
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
    assert(year >= 1970);
    var timeIntervalSince = TimeInterval.timeIntervalSince(dateTime, year: year);
    var currentYear = dateTime.year;
    var timeIntervalSinceMonth = timeIntervalSince.month;
    var timeIntervalSinceDay = timeIntervalSince.day;
    if (currentYear % 4 == 0 && currentYear % 100 != 0 && timeIntervalSinceMonth <= 2) {
      timeIntervalSinceDay--;
    }
    if (isUtc) {
      return DateTime.utc(
        timeIntervalSince.year,
        timeIntervalSinceMonth,
        timeIntervalSinceDay,
        timeIntervalSince.hour,
        timeIntervalSince.minute,
        timeIntervalSince.second,
        timeIntervalSince.millisecond,
        timeIntervalSince.microsecond,
      );
    } else {
      return DateTime(
        timeIntervalSince.year,
        timeIntervalSinceMonth,
        timeIntervalSinceDay,
        timeIntervalSince.hour,
        timeIntervalSince.minute,
        timeIntervalSince.second,
        timeIntervalSince.millisecond,
        timeIntervalSince.microsecond,
      );
    }
  }
}
