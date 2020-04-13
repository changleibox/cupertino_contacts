/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/presenter/label_picker_presenter.dart';
import 'package:cupertinocontacts/widget/custom_label_group_widet.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/label_picker_widget.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/primary_slidable_controller.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Created by box on 2020/4/11.
///
/// 选择标签
const double _kSearchBarHeight = 56.0;
const double _kNavigationBarHeight = 44.0;
const int _kMaxLabelCount = 20;

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
  final _queryFocusNode = FocusNode();

  ColorTween _colorTween;
  ScrollController _scrollController;
  bool isEditMode = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController?.jumpTo(_kSearchBarHeight);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _colorTween = ColorTween(
      begin: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      end: CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemGroupedBackground,
        context,
      ),
    );
    super.didChangeDependencies();
  }

  @override
  void onRootTap() {
    _onDismissSlidable();
    super.onRootTap();
  }

  _onDismissSlidable() {
    _slidableController.activeState?.close();
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    _scrollController = PrimaryScrollController.of(context);
    Widget trailing;
    if (presenter.customSelections.isNotEmpty) {
      trailing = NavigationBarAction(
        child: Text(isEditMode ? '完成' : '编辑'),
        onPressed: () {
          isEditMode = !isEditMode;
          _scrollController?.jumpTo(0);
          notifyDataSetChanged();
        },
      );
    }
    return [
      AnimatedLabelPickerNavigationBar(
        colorTween: _colorTween,
        onQuery: presenter.onQuery,
        focusNode: _queryFocusNode,
        trailing: trailing,
        searchBarHeight: isEditMode ? 0 : _kSearchBarHeight,
        navigationBarHeight: _kNavigationBarHeight,
      ),
    ];
  }

  List<Widget> _buildSystemLabelHeaders() {
    if (presenter.itemCount <= _kMaxLabelCount) {
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
        onPressed: () {},
      ),
    ];
  }

  @override
  Widget builds(BuildContext context) {
    final children = List<Widget>();
    if (!isEditMode && presenter.isNotEmpty) {
      children.add(SelectionGroupWidget(
        selections: presenter.objects.take(min(_kMaxLabelCount, presenter.itemCount)),
        selectedSelection: widget.selectedSelection,
        footers: _buildSystemLabelHeaders(),
        onItemPressed: (value) {
          Navigator.pop(context, value);
        },
      ));
    }
    var hasQueryText = presenter.hasQueryText;
    var customSelections = presenter.customSelections;
    if (widget.canCustomLabel && (!presenter.hasQueryText || customSelections.isNotEmpty)) {
      children.add(CustomLabelGroupWidet(
        queryFocusNode: _queryFocusNode,
        selectionType: widget.selectionType,
        selections: customSelections,
        selectedSelection: widget.selectedSelection,
        hasQueryText: hasQueryText,
        isEditMode: isEditMode,
      ));
    }
    return CupertinoPageScaffold(
      child: SupportNestedScrollView(
        pinnedHeaderSliverHeightBuilder: (context) {
          return _kNavigationBarHeight + MediaQuery.of(context).padding.top;
        },
        headerSliverBuilder: _buildHeaderSliver,
        physics: SnappingScrollPhysics(
          midScrollOffset: _kSearchBarHeight,
        ),
        body: PrimarySlidableController(
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
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      return children[index];
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 40,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
