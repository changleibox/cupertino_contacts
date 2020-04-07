/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';

import 'package:cupertinocontacts/page/contact_group_page.dart';
import 'package:cupertinocontacts/page/cupertino_contacts_page.dart';
import 'package:cupertinocontacts/presenter/list_presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:lpinyin/lpinyin.dart';

const String _kOctothorpe = '#';

class CupertinoContactsPresenter extends ListPresenter<CupertinoContactsPage, Contact> {
  final _contactsMap = LinkedHashMap<String, List<Contact>>();
  final _contactKeys = List<GlobalKey>();

  List<Group> _selectedGroups;

  int get keyCount => _contactKeys.length;

  List<GlobalKey> get contactKeys => _contactKeys;

  List<String> get indexs => _contactsMap.keys.toList();

  Iterable<MapEntry<String, List<Contact>>> get entries => _contactsMap.entries;

  @override
  Future<List<Contact>> onLoad(bool showProgress) async {
    var total = await Contacts.getTotalContacts(query: queryText);
    var listContacts = Contacts.listContacts(
      query: queryText,
      bufferSize: total,
      sortBy: ContactSortOrder.firstName(),
    );
    return await listContacts.jumpToPage(0);
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

  onGroupPressed() {
    Navigator.push(
      context,
      RouteProvider.buildRoute(
        ContactGroupPage(
          selectedGroups: _selectedGroups,
        ),
        fullscreenDialog: true,
      ),
    ).then((value) {
      _selectedGroups = List.of(value);
    });
  }
}
