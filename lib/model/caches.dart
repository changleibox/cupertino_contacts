/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:async';

import 'package:flutter_contact/contacts.dart';

/// Created by box on 4/18/21.
///
/// 缓存
class Caches {
  const Caches._();

  static final _contacts = <String, Contact>{};

  /// 获取联系人
  static Future<List<Contact>> getContacts([String queryText]) async {
    final streamContacts = SingleContacts.streamContacts(
      sortBy: const ContactSortOrder.firstName(),
    );
    _contacts.clear();
    await for (var contact in streamContacts) {
      _contacts[contact.identifier] = contact;
    }
    final listContacts = Contacts.listContacts(
      query: queryText,
      sortBy: const ContactSortOrder.firstName(),
    );
    final contacts = <Contact>[];
    while (await listContacts.moveNext()) {
      final identifier = (await listContacts.current).identifier;
      final contact = await Contacts.getContact(identifier);
      contacts.add(contact);
      _contacts[identifier] = contact;
    }
    return contacts;
  }

  /// 根据id获取[Contact]
  static Contact getContact(String identifier) => _contacts[identifier];

  /// 获取联系人关联的联系人
  static List<String> getLinkedContactIds(Contact contact) {
    return contact.linkedContactIds?.where((element) {
      return element != null && element != contact.identifier;
    })?.toList();
  }

  /// 获取联系人关联的联系人
  static List<Contact> getLinkedContacts(Contact contact) {
    return contact.linkedContactIds?.map((e) {
      return Caches.getContact(e);
    })?.where((element) {
      return element != null && element.identifier != contact.identifier;
    })?.toList();
  }

  /// 新增编辑联系人
  static Future<Contact> editContact(Contact contact) {
    Future<Contact> future;
    if (contact.identifier == null) {
      future = Contacts.addContact(contact);
    } else {
      future = Contacts.updateContact(contact);
    }
    return future;
  }

  /// 获取联系人分组
  static Future<Iterable<Group>> getGroups() {
    return Contacts.getGroups();
  }

  /// 联系人变更事件
  static Stream<ContactEvent> get contactEvents => Contacts.contactEvents;

  /// 监听联系人变化
  static StreamSubscription<ContactEvent> listen(void Function(ContactEvent event) onData) {
    return contactEvents.listen(onData);
  }

  /// 删除联系人
  static Future<bool> deleteContact(Contact contact) async {
    return Contacts.deleteContact(contact);
  }
}
