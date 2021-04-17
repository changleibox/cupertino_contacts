/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 标题栏按钮
class NavigationBarAction extends StatelessWidget {
  const NavigationBarAction({
    Key key,
    @required this.child,
    this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      minSize: 0,
      onPressed: onPressed,
      child: child,
    );
  }
}
