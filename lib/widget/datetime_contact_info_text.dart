/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-自定义信息日期选择
class DateTimeContactInfoText extends StatelessWidget {
  static final _dateFormat = DateFormat('MM月dd日');

  final String name;
  final DateTimeItem item;
  final VoidCallback onDeletePressed;
  final TextInputType inputType;

  const DateTimeContactInfoText({
    Key key,
    @required this.name,
    @required this.item,
    this.onDeletePressed,
    this.inputType = TextInputType.text,
  })  : assert(name != null),
        assert(item != null),
        assert(inputType != null),
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
                  separatorColor.withOpacity(0.1),
                  context,
                ),
              ),
            ],
          ),
          onPressed: () {},
        ),
        Expanded(
          child: Container(
            height: 44,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: Text(
              _dateFormat.format(item.value),
              style: textStyle.copyWith(
                color: themeData.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
