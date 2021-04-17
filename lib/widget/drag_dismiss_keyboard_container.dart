/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/12.
///
/// 滚动隐藏键盘
class DragDismissKeyboardContainer extends StatefulWidget {
  const DragDismissKeyboardContainer({
    Key key,
    this.depth = 0,
    @required this.child,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
  })  : assert(depth != null),
        assert(child != null),
        super(key: key);

  final Widget child;
  final int depth;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

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
      onNotification: (ScrollUpdateNotification notification) {
        if (widget.depth != notification.depth) {
          return false;
        }
        final focusScope = FocusScope.of(context);
        if (notification.dragDetails != null && focusScope.hasFocus) {
          focusScope.unfocus();
        }
        return false;
      },
      child: widget.child,
    );
  }
}
