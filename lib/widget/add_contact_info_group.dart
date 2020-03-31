/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/add_contact_group_container.dart';
import 'package:cupertinocontacts/widget/add_contact_info_button.dart';
import 'package:cupertinocontacts/widget/add_contact_info_text_field.dart';
import 'package:flutter/material.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
class AddContactInfoGroup extends StatelessWidget {
  final int itemCount;
  final String buttonText;

  const AddContactInfoGroup({
    Key key,
    @required this.itemCount,
    @required this.buttonText,
  })  : assert(itemCount != null),
        assert(buttonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddContactGroupContainer(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index < itemCount - 1) {
          return AddContactInfoTextField();
        }
        return AddContactInfoButton(
          text: buttonText,
        );
      },
    );
  }
}
