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
  const SelectionInfoGroupItem({
    Key key,
    @required this.item,
    this.valueGetter,
    this.onPressed,
    this.hasStartDivier = true,
  })  : assert(item != null),
        assert(hasStartDivier != null),
        super(key: key);

  final GroupItem item;
  final VoidCallback onPressed;
  final ValueGetter<String> valueGetter;
  final bool hasStartDivier;

  @override
  Widget build(BuildContext context) {
    var value = item.value?.toString();
    if (valueGetter != null) {
      value = valueGetter();
    }
    final isInvalidValue = value == null || value.isEmpty;
    var style = DefaultTextStyle.of(context).style;
    if (isInvalidValue) {
      style = TextStyle(
        color: CupertinoDynamicColor.resolve(
          placeholderColor,
          context,
        ),
      );
    }
    Widget child = CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      minSize: 0,
      child: WidgetGroup.spacing(
        alignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                isInvalidValue ? item.label.labelName : value,
                style: style,
              ),
            ),
          ),
          Icon(
            CupertinoIcons.forward,
            size: 20,
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.tertiaryLabel,
              context,
            ),
          ),
        ],
      ),
    );
    if (hasStartDivier) {
      child = ContactItemContainer(
        child: child,
      );
    }
    return SizedBox(
      height: 44,
      child: child,
    );
  }
}
