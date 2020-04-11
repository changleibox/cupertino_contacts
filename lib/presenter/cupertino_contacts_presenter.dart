/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:async';
import 'dart:collection';

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/page/contact_detail_page.dart';
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
  StreamSubscription<dynamic> _subscription;

  int get keyCount => _contactKeys.length;

  List<GlobalKey> get contactKeys => _contactKeys;

  List<String> get indexs => _contactsMap.keys.toList();

  Iterable<MapEntry<String, List<Contact>>> get entries => _contactsMap.entries;

  bool get isSelectionMode => widget.launchMode != HomeLaunchMode.normal;

  @override
  void initState() {
    super.initState();
    _subscription = Contacts.contactEvents.listen((event) => refresh());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Future<List<Contact>> onLoad(bool showProgress) async {
    var total = await Contacts.getTotalContacts(query: queryText);
    var listContacts = Contacts.listContacts(
      query: queryText,
      bufferSize: total,
      sortBy: ContactSortOrder.firstName(),
    );
    var contacts = await listContacts.jumpToPage(0);
    return _handleContactGroup(contacts);
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

  onItemPressed(Contact contact) {
    if (widget.launchMode == HomeLaunchMode.onlySelection) {
      Navigator.pop(context, contact);
    } else {
      Navigator.push(
        context,
        RouteProvider.buildRoute(
          ContactDetailPage(
            identifier: contact.identifier,
            contact: contact,
            launchMode: widget.launchMode == HomeLaunchMode.normal ? DetailLaunchMode.normal : DetailLaunchMode.selection,
          ),
        ),
      ).then((value) {
        if (value != null && isSelectionMode) {
          Navigator.pop(context, value);
        }
      });
    }
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
      _selectedGroups = value == null ? null : List.of(value);
      refresh();
    });
  }

  List<Contact> _handleContactGroup(List<Contact> contacts) {
    if (_selectedGroups == null) {
      return contacts;
    }
    var ids = _selectedGroups.expand((e) => e.contacts);
    final newContacts = List<Contact>();
    contacts.forEach((element) {
      if (ids.contains(element.identifier)) {
        newContacts.add(element);
      }
    });
    return newContacts;
  }
}
