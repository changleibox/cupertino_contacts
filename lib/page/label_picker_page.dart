/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/presenter/label_picker_presenter.dart';
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
const Duration _kDuration = Duration(milliseconds: 300);

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

  final _queryFocusNode = FocusNode();
  final _customLabelFocusNode = FocusNode();
  final _customLabelController = TextEditingController();

  ColorTween _colorTween;
  ScrollController _scrollController;
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController?.jumpTo(_kSearchBarHeight);
    });
    _animationController = AnimationController(
      vsync: this,
      duration: _kDuration,
      value: 1.0,
    );
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        notifyDataSetChanged();
      }
    });
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    _queryFocusNode.addListener(() {
      if (!widget.canCustomLabel) {
        return;
      }
      if (_queryFocusNode.hasFocus) {
        _animationController.animateTo(0.0);
      } else {
        _animationController.animateTo(1.0);
      }
    });
    _customLabelFocusNode.addListener(() {
      notifyDataSetChanged();
      var text = _customLabelController.text;
      if (!_customLabelFocusNode.hasFocus && text != null && text.isNotEmpty) {
        _customLabelController.clear();
        selections.addCustomSelection(widget.selectionType, text);
        presenter.refresh();
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
    _customLabelController.dispose();
    _animationController.dispose();
    super.dispose();
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

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    _scrollController = PrimaryScrollController.of(context);
    return [
      AnimatedCupertinoSliverNavigationBar(
        colorTween: _colorTween,
        onQuery: presenter.onQuery,
        focusNode: _queryFocusNode,
        trailing: presenter.customSelections.isNotEmpty
            ? NavigationBarAction(
                child: Text('编辑'),
                onPressed: () {},
              )
            : null,
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

  List<Widget> _buildCustomLabelHeaders() {
    if (_animationController.status == AnimationStatus.completed && _animationController.value == 0) {
      return null;
    }
    return [
      SizeTransition(
        sizeFactor: _animation,
        axisAlignment: -1,
        child: AnimatedCrossFade(
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
          crossFadeState: _customLabelFocusNode.hasFocus ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: _kDuration,
        ),
      ),
    ];
  }

  @override
  Widget builds(BuildContext context) {
    var itemCount = min(_kMaxLabelCount, presenter.itemCount);
    final showCustomLabel = widget.canCustomLabel && !presenter.hasQueryText || presenter.customSelections.isNotEmpty;
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
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                SelectionGroupWidget(
                  selections: presenter.objects.take(itemCount),
                  selectedSelection: widget.selectedSelection,
                  footers: _buildSystemLabelHeaders(),
                  onItemPressed: (value) {
                    Navigator.pop(context, value);
                  },
                ),
                if (showCustomLabel)
                  SizedBox(
                    height: 40,
                  ),
                if (showCustomLabel)
                  SelectionGroupWidget(
                    selections: presenter.customSelections,
                    selectedSelection: widget.selectedSelection,
                    headers: _buildCustomLabelHeaders(),
                    onItemPressed: (value) {
                      Navigator.pop(context, value);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
