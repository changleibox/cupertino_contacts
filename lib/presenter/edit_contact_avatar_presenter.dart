/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/page/edit_contact_avatar_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/widget/give_up_edit_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class EditContactAvatarPresenter extends Presenter<EditContactAvatarPage> {
  Uint8List picture;

  @override
  void initState() {
    picture = widget.picture;
    super.initState();
  }

  onAllPicturePressed() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value == null) {
        return;
      }
      picture = value.readAsBytesSync();
      notifyDataSetChanged();
    });
  }

  onCancelPressed() {
    if (picture == widget.picture) {
      Navigator.maybePop(context);
    } else {
      showGriveUpEditDialog(context).then((value) {
        if (value ?? false) {
          Navigator.maybePop(context);
        }
      });
    }
  }

  onDonePressed() {
    Navigator.pop(context, picture);
  }
}
