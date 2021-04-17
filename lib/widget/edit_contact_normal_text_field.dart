/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/normal_property_text_field.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 新建联系人-默认输入框
class EditContactNormalTextField extends StatelessWidget {
  const EditContactNormalTextField({
    Key key,
    @required this.info,
    this.inputType = TextInputType.text,
  })  : assert(info != null),
        assert(inputType != null),
        super(key: key);

  final EditableContactInfo info;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.only(
        right: 10,
      ),
      child: NormalPropertyTextField(
        controller: info.controller,
        name: info.name,
        inputType: inputType,
      ),
    );
  }
}
