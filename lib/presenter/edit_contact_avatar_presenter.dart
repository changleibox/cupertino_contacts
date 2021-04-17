/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/model/avatar.dart';
import 'package:cupertinocontacts/page/crop_image_page.dart';
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
  final _proposals = <Uint8ListAvatar>[];

  Uint8ListAvatar _avatar;
  Uint8ListAvatar _defaultAvatar;

  Iterable<Uint8ListAvatar> get proposals => _proposals;

  Uint8ListAvatar get avatar => _avatar;

  bool get isChanged => !Collections.equals(_avatar?.avatar, widget.avatar);

  bool get isOnlyRead => _avatar == null || _avatar == _defaultAvatar;

  @override
  void initState() {
    rootBundle.load(Images.ic_default_avatar).then((value) {
      final uint8list = value.buffer.asUint8List();
      _defaultAvatar = Uint8ListAvatar(uint8list, editable: false);
      _proposals.add(_defaultAvatar);
      if (widget.avatar != null) {
        _avatar = Uint8ListAvatar(widget.avatar, editable: !Collections.equals(uint8list, widget.avatar));
        _proposals.add(_avatar);
      }
      notifyDataSetChanged();
    });
    super.initState();
  }

  void editPicture(Uint8ListAvatar avatar) {
    if (avatar == null) {
      return;
    }
    Navigator.push<dynamic>(
      context,
      RouteProvider.buildRoute<dynamic>(
        EditAvatarPage(
          avatar: avatar,
          editable: avatar.editable,
          isFirst: _proposals.indexOf(avatar) == 0,
        ),
        fullscreenDialog: true,
      ),
    ).then((dynamic result) {
      _onEditAvatarResult(avatar, result);
    });
  }

  void _onEditAvatarResult(Uint8ListAvatar avatar, dynamic result) {
    if (result == null || !(result is Map<String, dynamic>)) {
      return;
    }
    final editType = result['type'] as EditAvatarType;
    final data = result['data'] as Uint8ListAvatar;
    final index = _proposals.indexOf(avatar);
    switch (editType) {
      case EditAvatarType.formulate:
        _avatar = data;
        break;
      case EditAvatarType.edit:
        _avatar = data;
        break;
      case EditAvatarType.copy:
        _proposals.insert(index + 1, avatar);
        _avatar = data;
        break;
      case EditAvatarType.delete:
        _proposals.remove(data);
        final length = _proposals.length;
        _avatar = index >= length ? _proposals[length - 1] : _proposals[index];
        break;
    }
    notifyDataSetChanged();
  }

  void onAllPicturePressed() {
    ImagePicker().getImage(source: ImageSource.gallery).then((value) async {
      if (value == null) {
        return;
      }
      final src = await value.readAsBytes();
      final result = await Navigator.push<Uint8List>(
        context,
        RouteProvider.buildRoute(
          CropImagePage(bytes: src),
          fullscreenDialog: true,
        ),
      );
      if (result == null) {
        return;
      }
      _avatar = Uint8ListAvatar(src, target: result);
      _proposals.removeWhere((element) => Collections.equals(element.src, _defaultAvatar.src));
      _proposals.insert(0, _defaultAvatar);
      _proposals.add(_avatar);
      notifyDataSetChanged();
    });
  }

  void onCancelPressed() {
    if (!isChanged) {
      Navigator.maybePop(context);
    } else {
      showGriveUpEditDialog(context).then((value) {
        if (value ?? false) {
          Navigator.maybePop(context);
        }
      });
    }
  }

  void onDonePressed() {
    Navigator.pop(context, _avatar?.avatar);
  }
}
