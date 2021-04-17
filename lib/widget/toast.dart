/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double _kOffset = 15;
const double _kMargin = 10;

void showText(
  String message,
  BuildContext context, {
  ToastDuration duration = ToastDuration.LENGTH_LONG,
  ToastGravity gravity = ToastGravity.CENTER,
  Color backgroundColor,
  Color textColor,
  double backgroundRadius = 5,
  Border border,
}) {
  Toast.show(
    message,
    context,
    duration: duration,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: null,
    backgroundRadius: backgroundRadius,
    border: border,
    single: true,
  );
}

enum ToastGravity {
  BOTTOM,
  CENTER,
  TOP,
}

enum ToastDuration {
  LENGTH_SHORT,
  LENGTH_LONG,
}

class _ToastInfo {
  _ToastInfo(
    this.toastView, {
    this.message,
    this.gravity,
    this.background,
    this.textColor,
    this.fontSize,
    this.backgroundRadius,
    this.border,
    this.duration,
  });

  final String message;
  final ToastGravity gravity;
  final Color background;
  final Color textColor;
  final double fontSize;
  final double backgroundRadius;
  final Border border;
  final ToastDuration duration;
  final ToastView toastView;
}

class Toast {
  const Toast._();

  static final _toastMap = <String, _ToastInfo>{};

  static void show(
    String message,
    BuildContext context, {
    ToastDuration duration = ToastDuration.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor,
    Color textColor,
    double fontSize,
    double backgroundRadius,
    Border border,
    bool single = false,
  }) {
    void showFirst() {
      final keys = _toastMap.keys;
      if (keys.isEmpty) {
        return;
      }
      final toastInfo = _toastMap[keys.first];
      final toastView = toastInfo.toastView;
      if (!single && toastView.isShowing) {
        return;
      }
      toastView.show(
        toastInfo.message,
        toastInfo.duration,
        toastInfo.gravity,
        toastInfo.background,
        toastInfo.textColor,
        toastInfo.fontSize,
        toastInfo.backgroundRadius,
        toastInfo.border,
      );
    }

    _ToastInfo _buildToastInfo({ToastView toastView}) {
      return _ToastInfo(
        toastView ??
            ToastView(
              context,
              onDismiss: () {
                if (single) {
                  _toastMap.clear();
                } else {
                  _toastMap.remove(message);
                }
                showFirst();
              },
            ),
        backgroundRadius: backgroundRadius,
        border: border,
        textColor: textColor,
        fontSize: fontSize,
        gravity: gravity,
        message: message,
        background: backgroundColor,
        duration: duration,
      );
    }

    if (single && _toastMap.length > 1) {
      for (var value in _toastMap.values) {
        value.toastView.dismiss();
      }
      _toastMap.clear();
    } else if (single && _toastMap.isNotEmpty) {
      final toastInfo = _toastMap.values.single;
      _toastMap.clear();
      _toastMap[message] = _buildToastInfo(toastView: toastInfo.toastView);
    }
    if (_toastMap.isEmpty || (!single && !_toastMap.containsKey(message))) {
      _toastMap[message] = _buildToastInfo();
    }
    showFirst();
  }
}

class ToastView {
  ToastView(this.context, {this.onDismiss})
      : assert(context != null),
        _overlayState = Overlay.of(context);

  final BuildContext context;
  final OverlayState _overlayState;
  final VoidCallback onDismiss;

  AnimationController _animationController;
  OverlayEntry _overlayEntry;
  bool _isVisible = false;
  Timer _timer;

  bool get isShowing => _isVisible;

  void show(
    String message,
    ToastDuration duration,
    ToastGravity gravity,
    Color background,
    Color textColor,
    double fontSize,
    double backgroundRadius,
    Border border, {
    List<BoxShadow> boxShadow,
    EdgeInsetsGeometry margin = const EdgeInsets.symmetric(
      horizontal: _kMargin,
    ),
    EdgeInsetsGeometry padding,
  }) {
    if (message == null || message.isEmpty) {
      return;
    }

    Widget buildChild(BuildContext context) {
      return ToastWidget(
        animation: _animationController,
        padding: padding,
        border: border,
        margin: margin,
        background: background,
        backgroundRadius: backgroundRadius,
        boxShadow: boxShadow,
        fontSize: fontSize,
        gravity: gravity,
        message: message,
        textColor: textColor,
      );
    }

    final value = _animationController?.value;
    if (_isVisible) {
      _onComplete(isDismiss: false);
    }

    _animationController = AnimationController(
      vsync: _overlayState,
      duration: const Duration(milliseconds: 300),
    );

    int dismissDuration;
    if (duration == null) {
      dismissDuration = ToastDuration.LENGTH_SHORT.index + 1;
    } else {
      dismissDuration = duration.index + 1;
    }

    _overlayEntry = OverlayEntry(builder: buildChild);
    _isVisible = true;
    _overlayState.insert(_overlayEntry);
    _animationController.forward(from: value);
    _timer = Timer(Duration(seconds: dismissDuration), () {
      dismiss();
    });
  }

  void dismiss() {
    if (!_isVisible) {
      return;
    }
    _animationController?.reverse()?.whenComplete(_onComplete);
  }

  void _onComplete({bool isDismiss = true}) {
    _animationController?.dispose();
    _animationController = null;
    _timer?.cancel();
    _timer = null;
    _isVisible = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (isDismiss && onDismiss != null) {
      onDismiss();
    }
  }
}

class ToastWidget extends StatelessWidget {
  ToastWidget({
    Key key,
    @required Animation<double> animation,
    @required this.message,
    @required this.gravity,
    this.background,
    this.textColor,
    this.fontSize,
    this.backgroundRadius,
    this.border,
    this.boxShadow,
    this.margin = const EdgeInsets.symmetric(
      horizontal: _kMargin,
    ),
    this.padding,
  })  : assert(animation != null),
        assert(message != null && message.isNotEmpty),
        assert(gravity != null),
        _curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.linearToEaseOut,
          reverseCurve: Curves.fastLinearToSlowEaseIn,
        ),
        super(key: key);

  final String message;
  final ToastGravity gravity;
  final Color background;
  final Color textColor;
  final double fontSize;
  final double backgroundRadius;
  final Border border;
  final List<BoxShadow> boxShadow;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Animation<double> _curvedAnimation;

  Color _themeBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final isThemeDark = theme.brightness == Brightness.dark;

    return isThemeDark ? onSurface : Color.alphaBlend(onSurface.withOpacity(0.80), colorScheme.surface);
  }

  @override
  Widget build(BuildContext context) {
    final child = Center(
      child: Container(
        decoration: BoxDecoration(
          color: background ?? _themeBackgroundColor(context),
          borderRadius: BorderRadius.circular(backgroundRadius ?? 8),
          border: border,
          boxShadow: boxShadow,
        ),
        constraints: const BoxConstraints(),
        margin: margin,
        padding: padding ?? const EdgeInsets.all(10),
        child: Text(
          message,
          softWrap: true,
          style: TextStyle(
            fontSize: fontSize ?? 15,
            color: textColor ?? Colors.white,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );

    return Positioned(
      top: gravity == ToastGravity.TOP ? _kOffset : null,
      bottom: gravity == ToastGravity.BOTTOM ? _kOffset : null,
      child: SafeArea(
        child: ScaleTransition(
          scale: _curvedAnimation,
          child: FadeTransition(
            opacity: _curvedAnimation,
            child: child,
          ),
        ),
      ),
    );
  }
}
