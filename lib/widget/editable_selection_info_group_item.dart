/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/contact_item_container.dart';
import 'package:cupertinocontacts/widget/normal_property_text_field.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/9.
///
/// 可编辑、可选择的item
class EditableSelectionInfoGroupItem extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final String name;
  final VoidCallback onPressed;

  const EditableSelectionInfoGroupItem({
    Key key,
    @required this.controller,
    this.inputType = TextInputType.text,
    @required this.name,
    this.onPressed,
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
            child: NormalPropertyTextField(
              controller: controller,
              name: name,
              inputType: inputType,
            ),
          ),
          CupertinoButton(
            minSize: 24,
            onPressed: onPressed,
            borderRadius: BorderRadius.zero,
            padding: EdgeInsets.zero,
            child: Icon(
              CupertinoIcons.info,
            ),
          ),
          Icon(
            CupertinoIcons.forward,
            size: 20,
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.tertiaryLabel,
              context,
            ),
          ),
        ],
      ),
    );
  }
}
