/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/cupertino_contacts_page.dart';
import 'package:cupertinocontacts/page/launcher_page.dart';
import 'package:cupertinocontacts/route/dialog_route.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2019-12-17.
///
/// 路由提供者
class RouteProvider {
  RouteProvider._();

  static const String launcher = Navigator.defaultRouteName;
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    launcher: (context) => const LauncherPage(),
    home: (context) => const CupertinoContactsPage(),
  };

  static RouteFactory buildGenerateRoute(BuildContext context) {
    return (RouteSettings settings) {
      final name = settings.name;
      final pageContentBuilder = RouteProvider.routes[name];
      if (pageContentBuilder != null) {
        final Route route = buildRoute<dynamic>(
          pageContentBuilder(context),
          settings: settings,
        );
        return route;
      }
      return null;
    };
  }

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return DialogRoute<dynamic>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CupertinoAlertDialog(
          title: const Text('提示'),
          content: const Text('正在加急开发中，请耐心等待'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('知道了'),
            ),
          ],
        );
      },
    );
  }

  static PageRoute<T> buildRoute<T>(
    Widget widget, {
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    String title,
  }) {
    return CupertinoPageRoute<T>(
      fullscreenDialog: fullscreenDialog,
      settings: settings,
      maintainState: maintainState,
      title: title,
      builder: (context) {
        return widget;
      },
    );
  }
}
