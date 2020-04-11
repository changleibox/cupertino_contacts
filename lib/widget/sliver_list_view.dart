/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class SliverListView extends StatelessWidget {
  final Axis scrollDirection;
  final EdgeInsetsGeometry padding;
  final double itemExtent;
  final SliverChildDelegate childrenDelegate;

  SliverListView({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    List<Widget> children = const <Widget>[],
  })  : childrenDelegate = SliverChildListDelegate(
          children,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
        super(key: key);

  SliverListView.builder({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.itemExtent,
    @required IndexedWidgetBuilder itemBuilder,
    int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  })  : assert(itemCount == null || itemCount >= 0),
        childrenDelegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
        super(key: key);

  SliverListView.separated({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.padding,
    @required IndexedWidgetBuilder itemBuilder,
    @required IndexedWidgetBuilder separatorBuilder,
    @required int itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
  })  : assert(itemBuilder != null),
        assert(separatorBuilder != null),
        assert(itemCount != null && itemCount >= 0),
        itemExtent = null,
        childrenDelegate = SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final int itemIndex = index ~/ 2;
            Widget widget;
            if (index.isEven) {
              widget = itemBuilder(context, itemIndex);
            } else {
              widget = separatorBuilder(context, itemIndex);
              assert(() {
                if (widget == null) {
                  throw FlutterError('separatorBuilder cannot return null.');
                }
                return true;
              }());
            }
            return widget;
          },
          childCount: _computeActualChildCount(itemCount),
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: (Widget _, int index) {
            return index.isEven ? index ~/ 2 : null;
          },
        ),
        super(key: key);

  const SliverListView.custom({
    Key key,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.itemExtent,
    @required this.childrenDelegate,
  })  : assert(childrenDelegate != null),
        super(key: key);

  int get estimatedChildCount => childrenDelegate.estimatedChildCount;

  @override
  Widget build(BuildContext context) {
    Widget sliver = SliverList(
      delegate: childrenDelegate,
    );
    if (itemExtent != null) {
      sliver = SliverFixedExtentList(
        itemExtent: itemExtent,
        delegate: childrenDelegate,
      );
    }
    if (estimatedChildCount == 0) {
      return sliver;
    }
    EdgeInsetsGeometry effectivePadding = padding;
    if (padding == null) {
      final MediaQueryData mediaQuery = MediaQuery.of(context, nullOk: true);
      if (mediaQuery != null) {
        // Automatically pad sliver with padding from MediaQuery.
        final EdgeInsets mediaQueryHorizontalPadding = mediaQuery.padding.copyWith(top: 0.0, bottom: 0.0);
        final EdgeInsets mediaQueryVerticalPadding = mediaQuery.padding.copyWith(left: 0.0, right: 0.0);
        // Consume the main axis padding with SliverPadding.
        effectivePadding = scrollDirection == Axis.vertical ? mediaQueryVerticalPadding : mediaQueryHorizontalPadding;
        // Leave behind the cross axis padding.
        sliver = MediaQuery(
          data: mediaQuery.copyWith(
            padding: scrollDirection == Axis.vertical ? mediaQueryHorizontalPadding : mediaQueryVerticalPadding,
          ),
          child: sliver,
        );
      }
    }

    if (effectivePadding != null && effectivePadding != EdgeInsets.zero) {
      sliver = SliverPadding(
        padding: effectivePadding,
        sliver: sliver,
      );
    }
    return sliver;
  }

  // Helper method to compute the actual child count for the separated constructor.
  static int _computeActualChildCount(int itemCount) {
    return math.max(0, itemCount * 2 - 1);
  }
}
