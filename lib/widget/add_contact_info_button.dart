/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-按钮
class AddContactInfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      minSize: 44,
      padding: EdgeInsets.only(
        left: 16,
        right: 10,
      ),
      borderRadius: BorderRadius.zero,
      child: WidgetGroup.spacing(
        spacing: 10,
        children: [
          Icon(
            CupertinoIcons.add_circled_solid,
            color: CupertinoColors.systemGreen,
          ),
          Text(
            '添加电话',
            style: CupertinoTheme.of(context).textTheme.textStyle,
          ),
        ],
      ),
      onPressed: () {},
    );
  }
}
