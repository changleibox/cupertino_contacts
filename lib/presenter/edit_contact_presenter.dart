/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';
import 'dart:typed_data';

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/enums/contact_item_type.dart';
import 'package:cupertinocontacts/model/contact_info_group.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_contact/contacts.dart';

class EditContactPresenter extends Presenter<EditContactPage> implements EditContactOperation {
  ObserverList<VoidCallback> _listeners = ObserverList<VoidCallback>();
  final baseInfoMap = LinkedHashMap<ContactInfoType, EditableContactInfo>();
  final itemMap = LinkedHashMap<ContactItemType, ContactInfo>();

  Uint8List _avatar;

  Contact _initialContact;

  @override
  Uint8List get avatar => _avatar;

  @override
  bool get isChanged => _initialContact != value || !Collections.equals(_avatar, _initialContact.avatar);

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
          label: selections.elementAtName(SelectionType.phone, e.label),
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
          label: selections.elementAtName(SelectionType.email, e.label),
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
          label: selections.elementAtName(SelectionType.url, e.label),
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
          label: selections.elementAtName(SelectionType.address, e.label),
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
        return DateTimeItem(
          label: selections.elementAtName(SelectionType.birthday, e.label),
          value: e.date.toDateTime(),
        );
      })?.toList(),
      selectionType: SelectionType.birthday,
    );
    itemMap[ContactItemType.date] = ContactInfoGroup<DateTimeItem>(
      name: '日期',
      items: _initialContact.dates?.where((element) {
        return selections.contains(SelectionType.date, element.label);
      })?.map((e) {
        return DateTimeItem(
          label: selections.elementAtName(SelectionType.date, e.label),
          value: e.date.toDateTime(),
        );
      })?.toList(),
      selectionType: SelectionType.date,
    );
    itemMap[ContactItemType.relatedParty] = ContactInfoGroup<EditableSelectionItem>(
      name: '关联人',
      items: List<EditableSelectionItem>(),
      selectionType: SelectionType.relatedParty,
    );
    itemMap[ContactItemType.socialData] = ContactInfoGroup<EditableItem>(
      name: '个人社交资料',
      items: _initialContact.socialProfiles?.where((element) {
        return selections.contains(SelectionType.socialData, element.label);
      })?.map((e) {
        return EditableItem(
          label: selections.elementAtName(SelectionType.socialData, e.label),
          value: e.value,
        );
      })?.toList(),
      selectionType: SelectionType.socialData,
    );
    itemMap[ContactItemType.instantMessaging] = ContactInfoGroup<EditableItem>(
      name: '即时信息',
      items: List<EditableItem>(),
      selectionType: SelectionType.instantMessaging,
    );
    itemMap[ContactItemType.remarks] = MultiEditableContactInfo(
      name: '备注',
      value: _initialContact.note,
    );
    itemMap[ContactItemType.addInfo] = NormalSelectionContactInfo(
      name: '添加信息栏',
    );
    if (widget.contact != null && widget.launchMode == EditLaunchMode.normal) {
      itemMap[ContactItemType.linkContact] = ContactInfoGroup<ContactSelectionItem>(
        name: '链接联系人…',
        selectionType: SelectionType.linkContact,
      );
    }

    baseInfoMap.values.forEach((element) => element.addListener(notifyListeners));
    itemMap.values.forEach((element) => element.addListener(notifyListeners));
    super.initState();
  }

  @override
  void dispose() {
    _listeners = null;
    baseInfoMap.values.forEach((element) => element.dispose());
    itemMap.values.forEach((element) => element.dispose());
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
      if (widget.contact != null) {
        Navigator.pop(context, value);
      } else {
        Navigator.pushReplacement(
          context,
          RouteProvider.buildRoute(
            ContactDetailPage(
              identifier: value.identifier,
              contact: value,
            ),
          ),
        );
      }
    }).catchError((error) {
      showText(error.toString(), context);
    });
  }

  onDeleteContactPressed() {
    if (widget.contact == null) {
      return;
    }
    showDeleteContactDialog(context, widget.contact).then((value) {
      if (value == null || !value) {
        return;
      }
      var loadPrompt = LoadPrompt(context)..show();
      Contacts.deleteContact(widget.contact).then((value) {
        loadPrompt.dismiss();
        Navigator.popUntil(context, ModalRoute.withName(RouteProvider.home));
      }).catchError((_) {
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
    var birthdayDates = _convertDatetime(itemMap[ContactItemType.birthday]);
    var dates = _convertDatetime(itemMap[ContactItemType.date]);
    dates.addAll(birthdayDates);

    var contact = Contact();
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
    contact.phones = _convert(itemMap[ContactItemType.phone]);
    contact.emails = _convert(itemMap[ContactItemType.email]);
    contact.urls = _convert(itemMap[ContactItemType.url]);
    contact.dates = dates;
    contact.lastModified = _initialContact.lastModified;
    contact.socialProfiles = _convert(itemMap[ContactItemType.socialData]);
    contact.postalAddresses = _convertAddress(itemMap[ContactItemType.address]);
    contact.note = itemMap[ContactItemType.remarks].value ?? '';
    return _alignmentContact(contact);
  }

  List<Item> _convert(ContactInfoGroup<EditableItem> infoGroup) {
    return infoGroup.value.where((element) => element.isNotEmpty).map((e) {
      return Item(label: e.label.propertyName, value: e.value);
    }).toList();
  }

  List<PostalAddress> _convertAddress(ContactInfoGroup<AddressItem> infoGroup) {
    return infoGroup.value.where((element) => element.isNotEmpty).map((e) {
      var value = e.value;
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
      var dateTime = e.value;
      return ContactDate(
        label: e.label.propertyName,
        date: DateComponents.fromDateTime(dateTime),
      );
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
  List get props => [label, equalsValue];
}
