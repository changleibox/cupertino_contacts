/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/9.
///
/// 属性输入框
class NormalPropertyTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final String name;

  const NormalPropertyTextField({
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
    return CupertinoTextField(
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
      scrollPadding: EdgeInsets.only(
        bottom: 54,
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
    );
  }
}
