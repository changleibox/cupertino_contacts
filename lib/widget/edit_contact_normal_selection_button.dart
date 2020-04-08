/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/1.
///
/// 添加联系人-常用的选择按钮
class EditContactNormalSelectionButton extends StatelessWidget {
  final NormalSelectionContactInfo info;

  const EditContactNormalSelectionButton({
    Key key,
    @required this.info,
  })  : assert(info != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var actionTextStyle = themeData.textTheme.actionTextStyle;
    return CupertinoButton(
      minSize: 44,
      padding: EdgeInsets.only(
        left: 16,
        right: 10,
      ),
      borderRadius: BorderRadius.zero,
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          info.name,
          style: actionTextStyle,
        ),
      ),
      onPressed: () {},
    );
  }
}
