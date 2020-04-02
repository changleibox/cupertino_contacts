/*
 * Copyright © 2019 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

///加载弹框
class LoadPrompt {
  final WillPopCallback onWillPop;
  final Widget child;
  final BuildContext context;
  Widget _pageChild;

  _PopRoute _popRoute;

  LoadPrompt(
    this.context, {
    this.onWillPop,
    this.child,
  }) {
    final radius = 5.0;
    Widget progressChild = child;
    if (progressChild == null) {
      progressChild = progress(radius: 12);
    }
    this._pageChild = WillPopScope(
      onWillPop: () async {
        _popRoute = null;
        return onWillPop == null ? true : onWillPop();
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
              boxShadow: [
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

  ///展示
  void show() {
    Navigator.push(
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
  final Widget child;

  const _Progress({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: child,
    );
  }
}

///Route
class _PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 200);
  final RoutePageBuilder pageBuilder;

  _PopRoute({@required this.pageBuilder}) : assert(pageBuilder != null);

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Semantics(
      child: pageBuilder(context, animation, secondaryAnimation),
      scopesRoute: true,
      explicitChildNodes: true,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    var curvedAnimation = CurvedAnimation(
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
