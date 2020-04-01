/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:cupertinocontacts/page/edit_contact_avatar_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class EditContactAvatarPresenter extends Presenter<EditContactAvatarPage> {
  File picture;

  onAllPicturePressed() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value == null) {
        return;
      }
      picture = value;
      notifyDataSetChanged();
    });
  }

  onCancelPressed() {
    Navigator.maybePop(context);
  }

  onDonePressed() {
    Navigator.pop(context, picture);
  }
}
