/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/presenter/request_presenter.dart';
import 'package:flutter/cupertino.dart';

abstract class IterablePresenter<T extends StatefulWidget, E> extends RequestPresenter<T, Iterable<E>> {
  final _objects = List<E>();

  Iterable<E> get objects => List.unmodifiable(_objects);

  @protected
  @override
  Iterable<E> get element => List.unmodifiable(_objects);

  int get itemCount => objects.length;

  @override
  bool get isEmpty => objects.isEmpty;

  @override
  bool get isNotEmpty => objects.isNotEmpty;

  E operator [](int index) => objects.elementAt(index);

  E get first => objects.first;

  E get last => objects.last;

  E get single => objects.single;

  @override
  void dispose() {
    super.dispose();
  }

  @protected
  @override
  Future<void> onDefaultRefresh() {
    return onRefresh();
  }

  Future<void> refresh() {
    return onRefresh();
  }

  @override
  Future<void> onQuery(String queryText) async {
    if (!isQueryChanged(queryText)) {
      return;
    }
    return super.onQuery(queryText);
  }

  @protected
  @override
  void onCallback(Iterable<E> objects) {
    _objects.clear();
    if (objects != null && objects.isNotEmpty) {
      _objects.addAll(objects);
    }
  }

  void setObjects(Iterable<E> objects) {
    onCallback(objects);
    notifyDataSetChanged();
  }
}
