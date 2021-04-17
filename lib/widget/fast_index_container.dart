/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/fast_index.dart';
import 'package:cupertinocontacts/widget/fast_index_bigger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

/// Created by box on 2020/2/26.
///
/// 快速索引容器
const Size _biggerSize = Size.square(40);
const Duration _kDefaultDuration = Duration(milliseconds: 200);

class FastIndexContainer extends StatefulWidget {
  const FastIndexContainer({
    Key key,
    @required this.indexs,
    @required this.child,
    @required this.itemKeys,
  })  : assert(indexs != null),
        assert(child != null),
        assert(itemKeys != null),
        assert(indexs.length == itemKeys.length),
        super(key: key);

  final Widget child;
  final List<String> indexs;
  final List<GlobalKey> itemKeys;

  @override
  _FastIndexContainerState createState() => _FastIndexContainerState();
}

class _FastIndexContainerState extends State<FastIndexContainer> {
  ScrollController _scrollController;
  FastIndexController _fastIndexController;

  bool _onIndexChangedNotification(IndexChangedNotification notification) {
    final index = notification.index;
    final itemKeys = widget.itemKeys;
    if (!_scrollController.hasClients || index < 0 || itemKeys == null || itemKeys.length <= index) {
      return false;
    }
    final position = _scrollController.position;
    final renderObject = itemKeys[index].currentContext?.findRenderObject() as RenderSliverPersistentHeader;
    if (renderObject != null) {
      final child = renderObject.child;
      final maxExtent = renderObject.maxExtent;
      final dy = child.localToGlobal(Offset.zero, ancestor: context.findRenderObject()).dy;
      var to = dy + position.pixels;
      if (dy < 0) {
        to -= maxExtent - renderObject.minExtent;
      } else if (dy == 0 && child.hasSize) {
        final childExtent = child.size.height;
        to -= maxExtent - childExtent;
      }
      position.moveTo(to);
    }
    return false;
  }

  @override
  void initState() {
    _fastIndexController = FastIndexController();
    super.initState();
  }

  @override
  void dispose() {
    _fastIndexController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _scrollController = PrimaryScrollController.of(context) ?? ScrollController();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          child: PrimaryScrollController(
            controller: _scrollController,
            child: widget.child,
          ),
        ),
        Positioned(
          right: 2,
          child: NotificationListener<IndexChangedNotification>(
            onNotification: _onIndexChangedNotification,
            child: FastIndex(
              controller: _fastIndexController,
              indexs: widget.indexs,
            ),
          ),
        ),
        FastIndexBigger(
          controller: _fastIndexController,
          indexs: widget.indexs,
          builder: (context, rect, index, child, animation) {
            if (rect == null) {
              return const SizedBox.shrink();
            }
            final offset = -_biggerSize.centerRight(-rect.centerLeft);
            return AnimatedPositioned(
              duration: _kDefaultDuration,
              left: offset.dx,
              top: offset.dy,
              width: _biggerSize.width,
              height: _biggerSize.height,
              child: FadeTransition(
                opacity: animation,
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.indexs[index],
                    style: const TextStyle(
                      fontSize: 17,
                      color: CupertinoColors.white,
                      height: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
