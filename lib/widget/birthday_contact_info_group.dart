/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/selection_info_group_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-生日信息组
class BirthdayContactInfoGroup extends StatelessWidget {
  static final _dateFormat = DateFormat('MM月dd日');

  final ContactInfoGroup infoGroup;

  const BirthdayContactInfoGroup({
    Key key,
    @required this.infoGroup,
  })  : assert(infoGroup != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContactInfoGroupWidget(
      infoGroup: infoGroup,
      addInterceptor: (context) {
        return infoGroup.value.length < 2;
      },
      changedLabelInterceptor: (context, item) {
        return infoGroup.value.length < 2 || item.label.propertyName != 'birthday';
      },
      itemFactory: (index, label) {
        return DateTimeItem(label: label);
      },
      itemBuilder: (context, item) {
        return SelectionInfoGroupItem(
          item: item,
          valueGetter: () => _dateFormat.format(item.value),
          onPressed: () {},
        );
      },
    );
  }
}
