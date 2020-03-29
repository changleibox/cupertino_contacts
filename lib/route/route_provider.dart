/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/add_contact_page.dart';
import 'package:cupertinocontacts/page/contact_detail_page.dart';
import 'package:cupertinocontacts/page/contact_group_page.dart';
import 'package:cupertinocontacts/page/cupertino_contacts_page.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/route/dialog_route.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2019-12-17.
///
/// 路由提供者
class RouteProvider {
  RouteProvider._();

  static const String home = Navigator.defaultRouteName;
  static const String addContact = '/addContact';
  static const String editContact = '/editContact';
  static const String contactDetail = '/contactDetail';
  static const String contactGroup = '/contactGroup';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => CupertinoContactsPage(),
    addContact: (context) => AddContactPage(),
    editContact: (context) => EditContactPage(),
    contactDetail: (context) => ContactDetailPage(),
    contactGroup: (context) => ContactGroupPage(),
  };

  static RouteFactory buildGenerateRoute(BuildContext context) {
    return (RouteSettings settings) {
      final String name = settings.name;
      final WidgetBuilder pageContentBuilder = RouteProvider.routes[name];
      if (pageContentBuilder != null) {
        final Route route = buildRoute(
          pageContentBuilder(context),
          settings: settings,
        );
        return route;
      }
      return null;
    };
  }

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return DialogRoute(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CupertinoAlertDialog(
          title: Text('提示'),
          content: Text('正在加急开发中，请耐心等待'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('知道了'),
              onPressed: () => Navigator.pop(context),
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
