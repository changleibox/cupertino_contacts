/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组的容器
class EditContactGroupContainer extends StatelessWidget {
  const EditContactGroupContainer({
    Key key,
    @required this.itemCount,
    @required this.itemBuilder,
  })  : assert(itemCount != null),
        assert(itemBuilder != null),
        super(key: key);

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      child: WidgetGroup.separated(
        alignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        direction: Axis.vertical,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(
              left: 16,
            ),
            child: CupertinoDivider(),
          );
        },
      ),
    );
  }
}
