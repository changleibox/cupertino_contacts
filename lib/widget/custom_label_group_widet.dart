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
  const CustomSelectionAddNotification(this.selection) : assert(selection != null);

  final Selection selection;
}

class CustomSelectionRemoveNotification extends CustomSelectionChangedNotification {
  const CustomSelectionRemoveNotification(this.selection) : assert(selection != null);

  final Selection selection;
}

class CustomLabelGroupWidet extends StatefulWidget {
  const CustomLabelGroupWidet({
    Key key,
    @required this.selectionType,
    @required this.selections,
    @required this.status,
    this.selectedSelection,
    this.onItemPressed,
  })  : assert(selectionType != null),
        assert(selections != null),
        assert(status != null),
        super(key: key);

  final List<Selection> selections;
  final SelectionType selectionType;
  final Selection selectedSelection;
  final LabelPageStatus status;
  final ValueChanged<Selection> onItemPressed;

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
      final text = _customLabelController.text;
      if (!_customLabelFocusNode.hasFocus && text != null && text.isNotEmpty) {
        _customLabelController.clear();
        final selection = selections.addCustomSelection(widget.selectionType, text);
        if (selection != null && !widget.selections.contains(selection)) {
          widget.selections.insert(0, selection);
          CustomSelectionAddNotification(selection).dispatch(context);
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

  void _onQueryFocusChanged() {
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

  void _onEditingComplete() {
    final text = _customLabelController.text;
    if (text != null && text.isNotEmpty) {
      _customLabelController.clear();
      final selection = selections.addCustomSelection(widget.selectionType, text);
      if (selection != null && widget.onItemPressed != null) {
        widget.onItemPressed(selection);
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
        if (_isEditStatus || widget.onItemPressed == null) {
          return;
        }
        widget.onItemPressed(value);
      },
      onDeletePressed: (value) {
        selections.removeCustomSelection(widget.selectionType, value);
        widget.selections.remove(value);
        CustomSelectionRemoveNotification(value).dispatch(context);
        _globalKey.currentState.removeSelection(value);
      },
    );
  }
}
