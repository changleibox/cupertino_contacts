/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/page/label_picker_page.dart';
import 'package:cupertinocontacts/presenter/all_labels_presenter.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/label_picker_widget.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Created by box on 2020/4/14.
///
/// 所有labels
const double _kSearchBarHeight = 56.0;
const double _kNavigationBarHeight = 44.0;
const double _kLargeSpacing = 40;
const Duration _kDuration = Duration(milliseconds: 300);
const int _kEveryGroupCount = 58;

class AllLabelsPage extends StatefulWidget {
  final SelectionType selectionType;

  const AllLabelsPage({
    Key key,
    @required this.selectionType,
  })  : assert(selectionType != null),
        super(key: key);

  @override
  _AllLabelsPageState createState() => _AllLabelsPageState();
}

class _AllLabelsPageState extends PresenterState<AllLabelsPage, AllLabelsPresenter> with SingleTickerProviderStateMixin {
  _AllLabelsPageState() : super(AllLabelsPresenter());

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
      duration: _kDuration,
      value: 1.0,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );

    _queryFocusNode.addListener(() {
      if (_queryFocusNode.hasFocus) {
        _status = LabelPageStatus.query;
        _scrollController?.jumpTo(0);
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

  _onQueryCancelPressed() {
    _status = LabelPageStatus.none;
    notifyDataSetChanged();
    _queryFocusNode.unfocus();
    _scrollController?.jumpTo(0);
    _animationController.animateTo(1.0);
    _queryController.clear();
    presenter.onQuery(null);
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    _scrollController = PrimaryScrollController.of(context);
    return [
      AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return AnimatedLabelPickerNavigationBar(
            queryController: _queryController,
            colorTween: _colorTween,
            onQuery: presenter.onQuery,
            focusNode: _queryFocusNode,
            searchBarHeight: _kSearchBarHeight,
            navigationBarHeight: _kNavigationBarHeight,
            status: _status,
            offset: _animation,
            onCancelPressed: _onQueryCancelPressed,
          );
        },
      ),
    ];
  }

  bool get _isQueryStatus => _status == LabelPageStatus.query;

  @override
  Widget builds(BuildContext context) {
    var selections = presenter.objects.toList();
    var length = selections.length;
    var groupCount = length ~/ _kEveryGroupCount + 1;
    final children = List<Widget>();
    List.generate(groupCount, (index) {
      var start = index * _kEveryGroupCount;
      var end = min((index + 1) * _kEveryGroupCount, length);
      children.add(SelectionGroupWidget(
        selections: selections.getRange(start, end),
        selectedSelection: null,
        onItemPressed: presenter.onItemPressed,
      ));
    });
    var padding = MediaQuery.of(context).padding;
    return CupertinoPageScaffold(
      child: SupportNestedScrollView(
        pinnedHeaderSliverHeightBuilder: (context) {
          return (_isQueryStatus ? _kSearchBarHeight : _kNavigationBarHeight) + padding.top;
        },
        headerSliverBuilder: _buildHeaderSliver,
        physics: SnappingScrollPhysics(
          midScrollOffset: _status != LabelPageStatus.none ? 0 : _kSearchBarHeight,
        ),
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: CupertinoScrollbar(
            child: ListView.separated(
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
    );
  }
}
