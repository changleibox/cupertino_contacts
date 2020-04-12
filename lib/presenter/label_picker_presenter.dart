/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/page/label_picker_page.dart';
import 'package:cupertinocontacts/presenter/list_presenter.dart';

class LabelPickerPresenter extends ListPresenter<LabelPickerPage, Selection> {
  final _customSelections = List<Selection>();

  List<Selection> get customSelections => _customSelections;

  @override
  Future<List<Selection>> onLoad(bool showProgress) async {
    return _query(widget.selections);
  }

  @override
  void onLoaded(Iterable<Selection> object) {
    _customSelections.clear();
    _customSelections.addAll(_query(_customSelections));
    super.onLoaded(object);
  }

  List<Selection> _query(List<Selection> selections) {
    return selections.where((element) {
      return !_hasQueryText || element.selectionName.contains(queryText);
    }).toList();
  }

  bool get _hasQueryText => queryText != null && queryText.isNotEmpty;
}
