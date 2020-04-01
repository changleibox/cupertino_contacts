/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/presenter/iterable_presenter.dart';
import 'package:flutter/cupertino.dart';

abstract class ListPresenter<T extends StatefulWidget, E> extends IterablePresenter<T, E> {
  @override
  Future<List<E>> onLoad(bool showProgress);
}
