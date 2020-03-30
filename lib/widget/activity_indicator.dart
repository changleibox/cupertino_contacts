/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

const double _kDefaultIndicatorRadius = 10.0;

// Extracted from iOS 13.2 Beta.
const Color _kActiveTickColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFF3C3C44),
  darkColor: Color(0xFFEBEBF5),
);

/// An iOS-style activity indicator that spins clockwise.
///
/// See also:
///
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/progress-indicators/#activity-indicators>
class SupportCupertinoActivityIndicator extends StatefulWidget {
  /// Creates an iOS-style activity indicator that spins clockwise.
  const SupportCupertinoActivityIndicator({
    Key key,
    this.animating = true,
    this.radius = _kDefaultIndicatorRadius,
    this.position,
  })  : assert(animating != null),
        assert(radius != null),
        assert(radius > 0),
        assert(position == null || position >= 0.0 && position <= 1.0),
        super(key: key);

  /// Whether the activity indicator is running its animation.
  ///
  /// Defaults to true.
  final bool animating;

  /// Radius of the spinner widget.
  ///
  /// Defaults to 10px. Must be positive and cannot be null.
  final double radius;

  /// [0.0-1.0]
  final double position;

  @override
  _SupportCupertinoActivityIndicatorState createState() => _SupportCupertinoActivityIndicatorState();
}

class _SupportCupertinoActivityIndicatorState extends State<SupportCupertinoActivityIndicator> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating) _controller.repeat();
  }

  @override
  void didUpdateWidget(SupportCupertinoActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating)
        _controller.repeat();
      else
        _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _CupertinoActivityIndicatorPainter(
          position: _controller,
          activeColor: CupertinoDynamicColor.resolve(_kActiveTickColor, context),
          radius: widget.radius,
          progress: widget.animating ? null : widget.position,
        ),
      ),
    );
  }
}

const double _kTwoPI = math.pi * 2.0;
const int _kTickCount = 12;

// Alpha values extracted from the native component (for both dark and light mode).
// The list has a length of 12.
const List<int> _alphaValues = <int>[147, 131, 114, 97, 81, 64, 47, 47, 47, 47, 47, 47];

class _CupertinoActivityIndicatorPainter extends CustomPainter {
  _CupertinoActivityIndicatorPainter({
    @required this.position,
    @required this.activeColor,
    double radius,
    @required this.progress,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius,
          radius / _kDefaultIndicatorRadius,
          -radius / 2.0,
          -radius / _kDefaultIndicatorRadius,
          radius / _kDefaultIndicatorRadius,
          radius / _kDefaultIndicatorRadius,
        ),
        super(repaint: position);

  final Animation<double> position;
  final RRect tickFundamentalRRect;
  final Color activeColor;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (_kTickCount * (progress ?? position.value)).floor();

    for (int i = 0; i < _kTickCount; ++i) {
      final int t = (i + activeTick) % _kTickCount;
      int alpha = _alphaValues[t];
      if (progress != null) {
        alpha = (_kTickCount - i - 3) % _kTickCount <= activeTick ? 255 : 0;
      }
      paint.color = activeColor.withAlpha(alpha);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_kTwoPI / _kTickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupertinoActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position || oldPainter.activeColor != activeColor || oldPainter.progress != progress;
  }
}
