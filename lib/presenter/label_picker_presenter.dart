/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/page/all_labels_page.dart';
import 'package:cupertinocontacts/page/label_picker_page.dart';
import 'package:cupertinocontacts/presenter/list_presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:flutter/cupertino.dart';

const int _kMaxLabelCount = 20;

class LabelPickerPresenter extends ListPresenter<LabelPickerPage, Selection> {
  final _customSelections = List<Selection>();

  List<Selection> get customSelections => _customSelections;

  bool get canViewAllLabels => selections.systemSelectionsAt(widget.selectionType).length > _kMaxLabelCount;

  @override
  Future<List<Selection>> onLoad(bool showProgress) async {
    var originalSelections = selections.systemSelectionsAt(widget.selectionType);
    var systemSelections = originalSelections.take(min(_kMaxLabelCount, originalSelections.length)).toList();
    var selectedSelection = widget.selectedSelection;
    if (selectedSelection != null && originalSelections.contains(selectedSelection) && !systemSelections.contains(selectedSelection)) {
      systemSelections.add(widget.selectedSelection);
    }
    return _query(systemSelections);
  }

  @override
  void onLoaded(Iterable<Selection> object) {
    _customSelections.clear();
    if (widget.canCustomLabel) {
      _customSelections.addAll(_query(selections.customSelectionsAt(widget.selectionType)));
    }
    super.onLoaded(object);
  }

  List<Selection> _query(List<Selection> selections) {
    return selections.where((element) {
      return _filterHideSelection(element) && _matchQueryText(element);
    }).toList();
  }

  bool get hasQueryText => queryText != null && queryText.isNotEmpty;

  bool _matchQueryText(Selection selection) {
    return !hasQueryText || selection.selectionName.contains(queryText);
  }

  bool _filterHideSelection(Selection selection) {
    return widget.hideSelections == null || !widget.hideSelections.contains(selection);
  }

  onItemPressed(Selection selection) {
    if (selection != null) {
      Navigator.pop(context, selection);
    }
  }

  onAllLabelsPressed() {
    Navigator.push(
      context,
      RouteProvider.buildRoute(
        AllLabelsPage(
          selectionType: widget.selectionType,
        ),
      ),
    ).then((value) {
      onItemPressed(value);
    });
  }
}
