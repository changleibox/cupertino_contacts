/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-按钮
class EditContactInfoButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const EditContactInfoButton({
    Key key,
    @required this.text,
    this.onPressed,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textStyle = themeData.textTheme.textStyle;
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
            text,
            style: textStyle.copyWith(
              fontSize: 15,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
