/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 新建联系人-默认输入框
class AddContactNormalTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          left: 16,
          right: 10,
        ),
        clearButtonMode: OverlayVisibilityMode.editing,
        textInputAction: TextInputAction.next,
        onEditingComplete: () {
          FocusScope.of(context).nextFocus();
        },
      ),
    );
  }
}
