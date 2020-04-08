/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/selection_contact_info_group.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
class AddressContactInfoGroup extends StatelessWidget {
  final ContactInfoGroup infoGroup;
  final TextInputType inputType;

  const AddressContactInfoGroup({
    Key key,
    @required this.infoGroup,
    this.inputType = TextInputType.text,
  })  : assert(infoGroup != null),
        assert(inputType != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContactInfoGroupWidget(
      infoGroup: infoGroup,
      itemFactory: (index, label) {
        return AddressItem(
          label: label,
          value: Address(),
        );
      },
      itemBuilder: (context, item) {
        var value = (item as AddressItem).value;
        var street1 = value.street1;
        var street2 = value.street2;
        var city = value.city;
        var region = value.region;
        var postcode = value.postcode;
        var country = value.country;
        return WidgetGroup(
          alignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          direction: Axis.vertical,
          divider: CupertinoDivider(),
          children: [
            _ItemTextField(
              controller: street1.controller,
              name: street1.label,
            ),
            _ItemTextField(
              controller: street2.controller,
              name: street2.label,
            ),
            _ItemTextField(
              controller: city.controller,
              name: city.label,
            ),
            WidgetGroup(
              divider: Container(
                color: CupertinoDynamicColor.resolve(
                  separatorColor,
                  context,
                ),
                width: 0.5,
                height: 44,
              ),
              children: [
                Expanded(
                  child: _ItemTextField(
                    controller: region.controller,
                    name: region.label,
                  ),
                ),
                Expanded(
                  child: _ItemTextField(
                    controller: postcode.controller,
                    name: postcode.label,
                  ),
                ),
              ],
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return SelectionContactInfoGroup(
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

class _ItemTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final String name;

  const _ItemTextField({
    Key key,
    @required this.controller,
    this.inputType = TextInputType.text,
    @required this.name,
  })  : assert(controller != null),
        assert(inputType != null),
        assert(name != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: CupertinoTextField(
        controller: controller,
        keyboardType: inputType,
        style: DefaultTextStyle.of(context).style,
        placeholder: name,
        placeholderStyle: TextStyle(
          color: CupertinoDynamicColor.resolve(
            placeholderColor,
            context,
          ),
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.secondarySystemGroupedBackground,
        ),
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        clearButtonMode: OverlayVisibilityMode.editing,
        scrollPadding: EdgeInsets.only(
          bottom: 54,
        ),
        textInputAction: TextInputAction.next,
        onEditingComplete: () {
          FocusScope.of(context).nextFocus();
        },
      ),
    );
  }
}
