/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/1.
///
/// 添加联系人-常用的按钮
class EditContactNormalButton extends StatelessWidget {
  const EditContactNormalButton({
    Key key,
    @required this.text,
    this.isDestructiveAction = false,
    this.onPressed,
  })  : assert(text != null),
        assert(isDestructiveAction != null),
        super(key: key);

  final String text;
  final bool isDestructiveAction;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final themeData = CupertinoTheme.of(context);
    var actionTextStyle = themeData.textTheme.actionTextStyle;
    if (isDestructiveAction) {
      actionTextStyle = actionTextStyle.copyWith(
        color: CupertinoColors.destructiveRed,
      );
    }
    return CupertinoButton(
      minSize: 44,
      padding: const EdgeInsets.only(
        left: 16,
        right: 10,
      ),
      borderRadius: BorderRadius.zero,
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      onPressed: onPressed,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: actionTextStyle,
        ),
      ),
    );
  }
}
