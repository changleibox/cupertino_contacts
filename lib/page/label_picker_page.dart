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
const double _kLargeSpacing = 40;
const int _kMaxLabelCount = 20;

enum LabelPageStatus {
  none,
  editCustom,
  query,
}

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

class _LabelPickerPageState extends PresenterState<LabelPickerPage, LabelPickerPresenter> with SingleTickerProviderStateMixin {
  _LabelPickerPageState() : super(LabelPickerPresenter());

  final _slidableController = SlidableController();
  final _queryFocusNode = FocusNode();
  final _queryController = TextEditingController();

  ColorTween _colorTween;
  ScrollController _scrollController;
  LabelPageStatus _status;
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    _status = LabelPageStatus.none;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController?.jumpTo(_kSearchBarHeight);
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );

    _queryFocusNode.addListener(() {
      if (_queryFocusNode.hasFocus) {
        _status = LabelPageStatus.query;
        _animationController.animateTo(0.0);
      }
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
  void dispose() {
    _queryController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  _onDismissSlidable() {
    _slidableController.activeState?.close();
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    _scrollController = PrimaryScrollController.of(context);
    Widget trailing;
    if (presenter.customSelections.isNotEmpty) {
      trailing = NavigationBarAction(
        child: Text(_isEditStatus ? '完成' : '编辑'),
        onPressed: () {
          if (_isEditStatus) {
            _status = LabelPageStatus.none;
          } else {
            _status = LabelPageStatus.editCustom;
          }
          _scrollController?.jumpTo(0);
          _queryFocusNode.unfocus();
          notifyDataSetChanged();
        },
      );
    }
    return [
      AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return AnimatedLabelPickerNavigationBar(
            queryController: _queryController,
            colorTween: _colorTween,
            onQuery: presenter.onQuery,
            focusNode: _queryFocusNode,
            trailing: trailing,
            searchBarHeight: _kSearchBarHeight,
            navigationBarHeight: _kNavigationBarHeight,
            status: _status,
            maxExtentOffset: _animation.value,
            onCancelPressed: () {
              _status = LabelPageStatus.none;
              _queryFocusNode.unfocus();
              _queryController.clear();
              presenter.onQuery(null);
              notifyDataSetChanged();
              _animationController.animateTo(1.0);
            },
          );
        },
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

  bool get _isEditStatus => _status == LabelPageStatus.editCustom;

  @override
  Widget builds(BuildContext context) {
    final children = List<Widget>();
    if (!_isEditStatus && presenter.isNotEmpty) {
      children.add(SelectionGroupWidget(
        selections: presenter.objects.take(min(_kMaxLabelCount, presenter.itemCount)),
        selectedSelection: widget.selectedSelection,
        footers: _buildSystemLabelHeaders(),
        onItemPressed: (value) {
          Navigator.pop(context, value);
        },
      ));
    }
    var customSelections = presenter.customSelections;
    if (widget.canCustomLabel && (!presenter.hasQueryText || customSelections.isNotEmpty)) {
      children.add(CustomLabelGroupWidet(
        queryFocusNode: _queryFocusNode,
        selectionType: widget.selectionType,
        selections: customSelections,
        selectedSelection: widget.selectedSelection,
        status: _status,
      ));
    }
    var padding = MediaQuery.of(context).padding;
    return CupertinoPageScaffold(
      child: SupportNestedScrollView(
        pinnedHeaderSliverHeightBuilder: (context) {
          return _kNavigationBarHeight + padding.top;
        },
        headerSliverBuilder: _buildHeaderSliver,
        physics: SnappingScrollPhysics(
          midScrollOffset: _isEditStatus ? 0 : _kSearchBarHeight,
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
                    padding: padding.copyWith(
                      top: _isEditStatus ? _kLargeSpacing : 0,
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
        ),
      ),
    );
  }
}
