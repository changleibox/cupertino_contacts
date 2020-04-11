/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/search_bar_header_delegate.dart';
import 'package:flutter/cupertino.dart';

class LabelPickePersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double paddingTop;
  final double searchBarHeight;
  final double navigationBarHeight;
  final Color backgroundColor;
  final ValueChanged<String> onQuery;
  final VoidCallback onEditPressed;

  const LabelPickePersistentHeaderDelegate({
    @required this.paddingTop,
    @required this.searchBarHeight,
    @required this.navigationBarHeight,
    @required this.backgroundColor,
    this.onQuery,
    this.onEditPressed,
  })  : assert(paddingTop != null),
        assert(searchBarHeight != null),
        assert(navigationBarHeight != null),
        assert(backgroundColor != null);

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
            trailing: NavigationBarAction(
              child: Text('编辑'),
              onPressed: onEditPressed,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SearchBarHeader(
            height: searchBarHeight - shrinkOffset,
            onChanged: onQuery,
            color: CupertinoColors.secondarySystemFill,
            backgroundColor: backgroundColor,
            opacity: (1.0 - shrinkOffset / 16).clamp(0.0, 1.0),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => minExtent + searchBarHeight;

  @override
  double get minExtent => navigationBarHeight + paddingTop;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
