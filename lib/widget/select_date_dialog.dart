/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

showSelectDateDialog(BuildContext context, {DateTime initialDate, ValueChanged<DateTime> onDateChanged}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return Container(
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.secondarySystemGroupedBackground,
          context,
        ),
        child: SafeArea(
          top: false,
          child: WidgetGroup(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            divider: CupertinoDivider(),
            children: [
              Container(
                height: 44,
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.systemGroupedBackground,
                  context,
                ),
                alignment: Alignment.centerLeft,
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text('关闭'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 240,
                child: CupertinoDatePicker(
                  initialDateTime: initialDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: onDateChanged,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
