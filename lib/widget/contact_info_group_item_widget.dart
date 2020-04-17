/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/page/label_picker_page.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-自定义信息
const Duration _kDuration = Duration(milliseconds: 300);
const double _labelSpacing = 2;
const double _labelMaxWidth = 100;
const double _arrowSize = 20;
const double _arrowMinSize = 4;
const EdgeInsets _buttonPadding = EdgeInsets.only(
  left: 8,
  right: 4,
);

class ContactInfoGroupItemWidget extends StatefulWidget {
  final GroupItemBuilder builder;
  final GroupItem item;
  final SelectionType selectionType;
  final VoidCallback onDeletePressed;
  final ValueChanged<double> onLabelWidthChanged;
  final double labelMaxWidth;
  final double labelCacheWidth;
  final ChangeLabelType changeLabelType;
  final bool canCustomLabel;
  final List<Selection> hideSelections;

  const ContactInfoGroupItemWidget({
    Key key,
    @required this.item,
    @required this.selectionType,
    this.onDeletePressed,
    this.builder,
    this.onLabelWidthChanged,
    this.labelMaxWidth,
    this.labelCacheWidth,
    this.changeLabelType = ChangeLabelType.normal,
    this.canCustomLabel = true,
    this.hideSelections,
  })  : assert(item != null),
        assert(selectionType != null),
        assert(builder != null),
        assert(changeLabelType != null),
        assert(canCustomLabel != null),
        super(key: key);

  @override
  _ContactInfoGroupItemWidgetState createState() => _ContactInfoGroupItemWidgetState();
}

class _ContactInfoGroupItemWidgetState extends State<ContactInfoGroupItemWidget> {
  final _labelGlobalKey = GlobalKey();

  double _labelWidth;
  double _labelCacheWidth;

  @override
  void initState() {
    _labelCacheWidth = widget.labelCacheWidth;
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
      final arrowSize = showArrow ? _arrowSize : _arrowMinSize;
      _labelWidth = min(renderBox.size.width, _labelMaxWidth) + arrowSize + _labelSpacing;
      _labelCacheWidth = null;
      setState(() {});
      widget.onLabelWidthChanged(_labelWidth);
    });
  }

  _onLabelPressed() {
    if (widget.changeLabelType != ChangeLabelType.normal) {
      return;
    }
    Navigator.push(
      context,
      RouteProvider.buildRoute(
        LabelPickerPage(
          selectionType: widget.selectionType,
          selectedSelection: widget.item.label,
          canCustomLabel: widget.canCustomLabel,
          hideSelections: widget.hideSelections,
        ),
        title: '标签',
        fullscreenDialog: true,
      ),
    ).then((value) {
      if (value != null) {
        widget.item.label = value;
        _labelWidth = null;
        _measureWidth();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;
    var actionTextStyle = textTheme.actionTextStyle;

    var labelWidth = _labelCacheWidth;
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
        size: _arrowSize,
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.tertiaryLabel,
          context,
        ),
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
        LimitedBox(
          maxWidth: _labelMaxWidth,
          child: Text(
            widget.item.label.labelName,
            key: _labelGlobalKey,
            overflow: TextOverflow.ellipsis,
            style: actionTextStyle.copyWith(
              fontSize: 15,
              color: CupertinoDynamicColor.resolve(
                labelDisbale ? textStyle.color : themeData.primaryColor,
                context,
              ),
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
            Ionicons.ios_remove_circle,
            color: CupertinoColors.destructiveRed,
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
