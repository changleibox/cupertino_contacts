/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/widget/datetime_contact_info_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-生日信息组
class BirthdayContactInfoGroup extends StatelessWidget {
  final ContactInfoGroup infoGroup;

  const BirthdayContactInfoGroup({
    Key key,
    @required this.infoGroup,
  })  : assert(infoGroup != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTimeContactInfoGroup(
      infoGroup: infoGroup,
      addInterceptor: (context) {
        return infoGroup.value.length < 2;
      },
      changeLabelInterceptor: (context, item) {
        return infoGroup.value.length < 2 || item.label != selections.birthdaySelection;
      },
      itemFactory: (index, label) async {
        var value = infoGroup.value;
        if (value.length > 0 && value.first.label != selections.birthdaySelection) {
          return DateTimeItem(label: selections.birthdaySelection);
        }
        return DateTimeItem(label: label);
      },
    );
  }
}
