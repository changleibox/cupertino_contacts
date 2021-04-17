/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/widget/label_picker_widget.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/search_bar_header_delegate.dart';
import 'package:flutter/cupertino.dart';

class LabelPickePersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const LabelPickePersistentHeaderDelegate({
    @required this.paddingTop,
    @required this.searchBarHeight,
    @required this.navigationBarHeight,
    @required this.backgroundColor,
    @required this.status,
    this.queryController,
    this.onQuery,
    this.focusNode,
    this.trailing,
    this.onCancelPressed,
    this.onQueryCancelPressed,
    this.offset,
  })  : assert(paddingTop != null),
        assert(searchBarHeight != null),
        assert(navigationBarHeight != null),
        assert(backgroundColor != null),
        assert(status != null);

  final double paddingTop;
  final double searchBarHeight;
  final double navigationBarHeight;
  final Color backgroundColor;
  final TextEditingController queryController;
  final ValueChanged<String> onQuery;
  final FocusNode focusNode;
  final Widget trailing;
  final LabelPageStatus status;
  final VoidCallback onCancelPressed;
  final VoidCallback onQueryCancelPressed;
  final Animation<double> offset;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final route = ModalRoute.of(context);
    var fullscreenDialog = false;
    if (route is PageRoute) {
      fullscreenDialog = route.fullscreenDialog;
    }
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: CupertinoNavigationBar(
            backgroundColor: backgroundColor,
            // middle: Text('标签'),
            transitionBetweenRoutes: false,
            border: null,
            leading: fullscreenDialog ? NavigationBarAction(onPressed: onCancelPressed, child: const Text('取消')) : null,
            trailing: trailing,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSearchBarNavigationBar(
            height: _isEditStatus
                ? 0
                : _isQueryStatus
                    ? searchBarHeight
                    : max(searchBarHeight - shrinkOffset, 0.0),
            queryController: queryController,
            onChanged: onQuery,
            color: CupertinoColors.secondarySystemFill,
            backgroundColor: backgroundColor,
            opacity: _isQueryStatus ? 1.0 : (1.0 - shrinkOffset / 16).clamp(0.0, 1.0).toDouble(),
            focusNode: focusNode,
            onCancelPressed: onQueryCancelPressed,
            animation: offset,
          ),
        ),
      ],
    );
  }

  bool get _isEditStatus => status == LabelPageStatus.editCustom;

  bool get _isQueryStatus => status == LabelPageStatus.query;

  double get _differenceValue => searchBarHeight - navigationBarHeight;

  @override
  double get maxExtent {
    final value = offset?.value ?? 1.0;
    return paddingTop + navigationBarHeight + (_isEditStatus ? 0.1 : _differenceValue + max(navigationBarHeight * value, 0.1));
  }

  @override
  double get minExtent {
    final value = offset?.value ?? 1.0;
    return paddingTop + searchBarHeight - _differenceValue * value;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
