/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/select_date_dialog.dart';
import 'package:cupertinocontacts/widget/selection_info_group_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

final _dateFormat = DateFormat('MM月dd日');

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
class DateTimeContactInfoGroup extends StatelessWidget {
  const DateTimeContactInfoGroup({
    Key key,
    @required this.infoGroup,
    this.addInterceptor,
    this.changeLabelInterceptor,
    this.selectionsInterceptor,
    this.itemFactory,
    this.canCustomLabel = true,
  })  : assert(infoGroup != null),
        assert(canCustomLabel != null),
        super(key: key);

  final ContactInfoGroup<DateTimeItem> infoGroup;
  final AddInterceptor addInterceptor;
  final ChangeLabelInterceptor changeLabelInterceptor;
  final SelectionsInterceptor selectionsInterceptor;
  final ItemFactory itemFactory;
  final bool canCustomLabel;

  @override
  Widget build(BuildContext context) {
    return ContactInfoGroupWidget(
      infoGroup: infoGroup,
      addInterceptor: addInterceptor,
      changeLabelInterceptor: changeLabelInterceptor,
      selectionsInterceptor: selectionsInterceptor,
      canCustomLabel: canCustomLabel,
      itemFactory: itemFactory ??
          (index, label) async {
            return DateTimeItem(label: label);
          },
      itemBuilder: (context, item) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SelectionInfoGroupItem(
              item: item,
              valueGetter: () => _dateFormat.format(item.value as DateTime),
              onPressed: () {
                showSelectDateDialog(
                  context,
                  initialDate: item.value as DateTime,
                  onDateChanged: (value) {
                    item.value = value;
                    setState(() {});
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
