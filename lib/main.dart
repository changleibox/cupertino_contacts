/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/cupertino_contacts_page.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(CupertinoContactsApp());
}

class CupertinoContactsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: '通讯录',
      theme: CupertinoTheme.of(context),
      home: CupertinoContactsPage(),
    );
  }
}
