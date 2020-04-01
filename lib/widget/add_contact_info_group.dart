/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/add_contact_group_container.dart';
import 'package:cupertinocontacts/widget/add_contact_info_button.dart';
import 'package:cupertinocontacts/widget/add_contact_info_text_field.dart';
import 'package:flutter/material.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
class AddContactInfoGroup extends StatefulWidget {
  final ContactInfoGroup infoGroup;

  const AddContactInfoGroup({
    Key key,
    @required this.infoGroup,
  })  : assert(infoGroup != null),
        super(key: key);

  @override
  _AddContactInfoGroupState createState() => _AddContactInfoGroupState();
}

class _AddContactInfoGroupState extends State<AddContactInfoGroup> {
  @override
  Widget build(BuildContext context) {
    var itemCount = (widget.infoGroup.items?.length ?? 0) + 1;
    return AddContactGroupContainer(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index < itemCount - 1) {
          return AddContactInfoTextField();
        }
        return AddContactInfoButton(
          text: '添加${widget.infoGroup.name}',
          onPressed: () {
            widget.infoGroup.items.add(EditableItem());
            setState(() {});
          },
        );
      },
    );
  }
}
