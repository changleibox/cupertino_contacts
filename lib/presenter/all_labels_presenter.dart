/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/page/all_labels_page.dart';
import 'package:cupertinocontacts/presenter/list_presenter.dart';
import 'package:flutter/cupertino.dart';

const int _kEveryGroupCount = 58;

class AllLabelsPresenter extends ListPresenter<AllLabelsPage, List<Selection>> {
  @override
  Future<List<List<Selection>>> onLoad(bool showProgress) async {
    var systemSelections = selections.systemSelectionsAt(widget.selectionType);
    var querySelection = _query(systemSelections);
    var length = querySelection.length;
    var groupCount = length ~/ _kEveryGroupCount + 1;
    return List.generate(groupCount, (index) {
      var start = index * _kEveryGroupCount;
      var end = min((index + 1) * _kEveryGroupCount, length);
      return querySelection.getRange(start, end).toList();
    });
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
