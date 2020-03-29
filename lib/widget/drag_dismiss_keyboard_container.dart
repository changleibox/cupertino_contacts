/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/12.
///
/// 滚动隐藏键盘
class DragDismissKeyboardContainer extends StatefulWidget {
  final Widget child;
  final int depth;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  const DragDismissKeyboardContainer({
    Key key,
    this.depth = 0,
    @required this.child,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
  })  : assert(depth != null),
        assert(child != null),
        super(key: key);

  @override
  _DragDismissKeyboardContainerState createState() => _DragDismissKeyboardContainerState();
}

class _DragDismissKeyboardContainerState extends State<DragDismissKeyboardContainer> {
  @override
  Widget build(BuildContext context) {
    if (widget.keyboardDismissBehavior != ScrollViewKeyboardDismissBehavior.onDrag) {
      return widget.child;
    }
    return NotificationListener<ScrollUpdateNotification>(
      child: widget.child,
      onNotification: (ScrollUpdateNotification notification) {
        if (widget.depth != notification.depth) {
          return false;
        }
        final FocusScopeNode focusScope = FocusScope.of(context);
        if (notification.dragDetails != null && focusScope.hasFocus) {
          focusScope.unfocus();
        }
        return false;
      },
    );
  }
}
