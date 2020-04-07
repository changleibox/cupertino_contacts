/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/util/time_interval.dart';
import 'package:url_launcher/url_launcher.dart';

class NativeService {
  static Future<bool> message(String account) {
    var uri = Uri(
      scheme: 'sms',
      path: account,
    );
    return _launch(uri);
  }

  static Future<bool> call(String phone) {
    var uri = Uri(
      scheme: 'tel',
      path: phone,
    );
    return _launch(uri);
  }

  static Future<bool> faceTime(String account) {
    var uri = Uri(
      scheme: 'facetime',
      path: account,
    );
    return _launch(uri);
  }

  static Future<bool> email(String account) {
    var uri = Uri(
      scheme: 'mailto',
      path: account,
    );
    return _launch(uri);
  }

  static Future<bool> maps(String address) {
    var uri = Uri(
      scheme: 'maps',
      queryParameters: {
        'q': address,
      },
    );
    return _launch(uri);
  }

  static Future<bool> calendar(DateTime dateTime) {
    var timeIntervalSince = TimeInterval.timeIntervalSinceAsIOS(dateTime, isUtc: true);
    var timeInterval = timeIntervalSince.millisecondsSinceEpoch / 1000;
    var uri = Uri(
      scheme: 'calshow',
      path: timeInterval.toString(),
    );
    return _launch(uri);
  }

  static Future<bool> _launch(Uri uri) {
    return launch(uri.toString());
  }
}
