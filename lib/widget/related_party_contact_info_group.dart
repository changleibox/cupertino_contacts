/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/page/home_page.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/editable_selection_info_group_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
class RelatedPartyContactInfoGroup extends StatelessWidget {
  const RelatedPartyContactInfoGroup({
    Key key,
    @required this.infoGroup,
    this.inputType = TextInputType.text,
  })  : assert(infoGroup != null),
        assert(inputType != null),
        super(key: key);

  final ContactInfoGroup<EditableSelectionItem> infoGroup;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return ContactInfoGroupWidget(
      infoGroup: infoGroup,
      itemFactory: (index, label) async {
        return EditableSelectionItem(label: label);
      },
      itemBuilder: (context, item) {
        return EditableSelectionInfoGroupItem(
          controller: (item as EditableSelectionItem).controller,
          name: item.label.labelName,
          inputType: inputType,
          onPressed: () async {
            final contact = await Navigator.push<Contact>(
              context,
              RouteProvider.buildRoute(
                const HomePage(
                  launchMode: HomeLaunchMode.onlySelection,
                ),
                fullscreenDialog: true,
              ),
            );
            if (contact != null) {
              item.value = contact.displayName;
            }
          },
        );
      },
    );
  }
}
