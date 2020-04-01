/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/page/add_contact_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/widget/give_up_edit_dialog.dart';
import 'package:flutter/cupertino.dart';

class AddContactPresenter extends Presenter<AddContactPage> {
  final baseInfos = List<EditableContactInfo>();
  final groups = List<ContactInfo>();

  @override
  void initState() {
    baseInfos.add(EditableContactInfo(
      name: '姓氏',
    ));
    baseInfos.add(EditableContactInfo(
      name: '名字',
    ));
    baseInfos.add(EditableContactInfo(
      name: '公司',
    ));
    groups.add(ContactInfoGroup(
      name: '电话',
    ));
    groups.add(ContactInfoGroup(
      name: '电子邮件',
    ));
    groups.add(DefaultSelectionContactInfo(
      name: '电话铃声',
    ));
    groups.add(DefaultSelectionContactInfo(
      name: '短信铃声',
    ));
    groups.add(ContactInfoGroup(
      name: 'URL',
    ));
    groups.add(ContactInfoGroup(
      name: '地址',
    ));
    groups.add(ContactInfoGroup(
      name: '生日',
    ));
    groups.add(ContactInfoGroup(
      name: '日期',
    ));
    groups.add(ContactInfoGroup(
      name: '关联人',
    ));
    groups.add(ContactInfoGroup(
      name: '个人社交资料',
    ));
    groups.add(ContactInfoGroup(
      name: '即时信息',
    ));
    groups.add(MultiEditableContactInfo(
      name: '备注',
    ));
    groups.add(NormalSelectionContactInfo(
      name: '添加信息栏',
    ));
    super.initState();
  }

  onCancelPressed() {
    showGriveUpEditDialog(context).then((value) {
      if (value) {
        Navigator.maybePop(context);
      }
    });
  }

  onDonePressed() {
    Navigator.maybePop(context);
  }
}
