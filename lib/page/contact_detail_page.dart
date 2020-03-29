/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/30.
///
/// 联系人详情
class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({Key key}) : super(key: key);

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('联系人'),
        previousPageTitle: '通讯录',
        trailing: CupertinoButton(
          child: Text('编辑'),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: () {
            Navigator.pushNamed(context, RouteProvider.editContact);
          },
        ),
      ),
      child: Container(),
    );
  }
}
