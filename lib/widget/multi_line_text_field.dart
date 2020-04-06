/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/6.
///
/// 多行输入
class MultiLineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final int minLines;
  final Color backgroundColor;

  const MultiLineTextField({
    Key key,
    @required this.controller,
    @required this.name,
    this.minLines = 3,
    this.backgroundColor,
  })  : assert(controller != null),
        assert(name != null),
        assert(minLines != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.resolve(
        backgroundColor ?? CupertinoColors.tertiarySystemBackground,
        context,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: WidgetGroup.spacing(
        alignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        direction: Axis.vertical,
        children: [
          Text(
            name,
            style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                  fontSize: 15,
                ),
          ),
          CupertinoTextField(
            controller: controller,
            padding: EdgeInsets.zero,
            decoration: null,
            minLines: minLines,
            maxLines: null,
          ),
        ],
      ),
    );
  }
}
