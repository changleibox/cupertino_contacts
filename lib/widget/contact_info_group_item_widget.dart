/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-自定义信息
class ContactInfoGroupItemWidget extends StatelessWidget {
  final GroupItemBuilder builder;
  final ContactInfoGroup infoGroup;
  final GroupItem item;
  final VoidCallback onDeletePressed;

  const ContactInfoGroupItemWidget({
    Key key,
    @required this.infoGroup,
    @required this.item,
    this.onDeletePressed,
    this.builder,
  })  : assert(infoGroup != null),
        assert(item != null),
        assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;
    var actionTextStyle = textTheme.actionTextStyle;
    return WidgetGroup.spacing(
      spacing: 10,
      children: [
        CupertinoButton(
          child: Icon(
            CupertinoIcons.minus_circled,
            color: CupertinoColors.systemRed,
          ),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: onDeletePressed,
        ),
        CupertinoButton(
          minSize: 44,
          borderRadius: BorderRadius.zero,
          padding: EdgeInsets.zero,
          child: WidgetGroup.spacing(
            spacing: 10,
            children: [
              Text(
                item.label,
                style: actionTextStyle.copyWith(
                  fontSize: 15,
                ),
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
                  separatorColor,
                  context,
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        Expanded(
          child: DefaultTextStyle(
            style: textStyle.copyWith(
              color: themeData.primaryColor,
            ),
            child: Builder(
              builder: (context) => builder(context, item),
            ),
          ),
        ),
      ],
    );
  }
}
