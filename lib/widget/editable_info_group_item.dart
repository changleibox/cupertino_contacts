/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/contact_item_container.dart';
import 'package:cupertinocontacts/widget/normal_property_text_field.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/9.
///
/// 可编辑的item
class EditableInfoGroupItem extends StatelessWidget {
  const EditableInfoGroupItem({
    Key key,
    @required this.controller,
    this.inputType = TextInputType.text,
    @required this.name,
  })  : assert(controller != null),
        assert(inputType != null),
        assert(name != null),
        super(key: key);

  final TextEditingController controller;
  final TextInputType inputType;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ContactItemContainer(
      child: NormalPropertyTextField(
        controller: controller,
        name: name,
        inputType: inputType,
      ),
    );
  }
}
