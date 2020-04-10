/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-自定义信息
const Duration _kDuration = Duration(milliseconds: 300);
const double _labelSpacing = 2;
const double _iconSize = 24;
const double _iconMinSize = 4;
const EdgeInsets _buttonPadding = EdgeInsets.only(
  left: 8,
  right: 4,
);

class ContactInfoGroupItemWidget extends StatefulWidget {
  final GroupItemBuilder builder;
  final GroupItem item;
  final VoidCallback onDeletePressed;
  final ValueChanged<double> onLabelWidthChanged;
  final double labelWidth;
  final bool canChangeLabel;

  const ContactInfoGroupItemWidget({
    Key key,
    @required this.item,
    this.onDeletePressed,
    this.builder,
    this.onLabelWidthChanged,
    this.labelWidth,
    this.canChangeLabel = true,
  })  : assert(item != null),
        assert(builder != null),
        assert(canChangeLabel != null),
        super(key: key);

  @override
  _ContactInfoGroupItemWidgetState createState() => _ContactInfoGroupItemWidgetState();
}

class _ContactInfoGroupItemWidgetState extends State<ContactInfoGroupItemWidget> {
  final _labelGlobalKey = GlobalKey();

  double _labelWidth;

  @override
  void initState() {
    _measureWidth();
    super.initState();
  }

  @override
  void didUpdateWidget(ContactInfoGroupItemWidget oldWidget) {
    if (widget.canChangeLabel != oldWidget.canChangeLabel || widget.item.label != oldWidget.item.label) {
      _measureWidth();
    }
    super.didUpdateWidget(oldWidget);
  }

  _measureWidth() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      var currentContext = _labelGlobalKey.currentContext;
      var renderBox = currentContext?.findRenderObject() as RenderBox;
      if (widget.onLabelWidthChanged == null || renderBox == null || !renderBox.hasSize) {
        return;
      }
      final iconSize = widget.canChangeLabel ? _iconSize : _iconMinSize;
      _labelWidth = renderBox.size.width + iconSize + _labelSpacing;
      setState(() {});
      widget.onLabelWidthChanged(_labelWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;
    var actionTextStyle = textTheme.actionTextStyle;

    final hasSize = widget.labelWidth != null && _labelWidth != null;

    Widget arrow = AnimatedOpacity(
      duration: _kDuration,
      opacity: widget.canChangeLabel ? 1.0 : 0.0,
      child: Icon(
        CupertinoIcons.forward,
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.secondaryLabel,
          context,
        ),
        size: _iconSize,
      ),
    );
    if (hasSize) {
      arrow = Flexible(
        child: arrow,
      );
    }

    Widget labelWidget = WidgetGroup.spacing(
      alignment: MainAxisAlignment.spaceBetween,
      spacing: _labelSpacing,
      children: [
        Text(
          widget.item.label.labelName,
          key: _labelGlobalKey,
          style: actionTextStyle.copyWith(
            fontSize: 15,
          ),
        ),
        arrow,
      ],
    );

    if (hasSize) {
      labelWidget = AnimatedContainer(
        duration: _kDuration,
        width: max(_labelWidth, widget.labelWidth),
        child: labelWidget,
      );
    }

    return WidgetGroup.spacing(
      children: [
        CupertinoButton(
          child: Icon(
            CupertinoIcons.minus_circled,
            color: CupertinoColors.systemRed,
            size: _iconSize,
          ),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: widget.onDeletePressed,
        ),
        CupertinoButton(
          minSize: 0,
          borderRadius: BorderRadius.zero,
          padding: _buttonPadding,
          child: labelWidget,
          onPressed: () {
            if (!widget.canChangeLabel) {
              return;
            }
            // TODO 改变标签
          },
        ),
        Expanded(
          child: DefaultTextStyle(
            style: textStyle.copyWith(
              color: themeData.primaryColor,
            ),
            child: Builder(
              builder: (context) => widget.builder(context, widget.item),
            ),
          ),
        ),
      ],
    );
  }
}
