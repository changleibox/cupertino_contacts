/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-选择铃声
class EditContactChooseRingToneButton extends StatelessWidget {
  const EditContactChooseRingToneButton({
    Key key,
    @required this.info,
  })  : assert(info != null),
        super(key: key);

  final DefaultSelectionContactInfo info;

  @override
  Widget build(BuildContext context) {
    final themeData = CupertinoTheme.of(context);
    final textStyle = themeData.textTheme.textStyle;
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      child: CupertinoButton(
        minSize: 44,
        padding: const EdgeInsets.only(
          left: 16,
          right: 10,
        ),
        borderRadius: BorderRadius.zero,
        onPressed: () {},
        child: WidgetGroup.spacing(
          spacing: 16,
          children: [
            Text(
              info.name,
              style: textStyle.copyWith(
                fontSize: 15,
              ),
            ),
            const Expanded(
              child: Text(
                '默认',
              ),
            ),
            Icon(
              CupertinoIcons.forward,
              size: 20,
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiaryLabel,
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
