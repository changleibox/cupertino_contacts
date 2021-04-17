/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

Future<void> showSelectDateDialog(BuildContext context, {DateTime initialDate, ValueChanged<DateTime> onDateChanged}) {
  return showCupertinoModalPopup<void>(
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
            divider: const CupertinoDivider(),
            children: [
              Container(
                height: 44,
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.systemGroupedBackground,
                  context,
                ),
                alignment: Alignment.centerLeft,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('关闭'),
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
