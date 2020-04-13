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
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

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

  final _queryFocusNode = FocusNode();

  ColorTween _colorTween;
  ScrollController _scrollController;

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

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    _scrollController = PrimaryScrollController.of(context);
    Widget trailing;
    if (presenter.customSelections.isNotEmpty) {
      trailing = NavigationBarAction(
        child: Text('编辑'),
        onPressed: () {},
      );
    }
    return [
      AnimatedCupertinoSliverNavigationBar(
        colorTween: _colorTween,
        onQuery: presenter.onQuery,
        focusNode: _queryFocusNode,
        trailing: trailing,
        searchBarHeight: _kSearchBarHeight,
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
    if (presenter.isNotEmpty) {
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
        body: MediaQuery.removePadding(
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
    );
  }
}
