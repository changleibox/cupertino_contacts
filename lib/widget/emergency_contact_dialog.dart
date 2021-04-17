/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';

Future<void> showAddEmergencyContactDialog(BuildContext context, List<Item> phones) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: const Text('您要为紧急联系人添加哪个电话号码？'),
        actions: phones.map((e) {
          return CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: WidgetGroup.spacing(
              alignment: MainAxisAlignment.center,
              direction: Axis.vertical,
              children: [
                Text(
                  e.label,
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
                Text(
                  e.value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8F8F8F),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
      );
    },
  );
}
