/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/presenter/launcher_presenter.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/10.
///
/// 启动页
class LauncherPage extends StatefulWidget {
  LauncherPage({Key key}) : super(key: key);

  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends PresenterState<LauncherPage, LauncherPresenter> {
  _LauncherPageState() : super(LauncherPresenter());

  @override
  Widget builds(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      child: Center(
        child: Text(
          '通讯录',
          style: TextStyle(
            fontSize: 26,
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.label,
              context,
            ),
          ),
        ),
      ),
    );
  }
}
