/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

class TimeInterval {
  static DateTime timeIntervalSince(DateTime dateTime, {int year = 1970}) {
    assert(year >= 1970);
    final newDateTime = DateTime(
      dateTime.year - (year - 1970),
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
    return dateTime.isUtc ? newDateTime.toUtc() : newDateTime;
  }

  static DateTime timeIntervalSinceAsIOS(DateTime dateTime, {int year = 2001}) {
    assert(year >= 1970);
    var timeIntervalSince = TimeInterval.timeIntervalSince(dateTime, year: year).toLocal();
    var currentYear = dateTime.year;
    var timeIntervalSinceMonth = timeIntervalSince.month;
    var timeIntervalSinceDay = timeIntervalSince.day;
    if (currentYear % 4 == 0 && currentYear % 100 != 0 && timeIntervalSinceMonth <= 2) {
      timeIntervalSinceDay--;
    }
    final newDateTime = DateTime(
      timeIntervalSince.year,
      timeIntervalSinceMonth,
      timeIntervalSinceDay,
      timeIntervalSince.hour,
      timeIntervalSince.minute,
      timeIntervalSince.second,
      timeIntervalSince.millisecond,
      timeIntervalSince.microsecond,
    );
    return dateTime.isUtc ? newDateTime.toUtc() : newDateTime;
  }
}
