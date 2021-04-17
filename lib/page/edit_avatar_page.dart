/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/avatar.dart';
import 'package:cupertinocontacts/presenter/edit_avatar_presenter.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/nav_bar.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/30.
///
/// 编辑头像
const double _buttonRadius = 14;
const double _buttonHeight = 56;
const double _spacing = 10;

class EditAvatarPage extends StatefulWidget {
  const EditAvatarPage({
    Key key,
    @required this.avatar,
    this.editable = true,
    this.isFirst = true,
  })  : assert(avatar != null),
        assert(editable != null),
        assert(isFirst != null),
        super(key: key);

  final Uint8ListAvatar avatar;
  final bool editable;
  final bool isFirst;

  @override
  _EditAvatarPageState createState() => _EditAvatarPageState();
}

class _EditAvatarPageState extends PresenterState<EditAvatarPage, EditAvatarPresenter> {
  _EditAvatarPageState() : super(EditAvatarPresenter());

  @override
  Widget builds(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemGroupedBackground,
      navigationBar: SupportNavigationBar(
        automaticallyImplyLeading: false,
        backgroundColor: CupertinoColors.secondarySystemGroupedBackground,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: () {
            Navigator.maybePop(context);
          },
          child: const Text('完成'),
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
                bytes: widget.avatar.avatar,
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
                divider: const SizedBox(
                  height: _spacing,
                ),
                children: [
                  _CupertinoSheetAction(
                    text: '指定给联系人',
                    onPressed: presenter.onFormulatePressed,
                  ),
                  if (widget.editable)
                    _CupertinoSheetAction(
                      text: '编辑',
                      onPressed: presenter.onEditPressed,
                    ),
                  if (widget.editable)
                    _CupertinoSheetAction(
                      text: '复制',
                      onPressed: presenter.onCopyPressed,
                    ),
                  if (!widget.isFirst)
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
  const _CupertinoSheetAction({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.isDestructive = false,
  })  : assert(text != null),
        assert(isDestructive != null),
        super(key: key);

  final String text;
  final VoidCallback onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final textTheme = CupertinoTheme.of(context).textTheme;
    final actionTextStyle = textTheme.actionTextStyle.copyWith(
      fontSize: 20,
    );
    return CupertinoButton(
      minSize: _buttonHeight,
      padding: EdgeInsets.zero,
      color: CupertinoColors.tertiarySystemGroupedBackground,
      borderRadius: BorderRadius.circular(_buttonRadius),
      onPressed: onPressed,
      child: Text(
        text,
        style: isDestructive
            ? actionTextStyle.copyWith(
                color: CupertinoColors.destructiveRed,
              )
            : actionTextStyle,
      ),
    );
  }
}
