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

  Uint8List _picture;
  Uint8List _defaultAvatar;

  Iterable<Uint8List> get proposals => _proposals;

  Uint8List get picture => _picture;

  bool get isInvalidAvatar => _picture == null || _picture == _defaultAvatar;

  @override
  void initState() {
    rootBundle.load(Images.ic_default_avatar).then((value) {
      _defaultAvatar = value.buffer.asUint8List();
      _proposals.add(_defaultAvatar);
      if (widget.picture != null) {
        _proposals.add(widget.picture);
      }
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
          isDefault: Collections.equals(avatar, _defaultAvatar),
          isFirst: _proposals.indexOf(avatar) == 0,
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
        _picture = avatar;
        break;
      case EditAvatarType.edit:
        var editedData = result['editedData'];
        if (index >= 0 && index < _proposals.length) {
          _proposals.removeAt(index);
          _proposals.insert(index, editedData);
        } else {
          _proposals.add(editedData);
        }
        _picture = editedData;
        break;
      case EditAvatarType.copy:
        _proposals.insert(index + 1, avatar);
        _picture = avatar;
        break;
      case EditAvatarType.delete:
        _proposals.remove(avatar);
        var length = _proposals.length;
        _picture = index >= length ? _proposals[length - 1] : _proposals[index];
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
      if (Collections.equals(_picture, newPicture)) {
        return;
      }
      _picture = newPicture;
      _proposals.removeWhere((element) => Collections.equals(element, _defaultAvatar));
      _proposals.insert(0, _defaultAvatar);
      _proposals.add(_picture);
      notifyDataSetChanged();
    });
  }

  onCancelPressed() {
    if (Collections.equals(_picture, widget.picture)) {
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
    Navigator.pop(context, _picture);
  }
}
