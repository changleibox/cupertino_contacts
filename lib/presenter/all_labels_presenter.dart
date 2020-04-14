/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/page/all_labels_page.dart';
import 'package:cupertinocontacts/presenter/list_presenter.dart';
import 'package:flutter/cupertino.dart';

class AllLabelsPresenter extends ListPresenter<AllLabelsPage, Selection> {
  @override
  Future<List<Selection>> onLoad(bool showProgress) async {
    var systemSelections = selections.systemSelectionsAt(widget.selectionType);
    return _query(systemSelections);
  }

  List<Selection> _query(List<Selection> selections) {
    return selections.where(_matchQueryText).toList();
  }

  bool get hasQueryText => queryText != null && queryText.isNotEmpty;

  bool _matchQueryText(Selection selection) {
    return !hasQueryText || selection.selectionName.contains(queryText);
  }

  onItemPressed(value) {
    Navigator.pop(context, value);
  }
}
