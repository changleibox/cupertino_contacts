/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/presenter/edit_contact_avatar_presenter.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/1.
///
/// 编辑联系人头像
class EditContactAvatarPage extends StatefulWidget {
  const EditContactAvatarPage({Key key}) : super(key: key);

  @override
  _EditContactAvatarPageState createState() => _EditContactAvatarPageState();
}

class _EditContactAvatarPageState extends PresenterState<EditContactAvatarPage, EditContactAvatarPresenter> {
  _EditContactAvatarPageState() : super(EditContactAvatarPresenter());

  @override
  Widget builds(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('新建联系人'),
        backgroundColor: CupertinoColors.tertiarySystemBackground,
        border: null,
        leading: NavigationBarAction(
          child: Text('取消'),
          onPressed: presenter.onCancelPressed,
        ),
        trailing: NavigationBarAction(
          child: Text('完成'),
          onPressed: presenter.onDonePressed,
        ),
      ),
      child: Container(),
    );
  }
}
