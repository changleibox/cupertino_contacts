/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/page/cupertino_contacts_page.dart';
import 'package:cupertinocontacts/presenter/list_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:lpinyin/lpinyin.dart';

const String _kOctothorpe = '#';

class CupertinoContactsPresenter extends ListPresenter<CupertinoContactsPage, Contact> {
  final _contactsMap = LinkedHashMap<String, List<Contact>>();
  final _contactKeys = List<GlobalKey>();

  int get keyCount => _contactKeys.length;

  List<GlobalKey> get contactKeys => _contactKeys;

  List<String> get indexs => _contactsMap.keys.toList();

  Iterable<MapEntry<String, List<Contact>>> get entries => _contactsMap.entries;

  @override
  Future<List<Contact>> onLoad(bool showProgress) async {
    return (await ContactsService.getContacts(query: queryText)).toList();
  }

  @override
  void onLoaded(Iterable<Contact> contacts) {
    final contactsMap = Map<String, List<Contact>>();
    for (var contact in contacts) {
      var firstLetter = _analysisFirstLetter(contact.familyName ?? contact.displayName);
      var contacts = contactsMap[firstLetter];
      if (contacts == null) {
        contacts = List<Contact>();
      }
      contacts.add(contact);
      contactsMap[firstLetter] = contacts;
    }
    var entries = List.of(contactsMap.entries);
    entries.sort((a, b) {
      var key1 = a.key;
      var key2 = b.key;
      if (key1 == _kOctothorpe && key2 != _kOctothorpe) {
        return 1;
      }
      if (key1 != _kOctothorpe && key2 == _kOctothorpe) {
        return -1;
      }
      return key1.compareTo(key2);
    });

    _contactsMap.clear();
    _contactsMap.addEntries(entries);

    _contactKeys.clear();
    _contactKeys.addAll(List.generate(contactsMap.length, (index) => GlobalKey()));
    super.onLoaded(contacts);
  }

  _analysisFirstLetter(String name) {
    if (name == null || name.isEmpty) {
      return _kOctothorpe;
    }
    final upperCase = PinyinHelper.getShortPinyin(name)?.substring(0, 1)?.toUpperCase();
    if (upperCase == null || upperCase.isEmpty || !RegExp('[A-Z]').hasMatch(upperCase)) {
      return _kOctothorpe;
    }
    return upperCase;
  }
}
