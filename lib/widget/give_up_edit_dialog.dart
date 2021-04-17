/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/1.
///
/// 放弃编辑确认对话框

Future<bool> showGriveUpEditDialog(BuildContext context) {
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        message: const Text('您确定要放弃此新联系人吗？'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('放弃更改'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text(
            '继续编辑',
          ),
        ),
      );
    },
  );
}
