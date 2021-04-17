/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/page/crop_image_page.dart';
import 'package:cupertinocontacts/page/edit_avatar_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:flutter/cupertino.dart';

enum EditAvatarType {
  formulate,
  edit,
  copy,
  delete,
}

class EditAvatarPresenter extends Presenter<EditAvatarPage> {
  void onFormulatePressed() {
    Navigator.pop(context, {
      'data': widget.avatar,
      'type': EditAvatarType.formulate,
    });
  }

  void onEditPressed() {
    Navigator.push<Uint8List>(
      context,
      RouteProvider.buildRoute(
        CropImagePage(bytes: widget.avatar.src),
        fullscreenDialog: true,
      ),
    ).then((value) {
      if (value == null) {
        return;
      }
      widget.avatar.target = value;
      Navigator.pop(context, {
        'data': widget.avatar,
        'type': EditAvatarType.edit,
      });
    });
  }

  void onCopyPressed() {
    Navigator.pop(context, {
      'data': widget.avatar,
      'type': EditAvatarType.copy,
    });
  }

  void onDeletePressed() {
    showCupertinoModalPopup<dynamic>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('删除'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('取消'),
          ),
        );
      },
    ).then((dynamic value) {
      if (value == true) {
        Navigator.pop(context, {
          'data': widget.avatar,
          'type': EditAvatarType.delete,
        });
      }
    });
  }
}
