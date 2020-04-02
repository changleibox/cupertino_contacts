/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/page/edit_contact_avatar_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/widget/give_up_edit_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditContactAvatarPresenter extends Presenter<EditContactAvatarPage> {
  final _proposals = List<Uint8List>();

  Uint8List picture;

  Iterable<Uint8List> get proposals => _proposals;

  @override
  void initState() {
    picture = widget.picture;
    if (picture != null) {
      _proposals.add(picture);
    }
    rootBundle.load(Images.ic_default_avatar).then((value) {
      _proposals.insert(0, value.buffer.asUint8List());
      notifyDataSetChanged();
    });
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
