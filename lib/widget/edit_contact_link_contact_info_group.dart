/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
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
        return ContactSelectionItem(label: label);
      },
      itemBuilder: (context, item) {
        return SelectionInfoGroupItem(
          item: item,
          valueGetter: () {
            return (item as ContactSelectionItem).value.displayName;
          },
          onPressed: () {},
        );
      },
    );
  }
}
