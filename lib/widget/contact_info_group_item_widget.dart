/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-自定义信息
const Duration _kDuration = Duration(milliseconds: 300);

class ContactInfoGroupItemWidget extends StatefulWidget {
  final GroupItemBuilder builder;
  final ContactInfoGroup infoGroup;
  final GroupItem item;
  final VoidCallback onDeletePressed;
  final ValueChanged<double> onLabelWidthChanged;
  final double labelWidth;
  final bool canChangeLabel;

  const ContactInfoGroupItemWidget({
    Key key,
    @required this.infoGroup,
    @required this.item,
    this.onDeletePressed,
    this.builder,
    this.onLabelWidthChanged,
    this.labelWidth,
    this.canChangeLabel = true,
  })  : assert(infoGroup != null),
        assert(item != null),
        assert(builder != null),
        assert(canChangeLabel != null),
        super(key: key);

  @override
  _ContactInfoGroupItemWidgetState createState() => _ContactInfoGroupItemWidgetState();
}

class _ContactInfoGroupItemWidgetState extends State<ContactInfoGroupItemWidget> {
  final _globalKey = GlobalKey();

  bool _isMeasure = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      var currentContext = _globalKey.currentContext;
      var renderBox = currentContext?.findRenderObject() as RenderBox;
      if (widget.onLabelWidthChanged == null || renderBox == null || !renderBox.hasSize) {
        return;
      }
      var width = renderBox.size.width;
      widget.onLabelWidthChanged(width);
      _isMeasure = true;
      if (widget.labelWidth != null && widget.labelWidth > width) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;
    var actionTextStyle = textTheme.actionTextStyle;

    Widget labelButton = CupertinoButton(
      key: _globalKey,
      minSize: 44,
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.only(
        left: 8,
        right: 4,
      ),
      child: WidgetGroup.spacing(
        alignment: MainAxisAlignment.spaceBetween,
        spacing: 2,
        children: [
          Text(
            widget.item.label.labelName,
            style: actionTextStyle.copyWith(
              fontSize: 15,
            ),
          ),
          AnimatedOpacity(
            opacity: widget.canChangeLabel ? 1.0 : 0.0,
            duration: _kDuration,
            child: Icon(
              CupertinoIcons.forward,
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.secondaryLabel,
                context,
              ),
            ),
          ),
        ],
      ),
      onPressed: () {
        if (!widget.canChangeLabel) {
          return;
        }
        // TODO 改变标签
      },
    );
    if (_isMeasure && widget.labelWidth != null) {
      labelButton = AnimatedContainer(
        duration: _kDuration,
        width: widget.labelWidth,
        height: 44,
        child: labelButton,
      );
    }

    return WidgetGroup.spacing(
      children: [
        CupertinoButton(
          child: Icon(
            CupertinoIcons.minus_circled,
            color: CupertinoColors.systemRed,
          ),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: widget.onDeletePressed,
        ),
        labelButton,
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
