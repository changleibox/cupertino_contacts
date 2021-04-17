/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 水平分割线
class CupertinoDivider extends StatelessWidget {
  const CupertinoDivider({
    Key key,
    this.height,
    this.color,
  }) : super(key: key);

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.resolve(
        color ?? separatorColor,
        context,
      ),
      height: height ?? 1.0 / MediaQuery.of(context).devicePixelRatio, // One physical pixel.
    );
  }
}
