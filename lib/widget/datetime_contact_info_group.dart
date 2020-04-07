/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
class DateTimeContactInfoGroup extends StatelessWidget {
  static final _dateFormat = DateFormat('MM月dd日');

  final ContactInfoGroup infoGroup;

  const DateTimeContactInfoGroup({
    Key key,
    @required this.infoGroup,
  })  : assert(infoGroup != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContactInfoGroupWidget(
      infoGroup: infoGroup,
      itemBuilder: (infoGroup, item) {
        return Container(
          height: 44,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(
            horizontal: 6,
          ),
          child: Text(
            _dateFormat.format(item.value),
          ),
        );
      },
    );
  }
}
