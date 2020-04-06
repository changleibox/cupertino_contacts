/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

class TimeInterval {
  static DateTime timeIntervalSince(DateTime dateTime, {int year = 1970}) {
    assert(year >= 1970);
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

  static DateTime timeIntervalSinceAsIOS(DateTime dateTime, {int year = 2001}) {
    assert(year >= 1970);
    var timeIntervalSince = TimeInterval.timeIntervalSince(dateTime, year: year);
    var currentYear = dateTime.year;
    var timeIntervalSinceMonth = timeIntervalSince.month;
    var timeIntervalSinceDay = timeIntervalSince.day;
    if (currentYear % 4 == 0 && currentYear % 100 != 0 && timeIntervalSinceMonth <= 2) {
      timeIntervalSinceDay--;
    }
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
