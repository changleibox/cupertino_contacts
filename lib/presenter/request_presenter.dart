/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:flutter/cupertino.dart';

mixin RequestPresenterMixin<T extends StatefulWidget, E> on Presenter<T> {
  bool _isLoading = false;
  String _queryText;

  bool get isLoading => _isLoading;

  String get queryText => _queryText;

  @protected
  bool get defaultRefresh => true;

  bool get showProgress => isLoading && isEmpty;

  @protected
  E get element;

  bool get isEmpty;

  bool get isNotEmpty;

  bool isQueryChanged(String queryText) {
    queryText = queryText == null || queryText.isEmpty ? null : queryText;
    return queryText != this.queryText;
  }

  @mustCallSuper
  Future<void> query() async {
    return onQuery(queryText);
  }

  @mustCallSuper
  Future<void> onQuery(String queryText) async {
    if (!isQueryChanged(queryText)) {
      return;
    }
    _queryText = queryText == null || queryText.isEmpty ? null : queryText;
    return _load(false);
  }

  @mustCallSuper
  Future<void> onRefresh() async {
    return _load(showProgress);
  }

  @protected
  Future<void> onDefaultRefresh() async {
    return onRefresh();
  }

  @mustCallSuper
  @override
  void initState() {
    if (defaultRefresh) {
      onDefaultRefresh();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @protected
  Future<E> request(bool showProgress) {
    return onLoad(showProgress);
  }

  @protected
  Future<E> onLoad(bool showProgress);

  @protected
  void onLoaded(E object) {}

  @protected
  void onCallback(E object);

  Future<void> _load(bool showProgress) async {
    _isLoading = true;
    notifyDataSetChanged();
    return await request(showProgress)?.then((object) {
      _callback(object);
    })?.catchError((dynamic error) {
      _callback(null);
    })?.whenComplete(() {
      _isLoading = false;
      notifyDataSetChanged();
    });
  }

  void _callback(E object) {
    onCallback(object);
    onLoaded(element);
  }
}

abstract class RequestPresenter<T extends StatefulWidget, E> extends Presenter<T> with RequestPresenterMixin<T, E> {}
