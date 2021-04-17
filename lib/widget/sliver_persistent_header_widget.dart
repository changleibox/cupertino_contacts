/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

typedef SliverPersistentHeaderWidgetBuilder = Widget Function(BuildContext context, double shrinkOffset, bool overlapsContent);

class SliverPersistentHeaderWidget extends SliverPersistentHeaderDelegate {
  const SliverPersistentHeaderWidget({
    @required this.builder,
    @required this.maxExtent,
    @required this.minExtent,
  })  : assert(builder != null),
        assert(minExtent != null),
        assert(maxExtent != null);

  final SliverPersistentHeaderWidgetBuilder builder;
  @override
  final double maxExtent;
  @override
  final double minExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
