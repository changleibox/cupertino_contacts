/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(CupertinoContactsApp());
}

class CupertinoContactsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeData = CupertinoTheme.of(context);
    final textTheme = themeData.textTheme;
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
            height: 1.5,
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
      ],
      routes: RouteProvider.routes,
      initialRoute: RouteProvider.launcher,
      onGenerateRoute: RouteProvider.buildGenerateRoute(context),
      onUnknownRoute: RouteProvider.unknownRoute,
    );
  }
}
