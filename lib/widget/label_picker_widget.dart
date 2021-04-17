/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/animated_color_widget.dart';
import 'package:cupertinocontacts/widget/animated_widget_group.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/label_picker_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/primary_slidable_controller.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

const double _kSearchBarHeight = 56.0;
const double _kNavigationBarHeight = 44.0;
const Duration _kDuration = Duration(milliseconds: 300);

enum LabelPageStatus {
  none,
  editCustom,
  query,
}

typedef LabelPickerBodyBuilder = Widget Function(BuildContext context, LabelPageStatus status);

class AnimatedLabelPickerHeaderBody extends StatefulWidget {
  const AnimatedLabelPickerHeaderBody({
    Key key,
    @required this.builder,
    this.onQuery,
    this.canEdit = false,
    this.onCancelPressed,
  })  : assert(builder != null),
        assert(canEdit != null),
        super(key: key);

  final LabelPickerBodyBuilder builder;
  final AsyncValueSetter<String> onQuery;
  final bool canEdit;
  final VoidCallback onCancelPressed;

  @override
  _AnimatedLabelPickerHeaderBodyState createState() => _AnimatedLabelPickerHeaderBodyState();
}

class _AnimatedLabelPickerHeaderBodyState extends State<AnimatedLabelPickerHeaderBody> with SingleTickerProviderStateMixin {
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

  void _onTrailingPressed() {
    if (_isEditStatus) {
      _status = LabelPageStatus.none;
    } else {
      _status = LabelPageStatus.editCustom;
    }
    _scrollController?.jumpTo(0);
    _queryFocusNode.unfocus();
    setState(() {});
  }

  void _onQueryCancelPressed() {
    _queryFocusNode.unfocus();
    _scrollController?.jumpTo(0);
    _animationController.animateTo(1.0);
    _queryController.clear();
    var future = Future<void>.value();
    if (widget.onQuery != null) {
      future = widget.onQuery(_queryController.text);
    }
    future.whenComplete(() {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _status = LabelPageStatus.none;
        setState(() {});
      });
    });
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    _scrollController = PrimaryScrollController.of(context);
    Widget trailing;
    if (widget.canEdit || _isEditStatus) {
      trailing = NavigationBarAction(
        onPressed: _onTrailingPressed,
        child: Text(_isEditStatus ? '完成' : '编辑'),
      );
    }
    return [
      AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return AnimatedLabelPickerNavigationBar(
            queryController: _queryController,
            colorTween: _colorTween,
            onQuery: widget.onQuery,
            focusNode: _queryFocusNode,
            trailing: trailing,
            searchBarHeight: _kSearchBarHeight,
            navigationBarHeight: _kNavigationBarHeight,
            status: _status,
            offset: _animation,
            onCancelPressed: widget.onCancelPressed,
            onQueryCancelPressed: _onQueryCancelPressed,
          );
        },
      ),
    ];
  }

  bool get _isEditStatus => _status == LabelPageStatus.editCustom;

  bool get _isQueryStatus => _status == LabelPageStatus.query;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return SupportNestedScrollView(
      pinnedHeaderSliverHeightBuilder: (context) {
        return (_isQueryStatus ? _kSearchBarHeight : _kNavigationBarHeight) + padding.top;
      },
      headerSliverBuilder: _buildHeaderSliver,
      physics: SnappingScrollPhysics(
        midScrollOffset: _isEditStatus || _isQueryStatus ? 0 : _kSearchBarHeight,
      ),
      body: widget.builder(context, _status),
    );
  }
}

class AnimatedLabelPickerNavigationBar extends AnimatedColorWidget {
  const AnimatedLabelPickerNavigationBar({
    Key key,
    @required ColorTween colorTween,
    this.trailing,
    this.queryController,
    this.onQuery,
    this.focusNode,
    @required this.navigationBarHeight,
    @required this.searchBarHeight,
    @required this.status,
    this.onCancelPressed,
    this.onQueryCancelPressed,
    this.offset,
  })  : assert(navigationBarHeight != null),
        assert(searchBarHeight != null),
        assert(status != null),
        super(key: key, colorTween: colorTween);

