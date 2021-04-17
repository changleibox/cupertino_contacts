/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/presenter/edit_contact_avatar_presenter.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/1.
///
/// 编辑联系人头像
const int _crossCount = 4;
const double _padding = 16;
const double _spacing = 24;

class EditContactAvatarPage extends StatefulWidget {
  const EditContactAvatarPage({Key key, this.avatar}) : super(key: key);

  final Uint8List avatar;

  @override
  _EditContactAvatarPageState createState() => _EditContactAvatarPageState();
}

class _EditContactAvatarPageState extends PresenterState<EditContactAvatarPage, EditContactAvatarPresenter> {
  _EditContactAvatarPageState() : super(EditContactAvatarPresenter());

  @override
  Widget builds(BuildContext context) {
    final textTheme = CupertinoTheme.of(context).textTheme;
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemGroupedBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.secondarySystemGroupedBackground,
        border: null,
        leading: NavigationBarAction(
          onPressed: presenter.onCancelPressed,
          child: const Text('取消'),
        ),
        trailing: NavigationBarAction(
          onPressed: presenter.isChanged ? presenter.onDonePressed : null,
          child: const Text('完成'),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: WidgetGroup(
          alignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          direction: Axis.vertical,
          divider: const CupertinoDivider(),
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 4,
                bottom: 16,
              ),
              child: WidgetGroup.spacing(
                spacing: 8,
                alignment: MainAxisAlignment.start,
                direction: Axis.vertical,
                children: [
                  CupertinoCircleAvatar.memory(
                    assetName: Images.ic_default_avatar,
                    bytes: presenter.avatar?.avatar,
                    borderSide: BorderSide.none,
                    size: 144,
                    onPressed: presenter.isOnlyRead
                        ? null
                        : () {
                            presenter.editPicture(presenter.avatar);
                          },
                  ),
                  CupertinoButton(
                    minSize: 14,
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.zero,
                    onPressed: () {
                      presenter.editPicture(presenter.avatar);
                    },
                    child: presenter.isOnlyRead
                        ? const SizedBox.shrink()
                        : Text(
                            '编辑',
                            style: TextStyle(
                              fontSize: 14,
                              color: CupertinoTheme.of(context).primaryColor,
                              height: 1.0,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      left: _padding,
                      top: 10,
                      right: _padding,
                      bottom: 24,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: WidgetGroup.spacing(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '建议',
                            style: textTheme.textStyle,
                          ),
                          CupertinoButton(
                            borderRadius: BorderRadius.zero,
                            padding: EdgeInsets.zero,
                            minSize: 0,
                            onPressed: presenter.onAllPicturePressed,
                            child: const Text('所有照片'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(
                      left: _padding,
                      right: _padding,
                      bottom: _padding + MediaQuery.of(context).padding.bottom,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final avatar = presenter.proposals.elementAt(index);
                          return CupertinoCircleAvatar.memory(
                            assetName: Images.ic_default_avatar,
                            bytes: avatar.avatar,
                            borderSide: BorderSide.none,
                            size: double.infinity,
                            onPressed: () {
                              presenter.editPicture(avatar);
                            },
                          );
                        },
                        childCount: presenter.proposals.length,
                        addAutomaticKeepAlives: true,
                        addRepaintBoundaries: true,
                        addSemanticIndexes: true,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _crossCount,
                        crossAxisSpacing: _spacing,
                        mainAxisSpacing: _spacing,
                      ),
                    ),
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
