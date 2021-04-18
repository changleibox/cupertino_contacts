/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'package:flutter_contact/contacts.dart';

/// Created by box on 4/18/21.
///
/// 缓存
class Caches {
  const Caches._();

  static final _contacts = <String, Contact>{};

  /// 获取联系人
  static Future<List<Contact>> getContacts([String queryText]) async {
    final total = await Contacts.getTotalContacts(query: queryText);
    final streamContacts = Contacts.streamContacts(
      bufferSize: total,
      sortBy: const ContactSortOrder.firstName(),
    );
    _contacts.clear();
    await for (var contact in streamContacts) {
      _contacts[contact.identifier] = contact;
    }
    final listContacts = Contacts.listContacts(
      query: queryText,
      bufferSize: total,
      sortBy: const ContactSortOrder.firstName(),
    );
    final contacts = await listContacts.jumpToPage(0);
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
}
