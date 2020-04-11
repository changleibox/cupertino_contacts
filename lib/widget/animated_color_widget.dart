/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/11.
///
/// 滚动改变颜色
abstract class AnimatedColorWidget extends StatefulWidget {
  final ColorTween colorTween;

  const AnimatedColorWidget({
    Key key,
    @required this.colorTween,
  })  : assert(colorTween != null),
        super(key: key);

  Widget evaluateBuild(BuildContext context, Color color);

  @override
  _AnimatedColorWidgetState createState() => _AnimatedColorWidgetState();
}

class _AnimatedColorWidgetState extends State<AnimatedColorWidget> {
  double _value = 1.0;
  ScrollController _scrollController;

  _onScrollListener() {
    if (_scrollController == null || !_scrollController.hasClients) {
      return;
    }
    var position = _scrollController.position;
    _value = 1.0 - position.pixels / position.maxScrollExtent;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    _scrollController?.removeListener(_onScrollListener);
    _scrollController = PrimaryScrollController.of(context);
    _scrollController?.addListener(_onScrollListener);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.evaluateBuild(context, widget.colorTween.transform(_value));
  }
}
