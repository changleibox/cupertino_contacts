/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/util/collections.dart';
import 'package:cupertinocontacts/widget/animated_color_widget.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/label_picker_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/primary_slidable_controller.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

const double _kSearchBarHeight = 56.0;
const double _kNavigationBarHeight = 44.0;
const Duration _kDuration = Duration(milliseconds: 300);

enum LabelPageStatus {
  none,
  editCustom,
  query,
}

typedef LabelPickerBodyBuilder = Widget Function(BuildContext context, LabelPageStatus status, FocusNode queryFoucsNode);

class AnimatedLabelPickerHeaderBody extends StatefulWidget {
  final LabelPickerBodyBuilder builder;
  final ValueChanged<String> onQuery;
  final bool hasEditButton;

  const AnimatedLabelPickerHeaderBody({
    Key key,
    @required this.builder,
    this.onQuery,
    this.hasEditButton = false,
  })  : assert(builder != null),
        assert(hasEditButton != null),
        super(key: key);

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

  _onTrailingPressed() {
    if (_isEditStatus) {
      _status = LabelPageStatus.none;
    } else {
      _status = LabelPageStatus.editCustom;
    }
    _scrollController?.jumpTo(0);
    _queryFocusNode.unfocus();
    setState(() {});
  }

  _onQueryCancelPressed() {
    _status = LabelPageStatus.none;
    setState(() {});
    _queryFocusNode.unfocus();
    _scrollController?.jumpTo(0);
    _animationController.animateTo(1.0);
    _queryController.clear();
    if (widget.onQuery != null) {
      widget.onQuery(null);
    }
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    _scrollController = PrimaryScrollController.of(context);
    Widget trailing;
    if (widget.hasEditButton) {
      trailing = NavigationBarAction(
        child: Text(_isEditStatus ? '完成' : '编辑'),
        onPressed: _onTrailingPressed,
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
            onCancelPressed: _onQueryCancelPressed,
          );
        },
      ),
    ];
  }

  bool get _isEditStatus => _status == LabelPageStatus.editCustom;

  bool get _isQueryStatus => _status == LabelPageStatus.query;

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;
    return SupportNestedScrollView(
      pinnedHeaderSliverHeightBuilder: (context) {
        return (_isQueryStatus ? _kSearchBarHeight : _kNavigationBarHeight) + padding.top;
      },
      headerSliverBuilder: _buildHeaderSliver,
      physics: SnappingScrollPhysics(
        midScrollOffset: _isEditStatus || _isQueryStatus ? 0 : _kSearchBarHeight,
      ),
      body: widget.builder(context, _status, _queryFocusNode),
    );
  }
}

class AnimatedLabelPickerNavigationBar extends AnimatedColorWidget {
  final Widget trailing;
  final TextEditingController queryController;
  final ValueChanged<String> onQuery;
  final FocusNode focusNode;
  final double navigationBarHeight;
  final double searchBarHeight;
  final LabelPageStatus status;
  final VoidCallback onCancelPressed;
  final Animation<double> offset;

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
    this.offset,
  })  : assert(navigationBarHeight != null),
        assert(searchBarHeight != null),
        assert(status != null),
        super(key: key, colorTween: colorTween);

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
        offset: offset,
      ),
    );
  }
}

class SelectionGroupWidget extends StatelessWidget {
  final List<Widget> headers;
  final List<Widget> footers;
  final Iterable<Selection> selections;
  final Selection selectedSelection;
  final ValueChanged<Selection> onItemPressed;

  const SelectionGroupWidget({
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

class DeleteableSelectionGroupWidget extends StatefulWidget {
  final List<Widget> headers;
  final List<Widget> footers;
  final Iterable<Selection> selections;
  final Selection selectedSelection;
  final ValueChanged<Selection> onItemPressed;
  final ValueChanged<Selection> onDeletePressed;
  final bool hasDeleteButton;

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

  @override
  _DeleteableSelectionGroupWidgetState createState() => _DeleteableSelectionGroupWidgetState();
}

class _DeleteableSelectionGroupWidgetState extends State<DeleteableSelectionGroupWidget> {
  final _globalKeyMap = HashMap<Selection, GlobalKey<SlidableState>>();

  SlidableController _slidableController;

  @override
  void initState() {
    widget.selections.forEach((element) {
      _globalKeyMap[element] = GlobalKey();
    });
    super.initState();
  }

  @override
  void didUpdateWidget(DeleteableSelectionGroupWidget oldWidget) {
    if (!Collections.equals(widget.selections, oldWidget.selections)) {
      _globalKeyMap.clear();
      widget.selections.forEach((element) {
        _globalKeyMap[element] = GlobalKey();
      });
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

  @override
  Widget build(BuildContext context) {
    var textStyle = CupertinoTheme.of(context).textTheme.textStyle;

    final children = List<Widget>();
    if (widget.headers != null) {
      children.addAll(widget.headers);
    }
    children.addAll(widget.selections.map((selection) {
      var globalKey = _globalKeyMap[selection];
      Widget deleteButton;
      if (widget.hasDeleteButton) {
        deleteButton = CupertinoButton(
          padding: EdgeInsets.only(
            right: 10,
          ),
          minSize: 0,
          borderRadius: BorderRadius.zero,
          child: Icon(
            CupertinoIcons.minus_circled,
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.destructiveRed,
              context,
            ),
          ),
          onPressed: () {
            globalKey?.currentState?.open(actionType: SlideActionType.secondary);
          },
        );
      }
      return Slidable.builder(
        key: globalKey,
        controller: _slidableController,
        actionPane: SlidableDrawerActionPane(),
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
    }));
    if (widget.footers != null) {
      children.addAll(widget.footers);
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
  final Widget leading;
  final Widget trailing;

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

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    return LabelItemButton(
      text: selection.selectionName,
      onPressed: onPressed,
      leading: leading,
      trailing: selected
          ? Icon(
              CupertinoIcons.check_mark,
              size: 40,
              color: themeData.primaryColor,
            )
          : trailing,
    );
  }
}

class LabelItemButton extends StatelessWidget {
  final String text;
  final Widget leading;
  final Widget trailing;
  final VoidCallback onPressed;

  const LabelItemButton({
    Key key,
    @required this.text,
    this.leading,
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

class CustomLabelTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;

  const CustomLabelTextField({
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
