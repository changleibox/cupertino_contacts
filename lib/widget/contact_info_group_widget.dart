/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/contact_info_group_item_widget.dart';
import 'package:cupertinocontacts/widget/edit_contact_info_button.dart';
import 'package:cupertinocontacts/widget/primary_slidable_controller.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
const Duration _kDuration = Duration(milliseconds: 300);

typedef GroupItemBuilder = Widget Function(BuildContext context, GroupItem item);

typedef ItemFactory = GroupItem Function(int index, Selection label);

typedef AddInterceptor = bool Function(BuildContext context);

typedef ChangeLabelInterceptor = bool Function(BuildContext context, GroupItem item);

class ContactInfoGroupWidget extends StatefulWidget {
  final ContactInfoGroup infoGroup;
  final GroupItemBuilder itemBuilder;
  final ItemFactory itemFactory;
  final AddInterceptor addInterceptor;
  final ChangeLabelInterceptor changeLabelInterceptor;

  const ContactInfoGroupWidget({
    Key key,
    @required this.infoGroup,
    @required this.itemBuilder,
    @required this.itemFactory,
    this.addInterceptor,
    this.changeLabelInterceptor,
  })  : assert(infoGroup != null),
        assert(itemBuilder != null),
        assert(itemFactory != null),
        super(key: key);

  @override
  _ContactInfoGroupWidgetState createState() => _ContactInfoGroupWidgetState();
}

class _ContactInfoGroupWidgetState extends State<ContactInfoGroupWidget> with SingleTickerProviderStateMixin {
  final _animatedListKey = GlobalKey<AnimatedListState>();
  final _globalKeys = List<GlobalKey<SlidableState>>();
  final _labelWidts = List<double>();

  SlidableController _slidableController;
  double _maxLabelWidth;
  AnimationController _buttonController;
  Animation<double> _animation;

  @override
  void initState() {
    widget.infoGroup.value.forEach((element) {
      _globalKeys.add(GlobalKey());
    });
    _buttonController = AnimationController(
      duration: _kDuration,
      vsync: this,
      value: 1.0,
    );
    _buttonController.addListener(() {
      if (_buttonController.isCompleted && mounted) {
        setState(() {});
      }
    });
    _animation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.linear,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _slidableController = PrimarySlidableController.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _slidableController?.activeState = null;
    _buttonController.dispose();
    super.dispose();
  }

  Widget _wrapSlidable(int index, GroupItem item, Widget child) {
    var textStyle = CupertinoTheme.of(context).textTheme.textStyle;
    return Slidable.builder(
      controller: _slidableController,
      key: index < 0 ? null : _globalKeys[index],
      closeOnScroll: false,
      actionPane: SlidableScrollActionPane(),
      secondaryActionDelegate: SlideActionListDelegate(
        actions: [
          SlideAction(
            child: Text(
              '删除',
              style: textStyle.copyWith(
                color: CupertinoColors.white,
              ),
            ),
            closeOnTap: true,
            color: CupertinoColors.destructiveRed,
            onTap: () {
              widget.infoGroup.removeAt(index);
              _globalKeys.removeAt(index);
              _labelWidts.removeAt(index);
              _notifyButtonState();
              _animatedListKey.currentState.removeItem(index, (context, animation) {
                return _buildItemAsItem(item, animation);
              });
            },
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildItemAsItem(GroupItem item, Animation<double> animation, {VoidCallback onDeletePressed}) {
    var items = widget.infoGroup.value;
    var index = items.indexOf(item);
    var borderStyle = BorderStyle.solid;
    if (index == items.length - 1 && _animation.value == 0.0) {
      borderStyle = BorderStyle.none;
    }
    Widget child = Container(
      foregroundDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoDynamicColor.resolve(
              separatorColor,
              context,
            ),
            width: 0.0,
            style: borderStyle,
          ),
        ),
      ),
      margin: EdgeInsets.only(
        left: 16,
      ),
      padding: EdgeInsets.only(
        right: 10,
      ),
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: 1.0,
        child: ContactInfoGroupItemWidget(
          infoGroup: widget.infoGroup,
          item: item,
          builder: widget.itemBuilder,
          onDeletePressed: onDeletePressed,
          canChangeLabel: widget.changeLabelInterceptor == null || widget.changeLabelInterceptor(context, item),
          labelWidth: index == -1 ? null : _maxLabelWidth,
          onLabelWidthChanged: (value) {
            var isAdd = index != -1;
            if (isAdd) {
              if (_labelWidts.length < _globalKeys.length) {
                _labelWidts.add(value);
              }
            }
            if (_maxLabelWidth != null && (value < _maxLabelWidth || (isAdd && value == _maxLabelWidth))) {
              return;
            }
            var maxWidth = 0.0;
            _labelWidts.forEach((element) {
              maxWidth = max(maxWidth, element);
            });

            _maxLabelWidth = maxWidth == 0 ? null : maxWidth;
            setState(() {});
          },
        ),
      ),
    );
    return _wrapSlidable(index, item, child);
  }

  Widget _buildItem(int index, Animation<double> animation) {
    var items = widget.infoGroup.value;
    var item = items[index];
    return _buildItemAsItem(
      item,
      animation,
      onDeletePressed: () {
        _onRemovePressed(index);
      },
    );
  }

  _onAddPressed() {
    var length = widget.infoGroup.value.length;
    var selections = widget.infoGroup.selections;
    widget.infoGroup.add(widget.itemFactory(length, selections[length % selections.length]));
    _globalKeys.add(GlobalKey());
    _animatedListKey.currentState.insertItem(length);
    _notifyButtonState();
  }

  _onRemovePressed(int index) {
    var currentState = _globalKeys[index].currentState;
    if (currentState == null) {
      return;
    }
    currentState.open(actionType: SlideActionType.secondary);
  }

  _notifyButtonState() {
    var showButton = widget.addInterceptor == null || widget.addInterceptor(context);
    var animateToValue = showButton ? 1.0 : 0.0;
    if (animateToValue != _buttonController.value) {
      _buttonController.animateTo(animateToValue);
    }
    if (widget.addInterceptor != null || widget.changeLabelInterceptor != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      child: WidgetGroup(
        alignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        direction: Axis.vertical,
        children: <Widget>[
          AnimatedList(
            key: _animatedListKey,
            initialItemCount: widget.infoGroup.value.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index, animation) {
              return _buildItem(index, animation);
            },
          ),
          SizeTransition(
            sizeFactor: _animation,
            axisAlignment: 1.0,
            child: EditContactInfoButton(
              text: '添加${widget.infoGroup.name}',
              onPressed: _onAddPressed,
            ),
          ),
        ],
      ),
    );
  }
}
