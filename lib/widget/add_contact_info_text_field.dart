/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-自定义信息输入框
class AddContactInfoTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 10,
      ),
      child: WidgetGroup.spacing(
        spacing: 10,
        children: [
          CupertinoButton(
            minSize: 44,
            borderRadius: BorderRadius.zero,
            padding: EdgeInsets.zero,
            child: WidgetGroup.spacing(
              spacing: 10,
              children: [
                Icon(
                  CupertinoIcons.minus_circled,
                  color: CupertinoColors.systemRed,
                ),
                Text(
                  '住宅',
                ),
                Icon(
                  CupertinoIcons.forward,
                  color: CupertinoDynamicColor.resolve(
                    CupertinoColors.secondaryLabel,
                    context,
                  ),
                ),
                Container(
                  width: 0.5,
                  height: 32,
                  color: CupertinoDynamicColor.resolve(
                    separatorColor.withOpacity(0.1),
                    context,
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          Expanded(
            child: SizedBox(
              height: 44,
              child: CupertinoTextField(
                placeholder: '姓氏',
                placeholderStyle: TextStyle(
                  color: CupertinoDynamicColor.resolve(
                    placeholderColor,
                    context,
                  ),
                ),
                decoration: BoxDecoration(
                  color: CupertinoColors.tertiarySystemBackground,
                ),
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                clearButtonMode: OverlayVisibilityMode.editing,
                scrollPadding: EdgeInsets.only(
                  bottom: 54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
