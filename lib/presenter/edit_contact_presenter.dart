/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/enums/contact_item_type.dart';
import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/model/caches.dart';
import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/page/contact_detail_page.dart';
import 'package:cupertinocontacts/page/edit_contact_avatar_page.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/util/collections.dart';
import 'package:cupertinocontacts/widget/delete_contact_dialog.dart';
import 'package:cupertinocontacts/widget/edit_contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/give_up_edit_dialog.dart';
import 'package:cupertinocontacts/widget/load_prompt.dart';
import 'package:cupertinocontacts/widget/toast.dart';
import 'package:flexidate/flexidate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_contact/contacts.dart';

class EditContactPresenter extends Presenter<EditContactPage> implements EditContactOperation {
  ObserverList<VoidCallback> _listeners = ObserverList<VoidCallback>();
  final baseInfoMap = <ContactInfoType, EditableContactInfo>{};
  final itemMap = <ContactItemType, ContactInfo>{};

  Uint8List _avatar;

  Contact _initialContact;

  @override
  Uint8List get avatar => _avatar;

  @override
  bool get isChanged {
    final contact = value;
    return _initialContact != contact ||
        !Collections.equals(_avatar, _initialContact.avatar) ||
        !Collections.equals(Caches.getLinkedContactIds(_initialContact), Caches.getLinkedContactIds(contact));
  }

  @override
  void initState() {
    _initialContact = _alignmentContact(widget.contact ?? Contact());

    _avatar = _initialContact.avatar;

    baseInfoMap[ContactInfoType.familyName] = EditableContactInfo(
      name: '姓氏',
      value: _initialContact.familyName,
    );
    baseInfoMap[ContactInfoType.givenName] = EditableContactInfo(
      name: '名字',
      value: _initialContact.givenName,
    );
    baseInfoMap[ContactInfoType.company] = EditableContactInfo(
      name: '公司',
      value: _initialContact.company,
    );
    itemMap[ContactItemType.phone] = ContactInfoGroup<EditableItem>(
      name: '电话',
      items: _initialContact.phones?.where((element) {
        return selections.contains(SelectionType.phone, element.label);
      })?.map((e) {
        return EditableItem(
          label: selections.selectionAtName(SelectionType.phone, e.label),
          value: e.value,
        );
      })?.toList(),
      selectionType: SelectionType.phone,
    );
    itemMap[ContactItemType.email] = ContactInfoGroup<EditableItem>(
      name: '电子邮件',
      items: _initialContact.emails?.where((element) {
        return selections.contains(SelectionType.email, element.label);
      })?.map((e) {
        return EditableItem(
          label: selections.selectionAtName(SelectionType.email, e.label),
          value: e.value,
        );
      })?.toList(),
      selectionType: SelectionType.email,
    );
    itemMap[ContactItemType.phoneRinging] = DefaultSelectionContactInfo(
      name: '电话铃声',
    );
    itemMap[ContactItemType.smsRinging] = DefaultSelectionContactInfo(
      name: '短信铃声',
    );
    itemMap[ContactItemType.url] = ContactInfoGroup<EditableItem>(
      name: 'URL',
      items: _initialContact.urls?.where((element) {
        return selections.contains(SelectionType.url, element.label);
      })?.map((e) {
        return EditableItem(
          label: selections.selectionAtName(SelectionType.url, e.label),
          value: e.value,
        );
      })?.toList(),
      selectionType: SelectionType.url,
    );
    itemMap[ContactItemType.address] = ContactInfoGroup<AddressItem>(
      name: '地址',
      items: _initialContact.postalAddresses?.where((element) {
        return selections.contains(SelectionType.address, element.label);
      })?.map((e) {
        return AddressItem(
          label: selections.selectionAtName(SelectionType.address, e.label),
          value: Address(
            street1: e.street,
            city: e.city,
            region: e.region,
            postcode: e.postcode,
            country: e.country,
          ),
        );
      })?.toList(),
      selectionType: SelectionType.address,
    );
    itemMap[ContactItemType.birthday] = ContactInfoGroup<DateTimeItem>(
      name: '生日',
      items: _initialContact.dates?.where((element) {
        return selections.contains(SelectionType.birthday, element.label);
      })?.map((e) {
        final dateTime = DateTime.parse(e.dateOrValue);
        return DateTimeItem(
          label: selections.selectionAtName(SelectionType.birthday, e.label),
          value: dateTime,
        );
      })?.toList(),
      selectionType: SelectionType.birthday,
    );
    itemMap[ContactItemType.date] = ContactInfoGroup<DateTimeItem>(
      name: '日期',
      items: _initialContact.dates?.where((element) {
        return selections.contains(SelectionType.date, element.label);
      })?.map((e) {
        final dateTime = DateTime.parse(e.dateOrValue);
        return DateTimeItem(
          label: selections.selectionAtName(SelectionType.date, e.label),
          value: dateTime,
        );
      })?.toList(),
      selectionType: SelectionType.date,
    );
    itemMap[ContactItemType.relatedParty] = ContactInfoGroup<EditableSelectionItem>(
      name: '关联人',
      items: <EditableSelectionItem>[],
      selectionType: SelectionType.relatedParty,
    );
    itemMap[ContactItemType.socialData] = ContactInfoGroup<EditableItem>(
      name: '个人社交资料',
      items: _initialContact.socialProfiles?.where((element) {
        return selections.contains(SelectionType.socialData, element.label);
      })?.map((e) {
        return EditableItem(
          label: selections.selectionAtName(SelectionType.socialData, e.label),
          value: e.value,
        );
      })?.toList(),
      selectionType: SelectionType.socialData,
    );
    itemMap[ContactItemType.instantMessaging] = ContactInfoGroup<EditableItem>(
      name: '即时信息',
      items: <EditableItem>[],
      selectionType: SelectionType.instantMessaging,
    );
    itemMap[ContactItemType.remarks] = MultiEditableContactInfo(
      name: '备注',
      value: _initialContact.note,
    );
    itemMap[ContactItemType.addInfo] = NormalSelectionContactInfo(
      name: '添加信息栏',
    );
    if (widget.launchMode == EditLaunchMode.normal) {
      final propertyName = selections.iPhoneSelection.propertyName;
      itemMap[ContactItemType.linkContact] = ContactInfoGroup<ContactSelectionItem>(
        name: '链接联系人…',
        selectionType: SelectionType.linkContact,
        items: Caches.getLinkedContacts(_initialContact)?.map((e) {
          return ContactSelectionItem(
            label: selections.selectionAtName(SelectionType.linkContact, propertyName),
            value: e,
          );
        })?.toList(),
      );
    }

    for (var element in baseInfoMap.values) {
      element.addListener(notifyListeners);
    }
    for (var element in itemMap.values) {
      element.addListener(notifyListeners);
    }
    super.initState();
  }

