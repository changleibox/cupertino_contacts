/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math' as math;

import 'package:cupertinocontacts/widget/support_activity_indicator.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/30.
///
/// 自定义的下拉刷新
const double _defaultRefreshTriggerPullDistance = 100.0;
const double _defaultRefreshIndicatorExtent = 60.0;

class SupportSliverRefreshIndicator extends StatelessWidget {
  final RefreshCallback onRefresh;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;

  const SupportSliverRefreshIndicator({
    Key key,
    this.onRefresh,
    this.refreshTriggerPullDistance = _defaultRefreshTriggerPullDistance,
    this.refreshIndicatorExtent = _defaultRefreshIndicatorExtent,
  })  : assert(refreshTriggerPullDistance != null),
        assert(refreshTriggerPullDistance > 0.0),
        assert(refreshIndicatorExtent != null),
        assert(refreshIndicatorExtent >= 0.0),
        assert(
            refreshTriggerPullDistance >= refreshIndicatorExtent,
            'The refresh indicator cannot take more space in its final state '
            'than the amount initially created by overscrolling.'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      onRefresh: onRefresh,
      builder: buildSimpleRefreshIndicator,
      refreshIndicatorExtent: refreshIndicatorExtent,
      refreshTriggerPullDistance: _defaultRefreshTriggerPullDistance,
    );
  }

  /// Builds a simple refresh indicator that fades in a bottom aligned down
  /// arrow before the refresh is triggered, a [CupertinoActivityIndicator]
  /// during the refresh and fades the [CupertinoActivityIndicator] away when
  /// the refresh is done.
  static Widget buildSimpleRefreshIndicator(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
  ) {
    const Curve opacityCurve = Interval(0.4, 1.0, curve: Curves.easeInOut);
    final offset = math.min(pulledExtent / refreshTriggerPullDistance, 1.0);
    Widget child = Opacity(
      opacity: opacityCurve.transform(offset),
      child: SupportCupertinoActivityIndicator(
        radius: 12.0,
      ),
    );
    if (refreshState == RefreshIndicatorMode.drag) {
      child = SupportCupertinoActivityIndicator(
        radius: 12.0,
        animating: false,
        position: offset * 0.9,
      );
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: child,
      ),
    );
  }
}
