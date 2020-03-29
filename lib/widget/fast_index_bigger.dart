/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/fast_index.dart';
import 'package:flutter/material.dart';

/// Created by box on 2020/3/27.
///
/// 放大显示在fastIndex旁边的index信息
typedef FastIndexBiggerBuilder = Widget Function(
  BuildContext context,
  Rect rect,
  int index,
  Widget child,
  Animation<double> animation,
);

const Duration _kDefaultDuration = Duration(milliseconds: 300);

class FastIndexBigger extends StatefulWidget {
  final FastIndexController controller;
  final List<String> indexs;
  final Widget child;
  final FastIndexBiggerBuilder builder;

  const FastIndexBigger({
    Key key,
    @required this.controller,
    @required this.indexs,
    @required this.builder,
    this.child,
  })  : assert(controller != null),
        assert(indexs != null),
        assert(builder != null),
        super(key: key);

  @override
  _FastIndexBiggerState createState() => _FastIndexBiggerState();
}

class _FastIndexBiggerState extends State<FastIndexBigger> with SingleTickerProviderStateMixin<FastIndexBigger> {
  AnimationController _controller;
  CurvedAnimation _animation;
  FastIndexDetails _oldDetails;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _kDefaultDuration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndexBigger(BuildContext context, FastIndexDetails details, Widget child) {
    var position = details.position;
    var rect;
    if (position == null) {
      rect = null;
    } else {
      var containerLocalPosition = position.containerLocalPosition;
      rect = position.localRect.shift(containerLocalPosition);
    }
    if (_oldDetails != null && rect == null) {
      _controller.reverse().whenComplete(() {
        _oldDetails = null;
        setState(() {});
      });
      return _buildIndexBigger(context, _oldDetails, child);
    } else {
      if (rect != null && details != _oldDetails) {
        _controller.forward();
        _oldDetails = details;
      }
      return widget.builder(context, rect, details.index, child, _animation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FastIndexDetails>(
      valueListenable: widget.controller,
      builder: _buildIndexBigger,
      child: widget.child,
    );
  }
}
