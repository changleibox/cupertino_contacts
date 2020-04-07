/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';

showAddEmergencyContactDialog(BuildContext context, List<Item> phones) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: Text('您要为紧急联系人添加哪个电话号码？'),
        actions: phones.map((e) {
          return CupertinoActionSheetAction(
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
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8F8F8F),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text('取消'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    },
  );
}
