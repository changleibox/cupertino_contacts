/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/presenter/request_presenter.dart';
import 'package:flutter/cupertino.dart';

abstract class ObjectPresenter<T extends StatefulWidget, E> extends RequestPresenter<T, E> {
  E _object;

  E get object => _object;

  @protected
  @override
  E get element => _object;

  @override
  bool get showProgress => false;

  @override
  bool get isEmpty => _object == null;

  @override
  bool get isNotEmpty => _object != null;

  @protected
  @override
  Future<E> onLoad(bool showProgress);

  @protected
  @override
  void onCallback(E object) {
    _object = object;
  }

  void setObject(E object) {
    onCallback(object);
    notifyDataSetChanged();
  }
}
