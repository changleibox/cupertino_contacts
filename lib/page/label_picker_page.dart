/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/presenter/label_picker_presenter.dart';
import 'package:cupertinocontacts/widget/custom_label_group_widet.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/label_picker_widget.dart';
import 'package:cupertinocontacts/widget/primary_slidable_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Created by box on 2020/4/11.
///
/// 选择标签
const double _kLargeSpacing = 40;

class LabelPickerPage extends StatefulWidget {
  final SelectionType selectionType;
  final Selection selectedSelection;
  final List<Selection> hideSelections;
  final bool canCustomLabel;

  const LabelPickerPage({
    Key key,
    @required this.selectionType,
    @required this.selectedSelection,
    this.hideSelections,
    this.canCustomLabel = true,
  })  : assert(selectionType != null),
        assert(canCustomLabel != null),
        super(key: key);

  @override
  _LabelPickerPageState createState() => _LabelPickerPageState();
}

class _LabelPickerPageState extends PresenterState<LabelPickerPage, LabelPickerPresenter> {
  _LabelPickerPageState() : super(LabelPickerPresenter());

  final _slidableController = SlidableController();

  _onDismissSlidable() {
    _slidableController.activeState?.close();
  }

  List<Widget> _buildSystemLabelHeaders(LabelPageStatus status) {
    if (!presenter.canViewAllLabels || status != LabelPageStatus.none) {
      return null;
    }
    return [
      LabelItemButton(
        text: '所有标签',
        trailing: Icon(
          CupertinoIcons.forward,
          size: 20,
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.tertiaryLabel,
            context,
          ),
        ),
        onPressed: presenter.onAllLabelsPressed,
      ),
    ];
  }

  Widget _buildBody(BuildContext context, LabelPageStatus status) {
    final children = <Widget>[];
    if (status != LabelPageStatus.editCustom && presenter.isNotEmpty) {
      children.add(SelectionGroupWidget(
        selections: presenter.objects,
        selectedSelection: widget.selectedSelection,
        footers: _buildSystemLabelHeaders(status),
        onItemPressed: presenter.onItemPressed,
      ));
    }
    if (widget.canCustomLabel) {
      children.add(CustomLabelGroupWidet(
        key: ObjectKey(presenter.queryText),
        selectionType: widget.selectionType,
        selections: presenter.customSelections,
        selectedSelection: widget.selectedSelection,
        status: status,
        onItemPressed: presenter.onItemPressed,
      ));
    }
    var padding = MediaQuery.of(context).padding;
    return PrimarySlidableController(
      controller: _slidableController,
      child: Listener(
        onPointerDown: (event) => _onDismissSlidable(),
        child: NotificationListener<ScrollStartNotification>(
          onNotification: (notification) {
            _onDismissSlidable();
            return false;
          },
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: CupertinoScrollbar(
              child: ListView.separated(
                padding: padding.copyWith(
                  top: status == LabelPageStatus.editCustom ? _kLargeSpacing : 0,
                ),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return children[index];
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: _kLargeSpacing,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget builds(BuildContext context) {
    return CupertinoPageScaffold(
      child: NotificationListener<CustomSelectionChangedNotification>(
        onNotification: (notification) {
          notifyDataSetChanged();
          return false;
        },
        child: AnimatedLabelPickerHeaderBody(
          onQuery: presenter.onQuery,
          canEdit: presenter.customSelections.isNotEmpty,
          onCancelPressed: presenter.onCancelPressed,
          builder: _buildBody,
        ),
      ),
    );
  }
}
