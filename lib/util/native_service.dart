/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/util/time_interval.dart';
import 'package:url_launcher/url_launcher.dart';

class NativeService {
  static Future<bool> message(String account) {
    return _launch('sms:$account');
  }

  static Future<bool> call(String phone) {
    return _launch('tel:$phone');
  }

  static Future<bool> faceTime(String account) {
    return _launch('facetime:$account');
  }

  static Future<bool> email(String account) {
    return _launch('mailto:$account');
  }

  static Future<bool> maps(String address) {
    return _launch('maps:${'q=${Uri.encodeComponent(address)}'}');
  }

  static Future<bool> calendar(DateTime dateTime) {
    var timeIntervalSince = TimeInterval.timeIntervalSinceAsIOS(dateTime, isUtc: true);
    return _launch('mailto:${timeIntervalSince.millisecondsSinceEpoch / 1000}');
  }

  static Future<bool> _launch(String urlString) {
    return launch(urlString);
  }
}
