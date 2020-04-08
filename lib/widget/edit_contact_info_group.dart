/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
class EditContactInfoGroup extends StatelessWidget {
  final ContactInfoGroup infoGroup;
  final TextInputType inputType;

  const EditContactInfoGroup({
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
        return EditableItem(label: label);
      },
      itemBuilder: (context, item) {
        return SizedBox(
          height: 44,
          child: CupertinoTextField(
            controller: (item as EditableItem).controller,
            keyboardType: inputType,
            style: DefaultTextStyle.of(context).style,
            placeholder: infoGroup.name,
            placeholderStyle: TextStyle(
              color: CupertinoDynamicColor.resolve(
                placeholderColor,
                context,
              ),
            ),
            decoration: null,
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
      },
    );
  }
}
