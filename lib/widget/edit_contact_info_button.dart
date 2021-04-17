/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-按钮
class EditContactInfoButton extends StatelessWidget {
  const EditContactInfoButton({
    Key key,
    @required this.text,
    this.onPressed,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final themeData = CupertinoTheme.of(context);
    final textStyle = themeData.textTheme.textStyle;
    return CupertinoButton(
      minSize: 44,
      padding: const EdgeInsets.only(
        left: 16,
        right: 10,
      ),
      borderRadius: BorderRadius.zero,
      onPressed: onPressed,
      child: WidgetGroup.spacing(
        spacing: 10,
        children: [
          const Icon(
            Ionicons.ios_add_circle,
            color: CupertinoColors.systemGreen,
          ),
          Expanded(
            child: Text(
              text,
              style: textStyle.copyWith(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
