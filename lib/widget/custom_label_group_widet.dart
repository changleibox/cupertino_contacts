/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/widget/label_picker_widget.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/13.
///
/// 自定义标签列表
const Duration _kDuration = Duration(milliseconds: 300);

class CustomSelectionChangedNotification extends Notification {
  const CustomSelectionChangedNotification();
}

class CustomSelectionAddNotification extends CustomSelectionChangedNotification {
  final List<Selection> customSelections;

  const CustomSelectionAddNotification(this.customSelections);
}

class CustomSelectionRemoveNotification extends CustomSelectionChangedNotification {
  final List<Selection> customSelections;

  const CustomSelectionRemoveNotification(this.customSelections);
}

class CustomLabelGroupWidet extends StatefulWidget {
  final List<Selection> selections;
  final SelectionType selectionType;
  final Selection selectedSelection;
  final LabelPageStatus status;

  const CustomLabelGroupWidet({
    Key key,
    @required this.selectionType,
    @required this.selections,
    this.selectedSelection,
    @required this.status,
  })  : assert(selectionType != null),
        assert(selections != null),
        assert(status != null),
        super(key: key);

  @override
  _CustomLabelGroupWidetState createState() => _CustomLabelGroupWidetState();
}

class _CustomLabelGroupWidetState extends State<CustomLabelGroupWidet> {
  final _customLabelFocusNode = FocusNode();
  final _customLabelController = TextEditingController();
  final _globalKey = GlobalKey<DeleteableSelectionGroupWidgetState>();

  @override
  void initState() {
    _customLabelFocusNode.addListener(() {
      setState(() {});
      var text = _customLabelController.text;
      if (!_customLabelFocusNode.hasFocus && text != null && text.isNotEmpty) {
        _customLabelController.clear();
        var selection = selections.addCustomSelection(widget.selectionType, text);
        if (selection != null && !widget.selections.contains(selection)) {
          widget.selections.insert(0, selection);
          CustomSelectionAddNotification(widget.selections).dispatch(context);
          _globalKey.currentState.insertSelection(selection);
        }
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(CustomLabelGroupWidet oldWidget) {
    if (widget.status != oldWidget.status) {
      _onQueryFocusChanged();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _customLabelController.dispose();
    super.dispose();
  }

  bool get _isEditStatus => widget.status == LabelPageStatus.editCustom;

  bool get _isHideAddCustomLabelButton {
    return widget.status != LabelPageStatus.none;
  }

  _onQueryFocusChanged() {
    if (_isHideAddCustomLabelButton) {
      _globalKey.currentState.removeHeaderFooter(0, true);
    } else {
      _globalKey.currentState.insertHeader(0);
    }
  }

  Widget _buildCustomLabel() {
    final inEditMode = _customLabelFocusNode.hasFocus;
    return AnimatedCrossFade(
      firstChild: LabelItemButton(
        text: '添加自定标签',
        onPressed: () {
          _customLabelFocusNode.requestFocus();
        },
      ),
      secondChild: CustomLabelTextField(
        controller: _customLabelController,
        focusNode: _customLabelFocusNode,
        onEditingComplete: _onEditingComplete,
      ),
      crossFadeState: inEditMode ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: _kDuration,
    );
  }

  _onEditingComplete() {
    var text = _customLabelController.text;
    if (text != null && text.isNotEmpty) {
      _customLabelController.clear();
      var selection = selections.addCustomSelection(widget.selectionType, text);
      if (selection != null) {
        Navigator.pop(context, selection);
      }
    } else {
      _customLabelFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DeleteableSelectionGroupWidget(
      key: _globalKey,
      selections: widget.selections,
      selectedSelection: _isEditStatus ? null : widget.selectedSelection,
      headers: [
        if (!_isHideAddCustomLabelButton) _buildCustomLabel(),
      ],
      hasDeleteButton: _isEditStatus,
      onItemPressed: (value) {
        if (_isEditStatus) {
          return;
        }
        Navigator.pop(context, value);
      },
      onDeletePressed: (value) {
        selections.removeCustomSelection(widget.selectionType, value);
        widget.selections.remove(value);
        CustomSelectionRemoveNotification(widget.selections).dispatch(context);
        _globalKey.currentState.removeSelection(value);
      },
    );
  }
}
