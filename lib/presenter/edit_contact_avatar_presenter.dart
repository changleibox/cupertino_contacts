/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/page/edit_avatar_page.dart';
import 'package:cupertinocontacts/page/edit_contact_avatar_page.dart';
import 'package:cupertinocontacts/presenter/edit_avatar_presenter.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/util/collections.dart';
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

  void editPicture(Uint8List avatar) {
    if (avatar == null) {
      return;
    }
    Navigator.push(
      context,
      RouteProvider.buildRoute(
        EditAvatarPage(
          avatar: avatar,
          isDefault: _proposals.indexOf(avatar) == 0,
        ),
        fullscreenDialog: true,
      ),
    ).then(_onEditAvatarResult);
  }

  _onEditAvatarResult(dynamic result) {
    if (result == null || !(result is Map<String, dynamic>)) {
      return;
    }
    var editType = result['type'] as EditAvatarType;
    var avatar = result['data'] as Uint8List;
    var index = _proposals.indexOf(avatar);
    switch (editType) {
      case EditAvatarType.formulate:
        picture = avatar;
        break;
      case EditAvatarType.edit:
        _proposals.removeAt(index);
        _proposals.insert(index, avatar);
        picture = avatar;
        break;
      case EditAvatarType.copy:
        _proposals.insert(index + 1, avatar);
        picture = avatar;
        break;
      case EditAvatarType.delete:
        _proposals.remove(avatar);
        var length = _proposals.length;
        picture = index >= length ? _proposals[length - 1] : _proposals[index];
        break;
    }
    notifyDataSetChanged();
  }

  onAllPicturePressed() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      if (value == null) {
        return;
      }
      var newPicture = value.readAsBytesSync();
      if (Collections.equals(picture, newPicture)) {
        return;
      }
      picture = newPicture;
      _proposals.add(picture);
      notifyDataSetChanged();
    });
  }

  onCancelPressed() {
    if (Collections.equals(picture, widget.picture)) {
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
