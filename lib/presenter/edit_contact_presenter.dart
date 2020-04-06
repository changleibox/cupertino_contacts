/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/constant/selection.dart' as selection;
import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/page/contact_detail_page.dart';
import 'package:cupertinocontacts/page/edit_contact_avatar_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/util/collections.dart';
import 'package:cupertinocontacts/widget/give_up_edit_dialog.dart';
import 'package:cupertinocontacts/widget/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class EditContactPresenter extends Presenter<EditContactPage> implements ValueListenable<Contact> {
  ObserverList<VoidCallback> _listeners = ObserverList<VoidCallback>();
  final baseInfos = List<EditableContactInfo>();
  final groups = List<ContactInfo>();

  Uint8List avatar;

  Contact _initialContact;

  bool get isChanged => _initialContact != value;

  @override
  void initState() {
    _initialContact = widget.contact ??
        Contact(
          phones: [],
          emails: [],
          postalAddresses: [],
        );

    avatar = _initialContact.avatar;

    baseInfos.add(EditableContactInfo(
      name: '姓氏',
      value: _initialContact.familyName,
    ));
    baseInfos.add(EditableContactInfo(
      name: '名字',
      value: _initialContact.givenName,
    ));
    baseInfos.add(EditableContactInfo(
      name: '公司',
      value: _initialContact.company,
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '电话',
      items: _initialContact.phones?.map((e) {
        return EditableItem(label: e.label, value: e.value);
      })?.toList(),
      selections: selection.phoneSelections,
    ));
    groups.add(ContactInfoGroup<EditableItem>(
      name: '电子邮件',
      items: _initialContact.emails?.map((e) {
        return EditableItem(label: e.label, value: e.value);
      })?.toList(),
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

    baseInfos.forEach((element) => element.addListener(notifyListeners));
    groups.forEach((element) => element.addListener(notifyListeners));
    super.initState();
  }

  @override
  void dispose() {
    _listeners = null;
    baseInfos.forEach((element) => element.dispose());
    groups.forEach((element) => element.dispose());
    super.dispose();
  }

  onEditAvatarPressed() {
    Navigator.push(
      context,
      RouteProvider.buildRoute(
        EditContactAvatarPage(
          avatar: avatar,
        ),
        fullscreenDialog: true,
      ),
    ).then((value) {
      if (value == null) {
        return;
      }
      if (Collections.equals(avatar, value)) {
        return;
      }
      avatar = value;
      notifyDataSetChanged();
      notifyListeners();
    });
  }

  onCancelPressed() {
    if (!isChanged) {
      Navigator.maybePop(context);
    } else {
      showGriveUpEditDialog(context).then((value) {
        if (value ?? false) {
          Navigator.maybePop(context);
        }
      });
    }
  }

  onDonePressed() {
    Future future;
    if (value.identifier == null) {
      future = ContactsService.addContact(value);
    } else {
      future = ContactsService.updateContact(value);
    }
    future.then((value) {
      Navigator.pushReplacement(
        context,
        RouteProvider.buildRoute(
          ContactDetailPage(contact: this.value),
        ),
      );
    }).catchError((error) {
      showText(error.toString(), context);
    });
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  @override
  Contact get value {
    final contactMap = {
      'identifier': _initialContact.identifier,
      'avatar': avatar,
      'familyName': baseInfos[0].value,
      'givenName': baseInfos[1].value,
      'company': baseInfos[2].value,
      'phones': (groups[0] as ContactInfoGroup<EditableItem>).value.where((element) {
        return element.value != null && element.value.isNotEmpty;
      }).map((e) {
        return Item(label: e.label, value: e.value);
      }).toList(),
      'emails': (groups[1] as ContactInfoGroup<EditableItem>).value.where((element) {
        return element.value != null && element.value.isNotEmpty;
      }).map((e) {
        return Item(label: e.label, value: e.value);
      }).toList(),
      'postalAddresses': _initialContact.postalAddresses,
    };
    return Contact.fromMap(contactMap);
  }

  @protected
  @visibleForTesting
  void notifyListeners() {
    if (_listeners != null) {
      final List<VoidCallback> localListeners = List<VoidCallback>.from(_listeners);
      for (final VoidCallback listener in localListeners) {
        try {
          if (_listeners.contains(listener)) listener();
        } catch (exception) {}
      }
    }
  }
}