  final Widget trailing;
  final TextEditingController queryController;
  final ValueChanged<String> onQuery;
  final FocusNode focusNode;
  final double navigationBarHeight;
  final double searchBarHeight;
  final LabelPageStatus status;
  final VoidCallback onCancelPressed;
  final VoidCallback onQueryCancelPressed;
  final Animation<double> offset;

  @override
  Widget evaluateBuild(BuildContext context, Color color) {
    final paddingTop = MediaQuery.of(context).padding.top;
    var backgroundColor = color;
    if (offset != null && (status == LabelPageStatus.query || offset.value != 1.0)) {
      backgroundColor = colorTween.transform(offset.value);
    } else if (status == LabelPageStatus.editCustom) {
      backgroundColor = colorTween.begin;
    }
    return SliverPersistentHeader(
      pinned: true,
      delegate: LabelPickePersistentHeaderDelegate(
        queryController: queryController,
        paddingTop: paddingTop,
        navigationBarHeight: navigationBarHeight,
        searchBarHeight: searchBarHeight,
        backgroundColor: backgroundColor,
        trailing: trailing,
        onQuery: onQuery,
        focusNode: focusNode,
        status: status,
        onCancelPressed: onCancelPressed,
        onQueryCancelPressed: onQueryCancelPressed,
        offset: offset,
      ),
    );
  }
}

class SelectionGroupWidget extends StatelessWidget {
  const SelectionGroupWidget({
    Key key,
    @required this.selections,
    @required this.selectedSelection,
    this.onItemPressed,
    this.headers,
    this.footers,
  })  : assert(selections != null),
        super(key: key);

  final List<Widget> headers;
  final List<Widget> footers;
  final Iterable<Selection> selections;
  final Selection selectedSelection;
  final ValueChanged<Selection> onItemPressed;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
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

    final borderSide = BorderSide(
      color: CupertinoDynamicColor.resolve(
        separatorColor,
        context,
      ),
      width: 0.0,
    );

    final length = children.length;
    return Container(
      foregroundDecoration: BoxDecoration(
        border: Border.symmetric(
          vertical: length == 0 ? BorderSide.none : borderSide,
        ),
      ),
      child: WidgetGroup.separated(
        direction: Axis.vertical,
        itemCount: length,
        itemBuilder: (context, index) {
          return children[index];
        },
        separatorBuilder: (context, index) {
          return Container(
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.secondarySystemGroupedBackground,
              context,
            ),
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: const CupertinoDivider(),
          );
        },
      ),
    );
  }
}

class DeleteableSelectionGroupWidget extends StatefulWidget {
  const DeleteableSelectionGroupWidget({
    Key key,
    @required this.selections,
    @required this.selectedSelection,
    this.onItemPressed,
    this.headers,
    this.footers,
    this.onDeletePressed,
    this.hasDeleteButton = false,
  })  : assert(selections != null),
        assert(hasDeleteButton != null),
        super(key: key);

  final List<Widget> headers;
  final List<Widget> footers;
  final Iterable<Selection> selections;
  final Selection selectedSelection;
  final ValueChanged<Selection> onItemPressed;
  final ValueChanged<Selection> onDeletePressed;
  final bool hasDeleteButton;

  @override
  DeleteableSelectionGroupWidgetState createState() => DeleteableSelectionGroupWidgetState();
}

class DeleteableSelectionGroupWidgetState extends State<DeleteableSelectionGroupWidget> {
  final _slidableKeyMap = HashMap<Selection, GlobalKey<SlidableState>>();
  final _widgetGroupKey = GlobalKey<AnimatedWidgetGroupState>();
  final _selections = <Selection>[];
  final _headers = <Widget>[];
  final _footers = <Widget>[];

  SlidableController _slidableController;

