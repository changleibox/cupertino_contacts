/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/editable_info_group_item.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
class EditContactInfoGroup extends StatelessWidget {
  const EditContactInfoGroup({
    Key key,
    @required this.infoGroup,
    this.inputType = TextInputType.text,
  })  : assert(infoGroup != null),
        assert(inputType != null),
        super(key: key);

  final ContactInfoGroup infoGroup;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return ContactInfoGroupWidget(
      infoGroup: infoGroup,
      itemFactory: (index, label) async {
        return EditableItem(label: label);
      },
      itemBuilder: (context, item) {
        return EditableInfoGroupItem(
          controller: (item as EditableItem).controller,
          name: item.label.labelName,
          inputType: inputType,
        );
      },
    );
  }
}
