/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/framework.dart';
import 'package:flutter/cupertino.dart';

abstract class Presenter<T extends StatefulWidget> implements StateAbstractMethod<T> {
  StateAbstractMethod<T> _state;

  set state(StateAbstractMethod<T> state) => _state = state;

  @override
  bool get mounted => _state?.mounted;

  @override
  T get widget => _state?.widget;

  @override
  BuildContext get context => _state?.context;

  /// 此方法不要在initState中调用
  RouteSettings get settings => ModalRoute.of(context).settings;

  /// 此方法不要在initState中调用
  dynamic get arguments => settings.arguments;

  @override
  void initState() {}

  @override
  void didUpdateWidget(covariant T oldWidget) {}

  @override
  void reassemble() {}

  @mustCallSuper
  @override
  void deactivate() {}

  @override
  void dispose() {}

  @override
  void onBuild(BuildContext context) {}

  @mustCallSuper
  @override
  void didChangeDependencies() {}

  @mustCallSuper
  @override
  void notifyDataSetChanged() => _state?.notifyDataSetChanged();

  @override
  void postFrameCallback() {}

  @override
  Future<bool> onBackPressed() async => true;

  @override
  void onRootTap() {}

  @override
  void hideKeyboard() => _state?.hideKeyboard();

  @mustCallSuper
  @override
  void requestFocus([FocusNode node]) => _state?.requestFocus(node);

  @override
  bool get needCallBackPressed => false;
}
