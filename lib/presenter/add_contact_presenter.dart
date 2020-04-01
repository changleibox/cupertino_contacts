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
    groups.add(ContactInfoGroup<EditableItem>(
      name: '电话',
      items: List<EditableItem>(),
      selections: ['住宅', '工作', '学校', 'iPhone', '手机', '主要', '家庭传真', '工作传真', '传呼机', '其他'],
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '电子邮件',
      items: List<EditableItem>(),
      selections: ['住宅', '工作', '学校', 'iCloud', '其他'],
    ));
    groups.add(DefaultSelectionContactInfo(
      name: '电话铃声',
    ));
    groups.add(DefaultSelectionContactInfo(
      name: '短信铃声',
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: 'URL',
      items: List<EditableItem>(),
      selections: ['主页', '住宅', '工作', '学校', '其他'],
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '地址',
      items: List<EditableItem>(),
      selections: ['住宅', '工作', '学校', '其他'],
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '生日',
      items: List<EditableItem>(),
      selections: ['默认生日', '农历生日', '希伯来历', '伊斯兰厉'],
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '日期',
      items: List<EditableItem>(),
      selections: ['纪念日', '其他'],
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '关联人',
      items: List<EditableItem>(),
      selections: [
        '父母',
        '兄弟',
        '姐妹',
        '子女',
        '配偶',
        '助理',
        '父亲',
        '母亲',
        '哥哥',
        '姐姐',
        '弟弟',
        '妹妹',
        '丈夫',
        '妻子',
        '伴侣',
        '儿子',
        '女儿',
        '朋友',
        '上司',
        '同事',
        '其他',
        '所有标签',
      ],
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '个人社交资料',
      items: List<EditableItem>(),
      selections: ['Twitter', 'Facebook', 'Flickr', '领英', 'Myspace', '新浪微博'],
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '即时信息',
      items: List<EditableItem>(),
      selections: ['Skype', 'MSN', 'Google Talk', 'AIM', '雅虎', 'ICQ', 'Jabber', 'QQ', 'Gadu-Gadu'],
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
