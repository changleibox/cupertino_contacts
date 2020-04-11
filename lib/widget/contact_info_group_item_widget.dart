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
  final double labelMaxWidth;
  final double labelCacheWidth;
  final ChangeLabelType changeLabelType;

  const ContactInfoGroupItemWidget({
    Key key,
    @required this.item,
    this.onDeletePressed,
    this.builder,
    this.onLabelWidthChanged,
    this.labelMaxWidth,
    this.labelCacheWidth,
    this.changeLabelType = ChangeLabelType.normal,
  })  : assert(item != null),
        assert(builder != null),
        assert(changeLabelType != null),
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
    if (widget.changeLabelType != oldWidget.changeLabelType || widget.item.label != oldWidget.item.label) {
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
      final showArrow = widget.changeLabelType == ChangeLabelType.normal;
      final iconSize = showArrow ? _iconSize : _iconMinSize;
      _labelWidth = renderBox.size.width + iconSize + _labelSpacing;
      setState(() {});
      widget.onLabelWidthChanged(_labelWidth);
    });
  }

  _onLabelPressed() {
    if (widget.changeLabelType != ChangeLabelType.normal) {
      return;
    }
    // TODO 改变标签
  }

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;
    var actionTextStyle = textTheme.actionTextStyle;

    var labelWidth = widget.labelCacheWidth;
    if (widget.labelMaxWidth != null && _labelWidth != null) {
      labelWidth = max(_labelWidth, widget.labelMaxWidth);
    }

    final showArrow = widget.changeLabelType == ChangeLabelType.normal;
    final labelDisbale = widget.changeLabelType == ChangeLabelType.disable;

    Widget arrow = AnimatedOpacity(
      duration: _kDuration,
      opacity: showArrow ? 1.0 : 0.0,
      child: Icon(
        CupertinoIcons.forward,
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.secondaryLabel,
          context,
        ),
        size: _iconSize,
      ),
    );
    if (labelWidth != null) {
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
            color: CupertinoDynamicColor.resolve(
              labelDisbale ? textStyle.color : themeData.primaryColor,
              context,
            ),
          ),
        ),
        arrow,
      ],
    );

    if (labelWidth != null) {
      labelWidget = AnimatedContainer(
        duration: _kDuration,
        width: labelWidth,
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
          onPressed: labelDisbale ? null : _onLabelPressed,
        ),
        Expanded(
          child: DefaultTextStyle(
            style: textStyle.copyWith(
              color: CupertinoDynamicColor.resolve(
                themeData.primaryColor,
                context,
              ),
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
