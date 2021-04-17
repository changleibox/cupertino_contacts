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
    final systemSelections = selections.systemSelectionsAt(widget.selectionType);
    final querySelection = _query(systemSelections);
    final length = querySelection.length;
    final groupCount = length ~/ _kEveryGroupCount + 1;
    return List.generate(groupCount, (index) {
      final start = index * _kEveryGroupCount;
      final end = min((index + 1) * _kEveryGroupCount, length);
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

  void onItemPressed(Selection value) {
    Navigator.pop<Selection>(context, value);
  }
}
