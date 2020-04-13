/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/page/label_picker_page.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/search_bar_header_delegate.dart';
import 'package:flutter/cupertino.dart';

class LabelPickePersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
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
  })  : assert(paddingTop != null),
        assert(searchBarHeight != null),
        assert(navigationBarHeight != null),
        assert(backgroundColor != null),
        assert(status != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: CupertinoNavigationBar(
            backgroundColor: backgroundColor,
            middle: Text('标签'),
            automaticallyImplyLeading: false,
            border: null,
            leading: NavigationBarAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            trailing: trailing,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSearchBarNavigationBar(
            height: _isEditStatus ? 0 : _isQueryStatus ? searchBarHeight : max(searchBarHeight - shrinkOffset, 0.0),
            queryController: queryController,
            onChanged: onQuery,
            color: CupertinoColors.secondarySystemFill,
            backgroundColor: backgroundColor,
            opacity: _isQueryStatus ? 1.0 : (1.0 - shrinkOffset / 16).clamp(0.0, 1.0),
            focusNode: focusNode,
            hasCancelButton: _isQueryStatus,
            onCancelPressed: onCancelPressed,
            padding: _isQueryStatus
                ? EdgeInsets.only(
                    left: 16,
                    top: 10,
                    right: 0,
                    bottom: 10,
                  )
                : EdgeInsets.only(
                    left: 16,
                    top: 4,
                    right: 16,
                    bottom: 16,
                  ),
          ),
        ),
      ],
    );
  }

  bool get _isEditStatus => status == LabelPageStatus.editCustom;

  bool get _isQueryStatus => status == LabelPageStatus.query;

  @override
  double get maxExtent => minExtent + (_isEditStatus || _isQueryStatus ? 0.1 : searchBarHeight);

  @override
  double get minExtent => (_isQueryStatus ? searchBarHeight : navigationBarHeight) + paddingTop;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
