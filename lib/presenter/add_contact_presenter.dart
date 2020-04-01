/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/add_contact_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:flutter/cupertino.dart';

class AddContactPresenter extends Presenter<AddContactPage> {
  onCancelPressed() {
    showCupertinoModalPopup(
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
    ).then((value) {
      if (value) {
        Navigator.maybePop(context);
      }
    });
  }

  onDonePressed() {
    Navigator.maybePop(context);
  }
}