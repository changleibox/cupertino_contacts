/*
 * Copyright © 2019 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

///加载弹框
class LoadPrompt {
  LoadPrompt(
    this.context, {
    this.onWillPop,
    this.child,
  }) {
    const radius = 5.0;
    var progressChild = child;
    progressChild ??= progress(radius: 12);
    _pageChild = WillPopScope(
      onWillPop: () async {
        _popRoute = null;
        return onWillPop == null ? true : await onWillPop();
      },
      child: Center(
        child: _Progress(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              borderRadius: BorderRadius.circular(radius),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 3,
                ),
              ],
            ),
            child: progressChild,
          ),
        ),
      ),
    );
  }

  final WillPopCallback onWillPop;
  final Widget child;
  final BuildContext context;
  Widget _pageChild;

  _PopRoute _popRoute;

  ///展示
  void show() {
    Navigator.push<void>(
      context,
      _popRoute = _PopRoute(
        pageBuilder: (context, animation, secondaryAnimation) {
          return _pageChild;
        },
      ),
    );
  }

  ///隐藏
  void dismiss() {
    _popRoute?.dismiss();
    _popRoute = null;
  }

  bool get isShowing => _popRoute != null && _popRoute.isActive;

  static Widget progress({double radius = 10}) => _Progress(
        child: CupertinoActivityIndicator(
          radius: radius,
        ),
      );
}

///Widget
class _Progress extends StatelessWidget {
  const _Progress({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: child,
    );
  }
}

///Route
class _PopRoute extends PopupRoute<void> {
  _PopRoute({@required this.pageBuilder}) : assert(pageBuilder != null);

  final Duration _duration = const Duration(milliseconds: 200);
  final RoutePageBuilder pageBuilder;

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: pageBuilder(context, animation, secondaryAnimation),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.fastLinearToSlowEaseIn,
    );
    return ScaleTransition(
      scale: curvedAnimation,
      child: FadeTransition(
        opacity: curvedAnimation,
        child: child,
      ),
    );
  }

  @override
  Duration get transitionDuration => _duration;

  void dismiss() {
    navigator?.pop();
  }
}
