/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/launcher_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class LauncherPresenter extends Presenter<LauncherPage> {
  @override
  void postFrameCallback() {
    _requestPermission().then((value) {
      Navigator.pushNamedAndRemoveUntil(context, RouteProvider.home, (route) => false);
    }).catchError((_) {
      showText('没有操作权限', context);
    });
    super.postFrameCallback();
  }

  Future<void> _requestPermission() async {
    await Future.delayed(Duration(seconds: 3));
    var permissionHandler = PermissionHandler();
    await permissionHandler.requestPermissions([PermissionGroup.contacts]);
    var permissionStatus = await permissionHandler.checkPermissionStatus(PermissionGroup.contacts);
    if (permissionStatus != PermissionStatus.granted) {
      return Future.error('Permission denial.');
    }
  }
}
