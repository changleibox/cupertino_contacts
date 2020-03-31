/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-选择铃声
class AddContactChooseRingToneButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemBackground,
        context,
      ),
      child: WidgetGroup.separated(
        alignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        direction: Axis.vertical,
        itemCount: 1,
        itemBuilder: (context, index) {
          return CupertinoButton(
            minSize: 44,
            padding: EdgeInsets.only(
              left: 16,
              right: 10,
            ),
            borderRadius: BorderRadius.zero,
            child: WidgetGroup.spacing(
              spacing: 16,
              children: [
                Text(
                  '电话铃声',
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
                Expanded(
                  child: Text(
                    '默认',
                  ),
                ),
                Icon(
                  CupertinoIcons.forward,
                  color: CupertinoDynamicColor.resolve(
                    CupertinoColors.secondaryLabel,
                    context,
                  ),
                ),
              ],
            ),
            onPressed: () {},
          );
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: CupertinoDivider(
              color: separatorColor.withOpacity(0.1),
            ),
          );
        },
      ),
    );
  }
}