  @override
  void dispose() {
    _listeners = null;
    for (var element in baseInfoMap.values) {
      element.dispose();
    }
    for (var element in itemMap.values) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  void onEditAvatarPressed() {
    Navigator.push<Uint8List>(
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
  void onCancelPressed() {
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
  void onDonePressed() {
    Caches.editContact(value, widget.launchMode).then((value) {
      if (widget.contact != null) {
        Navigator.pop(context, value);
      } else {
        Navigator.pushReplacement<void, void>(
          context,
          RouteProvider.buildRoute(
            ContactDetailPage(
              identifier: value.identifier,
              contact: value,
            ),
          ),
        );
      }
    }).catchError((dynamic error) {
      showText(error.toString(), context);
    });
  }

  void onDeleteContactPressed() {
    if (widget.contact == null) {
      return;
    }
    showDeleteContactDialog(context, widget.contact).then((value) {
      if (value == null || !value) {
        return;
      }
      final loadPrompt = LoadPrompt(context)..show();
      Caches.deleteContact(widget.contact, widget.launchMode).then((value) {
        loadPrompt.dismiss();
        Navigator.popUntil(context, ModalRoute.withName(RouteProvider.home));
      }).catchError((dynamic _) {
        loadPrompt.dismiss();
      });
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
    final dates = _convertDatetime(itemMap[ContactItemType.birthday] as ContactInfoGroup<DateTimeItem>);
    dates.addAll(_convertDatetime(itemMap[ContactItemType.date] as ContactInfoGroup<DateTimeItem>));

    final contact = Contact(keys: _initialContact.keys);
    contact.identifier = _initialContact.identifier;
    contact.avatar = _avatar;
    contact.prefix = _initialContact.prefix;
    contact.suffix = _initialContact.suffix;
    contact.middleName = _initialContact.middleName;
    contact.displayName = _initialContact.displayName;
    contact.familyName = baseInfoMap[ContactInfoType.familyName].value ?? '';
    contact.givenName = baseInfoMap[ContactInfoType.givenName].value ?? '';
    contact.company = baseInfoMap[ContactInfoType.company].value ?? '';
    contact.jobTitle = _initialContact.jobTitle;
    contact.phones = _convert(itemMap[ContactItemType.phone] as ContactInfoGroup<EditableItem>);
    contact.emails = _convert(itemMap[ContactItemType.email] as ContactInfoGroup<EditableItem>);
    contact.urls = _convert(itemMap[ContactItemType.url] as ContactInfoGroup<EditableItem>);
    contact.dates = dates;
    contact.lastModified = _initialContact.lastModified;
    contact.socialProfiles = _convert(itemMap[ContactItemType.socialData] as ContactInfoGroup<EditableItem>);
    contact.postalAddresses = _convertAddress(itemMap[ContactItemType.address] as ContactInfoGroup<AddressItem>);
    contact.note = itemMap[ContactItemType.remarks].value?.toString() ?? '';
    contact.linkedContactIds = _convertLinkedContact(itemMap[ContactItemType.linkContact] as ContactInfoGroup<ContactSelectionItem>);
    return _alignmentContact(contact);
  }

  List<Item> _convert(ContactInfoGroup<EditableItem> infoGroup) {
    return infoGroup.value.where((element) => element.isNotEmpty).map((e) {
      return Item(label: e.label.propertyName, value: e.value);
    }).toList();
  }

  List<PostalAddress> _convertAddress(ContactInfoGroup<AddressItem> infoGroup) {
    return infoGroup.value.where((element) => element.isNotEmpty).map((e) {
      final value = e.value;
      return PostalAddress(
        label: e.label.propertyName,
        street: value.street1.value,
        city: value.city.value,
        region: value.region.value,
        postcode: value.postcode.value,
        country: value.country.value,
      );
    }).toList();
  }

  List<ContactDate> _convertDatetime(ContactInfoGroup<DateTimeItem> infoGroup) {
    return infoGroup.value.where((element) => element.isNotEmpty).map((e) {
      final dateTime = e.value;
      return ContactDate.ofDate(
        label: e.label.propertyName,
        date: FlexiDate.ofDateTime(dateTime),
      );
    }).toList();
  }

  List<String> _convertLinkedContact(ContactInfoGroup<ContactSelectionItem> infoGroup) {
    if (infoGroup == null) {
      return null;
    }
    return infoGroup.value.where((element) => element.isNotEmpty).map((e) {
      return e.value.identifier;
    }).toList();
  }

  @protected
  @visibleForTesting
  void notifyListeners() {
    if (_listeners != null) {
      final localListeners = List<VoidCallback>.from(_listeners);
      for (final listener in localListeners) {
        try {
          if (_listeners.contains(listener)) {
            listener();
          }
          // ignore: empty_catches
        } catch (error) {}
      }
    }
  }

  Contact _alignmentContact(Contact contact) {
    contact.familyName ??= '';
    contact.givenName ??= '';
    contact.company ??= '';
    contact.phones ??= [];
    contact.emails ??= [];
    contact.urls ??= [];
    contact.note ??= '';
    contact.phones = contact.phones?.map((e) => _LabelItem(label: e.label, value: e.value))?.toList();
    contact.emails = contact.emails?.map((e) => _LabelItem(label: e.label, value: e.value))?.toList();
    contact.urls = contact.urls?.map((e) => _LabelItem(label: e.label, value: e.value))?.toList();
    contact.socialProfiles = contact.socialProfiles?.map((e) => _LabelItem(label: e.label, value: e.value))?.toList();
    contact.linkedContactIds ??= [];
    return contact;
  }
}

// ignore: must_be_immutable
class _LabelItem extends Item {
  _LabelItem({
    String label,
    String value,
  }) : super(label: label, value: value);

  @override
  List<dynamic> get props => <String>[label, equalsValue];
}
