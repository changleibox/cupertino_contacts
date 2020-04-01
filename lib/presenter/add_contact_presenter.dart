/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/page/add_contact_page.dart';
import 'package:cupertinocontacts/page/edit_contact_avatar_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/give_up_edit_dialog.dart';
import 'package:cupertinocontacts/widget/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertinocontacts/constant/selection.dart' as selection;

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
      selections: selection.phoneSelections,
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '电子邮件',
      items: List<EditableItem>(),
      selections: selection.emailSelections,
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
      selections: selection.urlSelections,
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '地址',
      items: List<EditableItem>(),
      selections: selection.addressSelections,
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '生日',
      items: List<EditableItem>(),
      selections: selection.birthdaySelections,
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '日期',
      items: List<EditableItem>(),
      selections: selection.dateSelections,
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '关联人',
      items: List<EditableItem>(),
      selections: selection.relatedPartySelections,
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '个人社交资料',
      items: List<EditableItem>(),
      selections: selection.socialDataSelections,
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '即时信息',
      items: List<EditableItem>(),
      selections: selection.instantMessagingSelections,
    ));
    groups.add(MultiEditableContactInfo(
      name: '备注',
    ));
    groups.add(NormalSelectionContactInfo(
      name: '添加信息栏',
    ));
    super.initState();
  }

  onEditAvatarPressed() {
    Navigator.push(
      context,
      RouteProvider.buildRoute(
        EditContactAvatarPage(),
        fullscreenDialog: true,
      ),
    );
  }

  onCancelPressed() {
    showGriveUpEditDialog(context).then((value) {
      if (value) {
        Navigator.maybePop(context);
      }
    });
  }

  onDonePressed() {
    var contact = Contact(
      familyName: baseInfos[0].value,
      givenName: baseInfos[1].value,
      company: baseInfos[2].value,
      phones: (groups[0] as ContactInfoGroup<EditableItem>).items.map((e) {
        return Item(label: e.label, value: e.value);
      }),
      emails: (groups[1] as ContactInfoGroup<EditableItem>).items.map((e) {
        return Item(label: e.label, value: e.value);
      }),
    );
    ContactsService.addContact(contact).then((value) {
      Navigator.pushReplacementNamed(context, RouteProvider.contactDetail);
    }).catchError((error) {
      showText(error.toString(), context);
    });
  }
}
