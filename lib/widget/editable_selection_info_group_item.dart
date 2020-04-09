/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/contact_item_container.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/9.
///
/// 可编辑、可选择的item
class EditableSelectionInfoGroupItem extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final String name;

  const EditableSelectionInfoGroupItem({
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
    return ContactItemContainer(
      child: WidgetGroup.spacing(
        children: <Widget>[
          Expanded(
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
              decoration: null,
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              clearButtonMode: OverlayVisibilityMode.editing,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
            ),
          ),
          CupertinoButton(
            minSize: 24,
            onPressed: () {},
            borderRadius: BorderRadius.zero,
            padding: EdgeInsets.zero,
            child: Icon(
              CupertinoIcons.info,
            ),
          ),
          Icon(
            CupertinoIcons.forward,
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.secondaryLabel,
              context,
            ),
          ),
        ],
      ),
    );
  }
}
