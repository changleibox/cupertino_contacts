/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/30.
///
/// 联系人详情
class ContactDetailPage extends StatefulWidget {
  final Contact contact;

  const ContactDetailPage({
    Key key,
    @required this.contact,
  })  : assert(contact != null),
        super(key: key);

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
        trailing: NavigationBarAction(
          child: Text('编辑'),
          onPressed: () {
            Navigator.push(
              context,
              RouteProvider.buildRoute(
                EditContactPage(),
              ),
            );
          },
        ),
      ),
      child: SupportNestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: CupertinoCircleAvatar.memory(
                assetName: Images.ic_default_avatar,
                bytes: widget.contact.avatar,
                borderSide: BorderSide.none,
                size: 100,
              ),
            ),
          ];
        },
        body: ListView(
          children: <Widget>[],
        ),
      ),
    );
  }
}
