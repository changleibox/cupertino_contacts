/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/constant/selection.dart' as selection;
import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/page/contact_detail_page.dart';
import 'package:cupertinocontacts/page/edit_contact_avatar_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/util/collections.dart';
import 'package:cupertinocontacts/util/contact_utils.dart';
import 'package:cupertinocontacts/widget/edit_contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/give_up_edit_dialog.dart';
import 'package:cupertinocontacts/widget/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_contact/contacts.dart';

class EditContactPresenter extends Presenter<EditContactPage> implements EditContactOperation {
  ObserverList<VoidCallback> _listeners = ObserverList<VoidCallback>();
  final baseInfos = List<EditableContactInfo>();
  final groups = List<ContactInfo>();

  Uint8List _avatar;

  Contact _initialContact;

  @override
  Uint8List get avatar => _avatar;

  @override
  bool get isChanged => _initialContact != value;

  @override
  void initState() {
    _initialContact = widget.contact ?? Contact();

    _avatar = _initialContact.avatar;

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
      items: _initialContact.urls?.map((e) {
        return EditableItem(label: e.label, value: e.value);
      })?.toList(),
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

  @override
  onEditAvatarPressed() {
    Navigator.push(
      context,
      RouteProvider.buildRoute(
        EditContactAvatarPage(
          avatar: _avatar,
        ),
        fullscreenDialog: true,
      ),
    ).then((value) {
      if (value == null) {
        return;
      }
      if (Collections.equals(_avatar, value)) {
        return;
      }
      _avatar = value;
      notifyDataSetChanged();
      notifyListeners();
    });
  }

  @override
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

  @override
  onDonePressed() {
    Future<Contact> future;
    if (value.identifier == null) {
      future = Contacts.addContact(value);
    } else {
      future = Contacts.updateContact(value);
    }
    future.then((value) {
      Navigator.pushReplacement(
        context,
        RouteProvider.buildRoute(
          ContactDetailPage(contact: value),
        ),
      );
    }).catchError((error) {
      showText(error.toString(), context);
    });
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners?.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners?.remove(listener);
  }

  @override
  Contact get value {
    var phones = _convert(groups[0]);
    var emails = _convert(groups[1]);
    var urls = _convert(groups[4]);
    final contactMap = {
      'identifier': _initialContact.identifier,
      'avatar': _avatar,
      'prefix': _initialContact.prefix,
      'suffix': _initialContact.suffix,
      'middleName': _initialContact.middleName,
      'displayName': _initialContact.displayName,
      'familyName': baseInfos[0].value,
      'givenName': baseInfos[1].value,
      'company': baseInfos[2].value,
      'jobTitle': _initialContact.jobTitle,
      'phones': phones.isEmpty ? _initialContact.phones : phones,
      'emails': emails.isEmpty ? _initialContact.emails : emails,
      'urls': urls.isEmpty ? _initialContact.urls : urls,
    };
    var contact = Contact.fromMap(contactMap);
    contact.displayName = ContactUtils.buildDisplayName(contact);
    return contact + _initialContact;
  }

  List<Map> _convert(ContactInfoGroup<EditableItem> infoGroup) {
    return infoGroup.value.where((element) {
      return element.value != null && element.value.isNotEmpty;
    }).map((e) {
      return {"label": e.label, "value": e.value};
    }).toList();
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
