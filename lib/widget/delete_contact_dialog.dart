/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';

Future<bool> showDeleteContactDialog(BuildContext context, Contact contact) {
  assert(contact?.identifier != null);
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('删除联系人'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('取消'),
        ),
      );
    },
  );
}
