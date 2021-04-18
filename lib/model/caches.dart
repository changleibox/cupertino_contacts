/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:async';

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:flutter_contact/contacts.dart';

const _sort = ContactSortOrder.firstName();

/// Created by box on 4/18/21.
///
/// 缓存
class Caches {
  const Caches._();

  static final _contacts = <String, Contact>{};

  static StreamSubscription<dynamic> _subscription;

  /// 初始化
  static Future<void> setup() async {
    await _subscription?.cancel();
    _subscription = listen((event) => cacheContacts());
    await cacheContacts();
  }

  /// 释放缓存
  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _contacts.clear();
  }

  /// 联系人变更事件
  static Stream<ContactEvent> get contactEvents => Contacts.contactEvents;

  /// 监听联系人变化
  static StreamSubscription<ContactEvent> listen(void Function(ContactEvent event) onData) {
    return contactEvents.listen(onData);
  }

  /// 缓存联系人
  static Future<void> cacheContacts() async {
    _contacts.clear();
    await for (var contact in SingleContacts.streamContacts(sortBy: _sort)) {
      _contacts[contact.identifier] = contact;
    }
    await for (var contact in Contacts.streamContacts(sortBy: _sort)) {
      _contacts[contact.identifier] = contact;
    }
  }

  /// 获取联系人
  static Future<List<Contact>> getContacts([String queryText]) async {
    final listContacts = Contacts.listContacts(
      query: queryText,
      sortBy: _sort,
    );
    final contacts = <Contact>[];
    while (await listContacts.moveNext()) {
      contacts.add(await listContacts.current);
    }
    return contacts;
  }

  /// 根据id获取[Contact]
  static Contact getCachedContact(String identifier) => _contacts[identifier];

  /// 根据id获取详情页面的[Contact]
  static Future<Contact> getDetailContact(String identifier, DetailLaunchMode mode) {
    final single = mode == DetailLaunchMode.editView;
    return getContact(identifier, single: single);
  }

  /// 根据id获取[Contact]
  static Future<Contact> getContact(String identifier, {bool single = false}) {
    assert(single != null);
    final service = single ? SingleContacts : Contacts;
    return service.getContact(identifier);
  }

  /// 获取联系人关联的联系人
  static List<String> getLinkedContactIds(Contact contact) {
    return contact.linkedContactIds?.where((element) {
      return element != null && element != contact.identifier;
    })?.toList();
  }

  /// 获取联系人关联的联系人
  static List<Contact> getLinkedContacts(Contact contact) {
    return contact.linkedContactIds?.map((e) {
      return Caches.getCachedContact(e);
    })?.where((element) {
      return element != null && element.identifier != contact.identifier;
    })?.toList();
  }

  /// 新增编辑联系人
  static Future<Contact> editContact(Contact contact, EditLaunchMode mode) {
    final single = mode == EditLaunchMode.other;
    final service = single ? SingleContacts : Contacts;
    Future<Contact> future;
    if (contact.identifier == null) {
      future = service.addContact(contact);
    } else {
      future = service.updateContact(contact);
    }
    return future;
  }

  /// 删除联系人
  static Future<bool> deleteContact(Contact contact, EditLaunchMode mode) {
    final single = mode == EditLaunchMode.other;
    final service = single ? SingleContacts : Contacts;
    return service.deleteContact(contact);
  }

  /// 获取联系人分组
  static Future<Iterable<Group>> getGroups() {
    return Contacts.getGroups();
  }
}
