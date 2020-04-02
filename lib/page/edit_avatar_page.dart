/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/presenter/edit_avatar_presenter.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/30.
///
/// 编辑头像
const double _buttonRadius = 14;
const double _buttonHeight = 56;
const double _spacing = 10;

class EditAvatarPage extends StatefulWidget {
  final Uint8List avatar;
  final bool isDefault;

  const EditAvatarPage({
    Key key,
    @required this.avatar,
    this.isDefault = false,
  })  : assert(avatar != null),
        assert(isDefault != null),
        super(key: key);

  @override
  _EditAvatarPageState createState() => _EditAvatarPageState();
}

class _EditAvatarPageState extends PresenterState<EditAvatarPage, EditAvatarPresenter> {
  _EditAvatarPageState() : super(EditAvatarPresenter());

  @override
  Widget builds(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        backgroundColor: CupertinoColors.secondarySystemBackground,
        trailing: CupertinoButton(
          child: Text('完成'),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      child: SafeArea(
        child: WidgetGroup.spacing(
          alignment: MainAxisAlignment.center,
          direction: Axis.vertical,
          children: [
            Expanded(
              child: CupertinoCircleAvatar.memory(
                assetName: Images.ic_default_avatar,
                bytes: widget.avatar,
                borderSide: BorderSide.none,
                size: 220,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: _spacing,
              ),
              height: _buttonHeight * 4 + _spacing * 3,
              child: WidgetGroup(
                alignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                divider: SizedBox(
                  height: _spacing,
                ),
                children: [
                  _CupertinoSheetAction(
                    text: '指定给联系人',
                    onPressed: presenter.onFormulatePressed,
                  ),
                  if (!widget.isDefault)
                    _CupertinoSheetAction(
                      text: '编辑',
                      onPressed: presenter.onEditPressed,
                    ),
                  if (!widget.isDefault)
                    _CupertinoSheetAction(
                      text: '复制',
                      onPressed: presenter.onCopyPressed,
                    ),
                  if (!widget.isDefault)
                    _CupertinoSheetAction(
                      text: '删除',
                      isDestructive: true,
                      onPressed: presenter.onDeletePressed,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CupertinoSheetAction extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDestructive;

  const _CupertinoSheetAction({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.isDestructive = false,
  })  : assert(text != null),
        assert(isDestructive != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = CupertinoTheme.of(context).textTheme;
    var actionTextStyle = textTheme.actionTextStyle.copyWith(
      fontSize: 20,
    );
    return CupertinoButton(
      child: Text(
        text,
        style: isDestructive
            ? actionTextStyle.copyWith(
                color: CupertinoColors.destructiveRed,
              )
            : actionTextStyle,
      ),
      minSize: _buttonHeight,
      padding: EdgeInsets.zero,
      color: CupertinoColors.tertiarySystemBackground,
      borderRadius: BorderRadius.circular(_buttonRadius),
      onPressed: onPressed,
    );
  }
}
