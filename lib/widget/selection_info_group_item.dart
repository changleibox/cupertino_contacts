/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/contact_item_container.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/8.
///
/// 编辑联系人
class SelectionInfoGroupItem extends StatelessWidget {
  final GroupItem item;
  final VoidCallback onPressed;
  final ValueGetter valueGetter;

  const SelectionInfoGroupItem({
    Key key,
    @required this.item,
    this.valueGetter,
    this.onPressed,
  })  : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = DefaultTextStyle.of(context).style;
    if (item.isEmpty) {
      style = TextStyle(
        color: CupertinoDynamicColor.resolve(
          placeholderColor,
          context,
        ),
      );
    }
    return ContactItemContainer(
      child: CupertinoButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
        minSize: 0,
        child: WidgetGroup.spacing(
          alignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                item.isEmpty ? item.label : valueGetter == null ? item.value : valueGetter(),
                style: style,
              ),
            ),
            Icon(
              CupertinoIcons.forward,
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.secondaryLabel,
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
