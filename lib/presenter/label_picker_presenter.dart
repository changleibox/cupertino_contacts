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
    return _query(selections.systemSelectionsAt(widget.selectionType));
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
}
