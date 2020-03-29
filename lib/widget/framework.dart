/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:flutter/cupertino.dart';

abstract class StateAbstractMethod<T extends StatefulWidget> {
  bool get mounted;

  T get widget;

  BuildContext get context;

  void initState();

  void didUpdateWidget(covariant T oldWidget);

  void reassemble();

  void deactivate();

  void dispose();

  void onBuild(BuildContext context);

  void didChangeDependencies();

  void notifyDataSetChanged();

  void postFrameCallback();

  Future<bool> onBackPressed();

  void onRootTap();

  void hideKeyboard();

  void requestFocus([FocusNode node]);

  bool get needCallBackPressed;
}

abstract class PageState<T extends StatefulWidget> extends State<T> implements StateAbstractMethod<T> {
  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    Widget child = onBuild(context);
    if (needCallBackPressed) {
      child = WillPopScope(
        onWillPop: onBackPressed,
        child: child,
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onRootTap,
      child: child,
    );
  }

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postFrameCallback();
    });
  }

  @protected
  @override
  void postFrameCallback() {}

  @mustCallSuper
  @override
  void notifyDataSetChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @mustCallSuper
  @protected
  @override
  Future<bool> onBackPressed() async {
    hideKeyboard();
    return true;
  }

  @mustCallSuper
  @override
  void onRootTap() => hideKeyboard();

  Widget onBuild(BuildContext context) => builds(context);

  @protected
  Widget builds(BuildContext context);

  @override
  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @mustCallSuper
  @override
  void requestFocus([FocusNode node]) {
    FocusScope.of(context).requestFocus(node);
  }

  @override
  bool get needCallBackPressed => false;
}

abstract class PresenterState<T extends StatefulWidget, P extends Presenter<T>> extends PageState<T> {
  final P presenter;

  PresenterState(this.presenter) : assert(presenter != null) {
    presenter?.state = this;
  }

  @mustCallSuper
  @protected
  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @mustCallSuper
  @protected
  @override
  void initState() {
    super.initState();
    presenter?.initState();
  }

  @mustCallSuper
  @protected
  @override
  void postFrameCallback() {
    super.postFrameCallback();
    presenter?.postFrameCallback();
  }

  @mustCallSuper
  @protected
  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    presenter?.didUpdateWidget(oldWidget);
  }

  @mustCallSuper
  @protected
  @override
  void reassemble() {
    super.reassemble();
    presenter?.reassemble();
  }

  @mustCallSuper
  @protected
  @override
  void deactivate() {
    super.deactivate();
    presenter?.deactivate();
  }

  @mustCallSuper
  @protected
  @override
  void dispose() {
    super.dispose();
    presenter?.dispose();
  }

  @mustCallSuper
  @protected
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    presenter?.didChangeDependencies();
  }

  @mustCallSuper
  @protected
  @override
  Future<bool> onBackPressed() async {
    final backPressed = await super.onBackPressed();
    return backPressed && (presenter == null || await presenter.onBackPressed());
  }

  @mustCallSuper
  @protected
  @override
  void onRootTap() {
    super.onRootTap();
    presenter?.onRootTap();
  }

  @mustCallSuper
  @protected
  @override
  Widget onBuild(BuildContext context) {
    final widget = super.onBuild(context);
    presenter?.onBuild(context);
    return widget;
  }

  @override
  bool get needCallBackPressed => presenter != null && presenter.needCallBackPressed;
}
