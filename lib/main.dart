/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(CupertinoContactsApp());
}

class CupertinoContactsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    return CupertinoApp(
      title: '通讯录',
      theme: themeData.copyWith(
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        textTheme: textTheme.copyWith(
          textStyle: textTheme.textStyle.copyWith(
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.label,
              context,
            ),
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
      supportedLocales: [
        Locale('zh', 'CN'),
      ],
      routes: RouteProvider.routes,
      initialRoute: RouteProvider.home,
      onGenerateRoute: RouteProvider.buildGenerateRoute(context),
      onUnknownRoute: RouteProvider.unknownRoute,
    );
  }
}
