/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/widget/edit_contact_normal_button.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/1.
///
/// 添加联系人-常用的选择按钮
class EditContactNormalSelectionButton extends StatelessWidget {
  const EditContactNormalSelectionButton({
    Key key,
    @required this.info,
    this.onPressed,
  })  : assert(info != null),
        super(key: key);

  final NormalSelectionContactInfo info;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return EditContactNormalButton(
      text: info.name,
      onPressed: onPressed,
    );
  }
}