  @override
  void initState() {
    if (widget.headers != null) {
      _headers.addAll(widget.headers);
    }
    if (widget.footers != null) {
      _footers.addAll(widget.footers);
    }
    _selections.addAll(widget.selections);
    _slidableKeyMap.addEntries(_selections.map((e) => MapEntry(e, GlobalKey())));
    super.initState();
  }

  @override
  void didUpdateWidget(DeleteableSelectionGroupWidget oldWidget) {
    _headers.clear();
    if (widget.headers != null) {
      _headers.addAll(widget.headers);
    }
    _footers.clear();
    if (widget.footers != null) {
      _footers.addAll(widget.footers);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _slidableController = PrimarySlidableController.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _slidableController?.activeState = null;
    super.dispose();
  }

  void insertHeader(int index) {
    assert(index != null && index >= 0);
    setState(() {});
    _widgetGroupKey.currentState.insertItem(index);
  }

  void insertHeaderFooter(int index, int headerLength) {
    assert(index != null && index >= 0);
    setState(() {});
    index += headerLength + _selections.length;
    _widgetGroupKey.currentState.insertItem(index);
  }

  void removeHeaderFooter(int index, bool isHeader) {
    Widget child;
    if (isHeader) {
      assert(index != null && index >= 0 && index < _headers.length);
      child = _headers[index];
      _headers.removeAt(index);
    } else {
      assert(index != null && index >= 0 && index < _footers.length);
      child = _footers[index];
      _footers.removeAt(index);
      index += _headers.length + _selections.length;
    }
    setState(() {});
    _widgetGroupKey.currentState.removeItem(index, (context, animation) {
      return _buildRemoveChild(child, animation, index);
    });
  }

  void insertSelection(Selection selection) {
    _selections.insert(0, selection);
    _slidableKeyMap[selection] = GlobalKey();
    setState(() {});
    _widgetGroupKey.currentState.insertItem(_headers.length);
  }

  void removeSelection(Selection selection) {
    final index = _selections.indexOf(selection) + _headers.length;
    _selections.remove(selection);
    _slidableKeyMap.remove(selection);
    setState(() {});
    _widgetGroupKey.currentState.removeItem(index, (context, animation) {
      Widget deleteButton;
      if (widget.hasDeleteButton) {
        deleteButton = _buildDeleteIconButton(_slidableKeyMap[selection]);
      }
      return _buildRemoveChild(
        _SelectionItemButton(
          selection: selection,
          selected: selection == widget.selectedSelection,
          leading: deleteButton,
          onPressed: () {},
        ),
        animation,
        index,
      );
    });
  }

  Widget _buildRemoveChild(Widget child, Animation<double> animation, int index) {
    child = SizeTransition(
      sizeFactor: animation,
      axisAlignment: 1,
      child: child,
    );
    final childrenCount = _childrenCount;
    if (childrenCount <= 0) {
      child = Container(
        foregroundDecoration: BoxDecoration(
          border: Border.symmetric(
            vertical: _borderSide,
          ),
        ),
        child: child,
      );
    } else {
      child = _wrapBorder(
        hasTop: index == childrenCount,
        hasBottom: index < childrenCount,
        child: child,
      );
    }
    return child;
  }

  Widget _wrapSlidable({@required Widget child, @required Selection selection}) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;
    return Slidable.builder(
      key: _slidableKeyMap[selection],
      controller: _slidableController,
      actionPane: const SlidableDrawerActionPane(),
      secondaryActionDelegate: SlideActionListDelegate(
        actions: [
          SlideAction(
            closeOnTap: true,
            color: CupertinoColors.destructiveRed,
            onTap: () {
              if (widget.onDeletePressed != null) {
                widget.onDeletePressed(selection);
              }
            },
            child: Text(
              '删除',
              style: textStyle.copyWith(
                color: CupertinoColors.white,
              ),
            ),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _wrapBorder({bool hasTop = false, bool hasBottom = false, @required Widget child}) {
    assert(hasTop != null && hasBottom != null && child != null);
    final divider = Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      padding: const EdgeInsets.only(
        left: 16,
      ),
      child: const CupertinoDivider(),
    );
    return WidgetGroup(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      direction: Axis.vertical,
      children: [
        if (hasTop) divider,
        child,
        if (hasBottom) divider,
      ],
    );
  }

  Widget _buildDeleteIconButton(GlobalKey<SlidableState> globalKey) {
    return CupertinoButton(
      padding: const EdgeInsets.only(
        right: 10,
      ),
      minSize: 0,
      borderRadius: BorderRadius.zero,
      onPressed: () {
        globalKey?.currentState?.open(actionType: SlideActionType.secondary);
      },
      child: Icon(
        Ionicons.ios_remove_circle,
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.destructiveRed,
          context,
        ),
      ),
    );
  }

  int get _childrenCount => _selections.length + _headers.length + _footers.length;

  BorderSide get _borderSide => BorderSide(
        color: CupertinoDynamicColor.resolve(
          separatorColor,
          context,
        ),
        width: 0.0,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: BoxDecoration(
        border: Border.symmetric(
          vertical: _childrenCount == 0 ? BorderSide.none : _borderSide,
        ),
      ),
      child: AnimatedWidgetGroup(
        key: _widgetGroupKey,
        initialItemCount: _childrenCount,
        itemBuilder: (context, index, animation) {
          Widget child;
          if (index < _headers.length) {
            child = _headers[index];
          } else if ((index - _headers.length) < _selections.length) {
            final selection = _selections[index - _headers.length];
            Widget deleteButton;
            if (widget.hasDeleteButton) {
              deleteButton = _buildDeleteIconButton(_slidableKeyMap[selection]);
            }
            child = _wrapSlidable(
              selection: selection,
              child: _SelectionItemButton(
                selection: selection,
                selected: selection == widget.selectedSelection,
                leading: deleteButton,
                onPressed: () {
                  if (widget.onItemPressed != null) {
                    widget.onItemPressed(selection);
                  }
                },
              ),
            );
          } else {
            child = _footers[index - _headers.length - _selections.length];
          }
          return _wrapBorder(
            hasBottom: index < _childrenCount - 1,
            child: SizeTransition(
              sizeFactor: animation,
              axisAlignment: 1,
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _SelectionItemButton extends StatelessWidget {
  const _SelectionItemButton({
    Key key,
    @required this.selection,
    this.selected = false,
    this.onPressed,
    this.leading,
    this.trailing,
  })  : assert(selection != null),
        assert(selected != null),
        super(key: key);

  final Selection selection;
  final bool selected;
  final VoidCallback onPressed;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final themeData = CupertinoTheme.of(context);
    return LabelItemButton(
      text: selection.selectionName,
      onPressed: onPressed,
      leading: leading,
      trailing: selected
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.primaryColor,
            )
          : trailing,
    );
  }
}

class LabelItemButton extends StatelessWidget {
  const LabelItemButton({
    Key key,
    @required this.text,
    this.leading,
    this.trailing,
    this.onPressed,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final Widget leading;
  final Widget trailing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final themeData = CupertinoTheme.of(context);
    final textTheme = themeData.textTheme;
    final textStyle = textTheme.textStyle;

    return CupertinoButton(
      padding: const EdgeInsets.only(
        left: 16,
        right: 8,
      ),
      borderRadius: BorderRadius.zero,
      color: CupertinoColors.secondarySystemGroupedBackground,
      onPressed: onPressed,
      child: Align(
        alignment: Alignment.centerLeft,
        child: WidgetGroup.spacing(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            if (leading != null) leading,
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
    );
  }
}

class CustomLabelTextField extends StatelessWidget {
  const CustomLabelTextField({
    Key key,
    this.controller,
    this.focusNode,
    this.onEditingComplete,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.only(
        right: 10,
      ),
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      child: CupertinoTextField(
        controller: controller,
        focusNode: focusNode,
        padding: const EdgeInsets.symmetric(
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
