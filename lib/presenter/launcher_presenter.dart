/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:async';

import 'package:cupertinocontacts/page/launcher_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class LauncherPresenter extends Presenter<LauncherPage> {
  Timer _timer;

  @override
  void postFrameCallback() {
    _timer = Timer(const Duration(seconds: 2), () {
      _requestPermission().then((value) {
        Navigator.pushReplacementNamed(context, RouteProvider.home);
      }).catchError((dynamic _) {
        _showNotPermissionDialog();
      });
    });
    super.postFrameCallback();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.contacts.request();
    if (status != PermissionStatus.granted) {
      return Future.error('Permission denied.');
    }
  }

  Future<void> _showNotPermissionDialog() {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('提示'),
          content: const Text('没有通讯录权限，请在设置里授权，才能正常使用'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              child: const Text('去设置'),
            ),
          ],
        );
      },
    );
  }
}
