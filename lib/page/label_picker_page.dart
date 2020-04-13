/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/presenter/label_picker_presenter.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/animated_color_widget.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/label_picker_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
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
      _AnimatedCupertinoSliverNavigationBar(
        colorTween: _colorTween,
        onQuery: presenter.onQuery,
        focusNode: _queryFocusNode,
        trailing: presenter.customSelections.isNotEmpty
            ? NavigationBarAction(
                child: Text('编辑'),
                onPressed: () {},
              )
            : null,
      ),
    ];
  }

  List<Widget> _buildSystemLabelHeaders() {
    if (presenter.itemCount <= _kMaxLabelCount) {
      return null;
    }
    return [
      _ItemButton(
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
          firstChild: _ItemButton(
            text: '添加自定标签',
            onPressed: () {
              _customLabelFocusNode.requestFocus();
            },
          ),
          secondChild: _CustomLabelTextField(
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
                _SelectionGroupWidget(
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
                  _AnimatedSelectionGroupWidget(
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

class _AnimatedCupertinoSliverNavigationBar extends AnimatedColorWidget {
  final Widget trailing;
  final ValueChanged<String> onQuery;
  final FocusNode focusNode;

  const _AnimatedCupertinoSliverNavigationBar({
    Key key,
    @required ColorTween colorTween,
    this.trailing,
    this.onQuery,
    this.focusNode,
  }) : super(key: key, colorTween: colorTween);

  @override
  Widget evaluateBuild(BuildContext context, Color color) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return SliverPersistentHeader(
      pinned: true,
      delegate: LabelPickePersistentHeaderDelegate(
        paddingTop: paddingTop,
        navigationBarHeight: _kNavigationBarHeight,
        searchBarHeight: _kSearchBarHeight,
        backgroundColor: color,
        trailing: trailing,
        onQuery: onQuery,
        focusNode: focusNode,
      ),
    );
  }
}

class _SelectionGroupWidget extends StatelessWidget {
  final List<Widget> headers;
  final List<Widget> footers;
  final Iterable<Selection> selections;
  final Selection selectedSelection;
  final ValueChanged<Selection> onItemPressed;

  const _SelectionGroupWidget({
    Key key,
    @required this.selections,
    @required this.selectedSelection,
    this.onItemPressed,
    this.headers,
    this.footers,
  })  : assert(selections != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = List<Widget>();
    if (headers != null) {
      children.addAll(headers);
    }
    children.addAll(selections.map((selection) {
      return _SelectionItemButton(
        selection: selection,
        selected: selection == selectedSelection,
        onPressed: () {
          if (onItemPressed != null) {
            onItemPressed(selection);
          }
        },
      );
    }));
    if (footers != null) {
      children.addAll(footers);
    }

    var length = children.length;
    return WidgetGroup.separated(
      direction: Axis.vertical,
      itemCount: length,
      itemBuilder: (context, index) {
        var borderSide = BorderSide(
          color: CupertinoDynamicColor.resolve(
            separatorColor,
            context,
          ),
          width: 0.0,
        );
        return Container(
          foregroundDecoration: BoxDecoration(
            border: Border(
              top: index == 0 ? borderSide : BorderSide.none,
              bottom: index == length - 1 ? borderSide : BorderSide.none,
            ),
          ),
          child: children[index],
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.secondarySystemGroupedBackground,
            context,
          ),
          padding: EdgeInsets.only(
            left: 16,
          ),
          child: CupertinoDivider(),
        );
      },
    );
  }
}

class _AnimatedSelectionGroupWidget extends StatelessWidget {
  final List<Widget> headers;
  final List<Widget> footers;
  final Iterable<Selection> selections;
  final Selection selectedSelection;
  final ValueChanged<Selection> onItemPressed;

  const _AnimatedSelectionGroupWidget({
    Key key,
    @required this.selections,
    @required this.selectedSelection,
    this.onItemPressed,
    this.headers,
    this.footers,
  })  : assert(selections != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = List<Widget>();
    if (headers != null) {
      children.addAll(headers);
    }
    children.addAll(selections.map((selection) {
      return _SelectionItemButton(
        selection: selection,
        selected: selection == selectedSelection,
        onPressed: () {
          if (onItemPressed != null) {
            onItemPressed(selection);
          }
        },
      );
    }));
    if (footers != null) {
      children.addAll(footers);
    }

    var length = children.length;
    return WidgetGroup.separated(
      direction: Axis.vertical,
      itemCount: length,
      itemBuilder: (context, index) {
        var borderSide = BorderSide(
          color: CupertinoDynamicColor.resolve(
            separatorColor,
            context,
          ),
          width: 0.0,
        );
        return Container(
          foregroundDecoration: BoxDecoration(
            border: Border(
              top: index == 0 ? borderSide : BorderSide.none,
              bottom: index == length - 1 ? borderSide : BorderSide.none,
            ),
          ),
          child: children[index],
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.secondarySystemGroupedBackground,
            context,
          ),
          padding: EdgeInsets.only(
            left: 16,
          ),
          child: CupertinoDivider(),
        );
      },
    );
  }
}

class _SelectionItemButton extends StatelessWidget {
  final Selection selection;
  final bool selected;
  final VoidCallback onPressed;

  const _SelectionItemButton({
    Key key,
    @required this.selection,
    this.selected = false,
    this.onPressed,
  })  : assert(selection != null),
        assert(selected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    return _ItemButton(
      text: selection.selectionName,
      onPressed: onPressed,
      trailing: selected
          ? Icon(
              CupertinoIcons.check_mark,
              size: 40,
              color: themeData.primaryColor,
            )
          : null,
    );
  }
}

class _ItemButton extends StatelessWidget {
  final String text;
  final Widget trailing;
  final VoidCallback onPressed;

  const _ItemButton({
    Key key,
    @required this.text,
    this.trailing,
    this.onPressed,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;

    return CupertinoButton(
      child: Align(
        alignment: Alignment.centerLeft,
        child: WidgetGroup.spacing(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
      ),
      borderRadius: BorderRadius.zero,
      color: CupertinoColors.secondarySystemGroupedBackground,
      onPressed: onPressed,
    );
  }
}

class _CustomLabelTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;

  const _CustomLabelTextField({
    Key key,
    this.controller,
    this.focusNode,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: EdgeInsets.only(
        right: 10,
      ),
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      child: CupertinoTextField(
        controller: controller,
        focusNode: focusNode,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: null,
        clearButtonMode: OverlayVisibilityMode.editing,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}
