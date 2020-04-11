/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/page/cupertino_contacts_page.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/selection_info_group_item.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/10.
///
/// 链接联系人
class EditContactLinkContactInfoGroup extends StatelessWidget {
  final ContactInfoGroup infoGroup;

  const EditContactLinkContactInfoGroup({
    Key key,
    @required this.infoGroup,
  })  : assert(infoGroup != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContactInfoGroupWidget(
      infoGroup: infoGroup,
      changeLabelInterceptor: (context, item) => ChangeLabelType.disable,
      itemFactory: (index, label) async {
        var contact = await Navigator.push(
          context,
          RouteProvider.buildRoute(
            CupertinoContactsPage(
              launchMode: ContactLaunchMode.selection,
            ),
            fullscreenDialog: true,
          ),
        );
        return contact == null ? null : ContactSelectionItem(label: label, value: contact);
      },
      itemBuilder: (context, item) {
        return SelectionInfoGroupItem(
          item: item,
          hasStartDivier: false,
          valueGetter: () {
            return (item as ContactSelectionItem).value?.displayName;
          },
          onPressed: () {},
        );
      },
    );
  }
}
