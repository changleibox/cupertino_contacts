/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

typedef SliverPersistentHeaderWidgetBuilder = Widget Function(BuildContext context, double shrinkOffset, bool overlapsContent);

class SliverPersistentHeaderWidget extends SliverPersistentHeaderDelegate {
  final SliverPersistentHeaderWidgetBuilder builder;
  final double maxExtent;
  final double minExtent;

  const SliverPersistentHeaderWidget({
    @required this.builder,
    @required this.maxExtent,
    @required this.minExtent,
  })  : assert(builder != null),
        assert(minExtent != null),
        assert(maxExtent != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
