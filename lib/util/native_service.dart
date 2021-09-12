/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/util/time_interval.dart';
import 'package:url_launcher/url_launcher.dart';

class NativeService {
  const NativeService._();

  static Future<bool> url(String url) {
    final uri = Uri.parse(url.startsWith('http') ? url : 'http://$url');
    return _launch(uri);
  }

  static Future<bool> message(String account) {
    final uri = Uri(
      scheme: 'sms',
      path: account,
    );
    return _launch(uri);
  }

  static Future<bool> call(String phone) {
    final uri = Uri(
      scheme: 'tel',
      path: phone,
    );
    return _launch(uri);
  }

  static Future<bool> faceTime(String account) {
    final uri = Uri(
      scheme: 'facetime',
      path: account,
    );
    return _launch(uri);
  }

  static Future<bool> email(String account) {
    final uri = Uri(
      scheme: 'mailto',
      path: account,
    );
    return _launch(uri);
  }

  static Future<bool> maps(String address) {
    final uri = Uri(
      scheme: 'maps',
      queryParameters: <String, dynamic>{
        'q': address,
      },
    );
    return _launch(uri);
  }

  static Future<bool> calendar(DateTime dateTime) {
    final timeIntervalSince = TimeInterval.timeIntervalSinceAsIOS(dateTime, isUtc: true);
    final timeInterval = timeIntervalSince.millisecondsSinceEpoch / 1000;
    final uri = Uri(
      scheme: 'calshow',
      path: timeInterval.toString(),
    );
    return _launch(uri);
  }

  static Future<bool> _launch(Uri uri) {
    return launch(uri.toString());
  }
}
