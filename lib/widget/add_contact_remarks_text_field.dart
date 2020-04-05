/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-备注
class AddContactRemarksTextField extends StatelessWidget {
  final MultiEditableContactInfo info;
  final int minLines;

  const AddContactRemarksTextField({
    Key key,
    @required this.info,
    this.minLines = 3,
  })  : assert(info != null),
        assert(minLines != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemBackground,
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
            info.name,
            style: CupertinoTheme.of(context).textTheme.textStyle,
          ),
          CupertinoTextField(
            controller: info.controller,
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
