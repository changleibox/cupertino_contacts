/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/editable_info_group_item.dart';
import 'package:cupertinocontacts/widget/selection_info_group_item.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
class AddressContactInfoGroup extends StatelessWidget {
  const AddressContactInfoGroup({
    Key key,
    @required this.infoGroup,
    this.inputType = TextInputType.text,
  })  : assert(infoGroup != null),
        assert(inputType != null),
        super(key: key);

  final ContactInfoGroup infoGroup;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return ContactInfoGroupWidget(
      infoGroup: infoGroup,
      itemFactory: (index, label) async {
        return AddressItem(
          label: label,
          value: Address(),
        );
      },
      itemBuilder: (context, item) {
        final value = (item as AddressItem).value;
        final street1 = value.street1;
        final street2 = value.street2;
        final city = value.city;
        final region = value.region;
        final postcode = value.postcode;
        final country = value.country;
        return WidgetGroup(
          alignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          direction: Axis.vertical,
          divider: const CupertinoDivider(),
          children: [
            EditableInfoGroupItem(
              controller: street1.controller,
              name: street1.label.labelName,
            ),
            EditableInfoGroupItem(
              controller: street2.controller,
              name: street2.label.labelName,
            ),
            EditableInfoGroupItem(
              controller: city.controller,
              name: city.label.labelName,
            ),
            WidgetGroup(
              children: [
                Expanded(
                  child: EditableInfoGroupItem(
                    controller: region.controller,
                    name: region.label.labelName,
                  ),
                ),
                Expanded(
                  child: EditableInfoGroupItem(
                    controller: postcode.controller,
                    name: postcode.label.labelName,
                  ),
                ),
              ],
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return SelectionInfoGroupItem(
                  item: country,
                  onPressed: () {
                    country.value = 'USA';
                    setState(() {});
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
