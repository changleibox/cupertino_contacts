/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 标题栏按钮
class NavigationBarAction extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const NavigationBarAction({
    Key key,
    @required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: child,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      minSize: 0,
      onPressed: onPressed,
    );
  }
}
