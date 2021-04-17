/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/datetime_contact_info_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-生日信息组
class BirthdayContactInfoGroup extends StatelessWidget {
  const BirthdayContactInfoGroup({
    Key key,
    @required this.infoGroup,
  })  : assert(infoGroup != null),
        super(key: key);

  final ContactInfoGroup<DateTimeItem> infoGroup;

  @override
  Widget build(BuildContext context) {
    return DateTimeContactInfoGroup(
      infoGroup: infoGroup,
      canCustomLabel: false,
      addInterceptor: (context) {
        return infoGroup.value.length < 2;
      },
      changeLabelInterceptor: (context, item) {
        ChangeLabelType changeLabelType;
        if (infoGroup.value.length < 2 || item.label != selections.birthdaySelection) {
          changeLabelType = ChangeLabelType.normal;
        } else {
          changeLabelType = ChangeLabelType.cannotChange;
        }
        return changeLabelType;
      },
      selectionsInterceptor: (context, item) {
        List<Selection> hideSelections;
        if (infoGroup.value.length >= 2) {
          hideSelections = [selections.birthdaySelection];
        }
        return hideSelections;
      },
      itemFactory: (index, label) async {
        final value = infoGroup.value;
        if (value.isNotEmpty && value.first.label != selections.birthdaySelection) {
          return DateTimeItem(label: selections.birthdaySelection);
        }
        return DateTimeItem(label: label);
      },
    );
  }
}
