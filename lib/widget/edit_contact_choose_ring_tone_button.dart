/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-选择铃声
class EditContactChooseRingToneButton extends StatelessWidget {
  final DefaultSelectionContactInfo info;

  const EditContactChooseRingToneButton({
    Key key,
    @required this.info,
  })  : assert(info != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textStyle = themeData.textTheme.textStyle;
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
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
                  info.name,
                  style: textStyle.copyWith(
                    fontSize: 15,
                  ),
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
