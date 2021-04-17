/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/11.
///
/// 滚动改变颜色
abstract class AnimatedColorWidget extends StatefulWidget {
  const AnimatedColorWidget({
    Key key,
    @required this.colorTween,
  })  : assert(colorTween != null),
        super(key: key);

  final ColorTween colorTween;

  Widget evaluateBuild(BuildContext context, Color color);

  @override
  _AnimatedColorWidgetState createState() => _AnimatedColorWidgetState();
}

class _AnimatedColorWidgetState extends State<AnimatedColorWidget> {
  double _value = 1.0;
  ScrollController _scrollController;

  void _onScrollListener() {
    if (_scrollController == null || !_scrollController.hasClients) {
      return;
    }
    final position = _scrollController.position;
    final maxScrollExtent = position.maxScrollExtent;
    _value = 1.0 - position.pixels / maxScrollExtent;
    if (!mounted) {
      return;
    }
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
    return widget.evaluateBuild(context, widget.colorTween.transform(_value.clamp(0.0, 1.0).toDouble()));
  }
}

typedef AnimatedColorBuilder = Widget Function(BuildContext context, Color color);

class AnimatedColorWidgetBuilder extends AnimatedColorWidget {
  const AnimatedColorWidgetBuilder({
    Key key,
    @required this.builder,
    ColorTween colorTween,
  })  : assert(builder != null),
        super(key: key, colorTween: colorTween);

  final AnimatedColorBuilder builder;

  @override
  Widget evaluateBuild(BuildContext context, Color color) {
    return builder(context, color);
  }
}
