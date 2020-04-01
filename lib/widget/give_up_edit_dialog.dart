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
        message: Text('您确定要放弃此新联系人吗？'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: Text('放弃更改'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: Text(
            '继续编辑',
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      );
    },
  );
}
