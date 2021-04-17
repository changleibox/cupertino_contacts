/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Created by box on 2020/4/1.
///
/// 错误提示
class ErrorTips extends StatelessWidget {
  const ErrorTips({
    Key key,
    this.exception = '暂无数据',
    this.style,
  })  : assert(exception != null),
        super(key: key);

  final dynamic exception;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final textTheme = CupertinoTheme.of(context).textTheme;
    return Center(
      child: Text(
        exception.toString(),
        style: style ??
            textTheme.textStyle.copyWith(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.secondaryLabel,
                context,
              ),
            ),
      ),
    );
  }
}
