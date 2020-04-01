/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Created by box on 2020/4/1.
///
/// 错误提示
class ErrorTips extends StatelessWidget {
  final dynamic exception;

  const ErrorTips({
    Key key,
    this.exception,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = CupertinoTheme.of(context).textTheme;
    return Center(
      child: Text(
        exception?.toString() ?? '暂无联系人',
        style: textTheme.textStyle.copyWith(
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.secondaryLabel,
            context,
          ),
        ),
      ),
    );
  }
}
