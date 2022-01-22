/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:async';

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/model/caches.dart';
import 'package:cupertinocontacts/page/contact_detail_page.dart';
import 'package:cupertinocontacts/page/contact_group_page.dart';
import 'package:cupertinocontacts/page/home_page.dart';
import 'package:cupertinocontacts/presenter/list_presenter.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:lpinyin/lpinyin.dart';

const String _kOctothorpe = '#';

class HomePresenter extends ListPresenter<HomePage, Contact> {
  final _contactsMap = <String, List<Contact>>{};
  final _contactKeys = <GlobalKey>[];

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
    _subscription = Caches.listen((event) => refresh());
  }

  @override
  void dispose() {
    _subscription?.cancel();
    Caches.dispose();
    super.dispose();
  }

  @override
  Future<List<Contact>> onLoad(bool showProgress) async {
    final contacts = await Caches.getContacts(queryText);
    return _handleContactGroup(contacts);
  }

  @override
  void onLoaded(Iterable<Contact> object) {
    final contactsMap = <String, List<Contact>>{};
    for (var contact in object) {
      final firstLetter = _analysisFirstLetter(contact.familyName ?? contact.displayName);
      final contacts = contactsMap[firstLetter] ?? <Contact>[];
      contacts.add(contact);
      contactsMap[firstLetter] = contacts;
    }
    final entries = List.of(contactsMap.entries);
    entries.sort((a, b) {
      final key1 = a.key;
      final key2 = b.key;
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
    super.onLoaded(object);
  }

  String _analysisFirstLetter(String name) {
    if (name == null || name.isEmpty) {
      return _kOctothorpe;
    }
    final upperCase = PinyinHelper.getShortPinyin(name)?.substring(0, 1)?.toUpperCase();
    if (upperCase == null || upperCase.isEmpty || !RegExp('[A-Z]').hasMatch(upperCase)) {
      return _kOctothorpe;
    }
    return upperCase;
  }

  void onItemPressed(Contact contact) {
    if (widget.launchMode == HomeLaunchMode.onlySelection) {
      Navigator.pop(context, contact);
    } else {
      Navigator.push<Contact>(
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

  void onGroupPressed() {
    Navigator.push<List<Group>>(
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
    final ids = _selectedGroups.expand((e) => e.contacts);
    return contacts.where((element) => ids.contains(element.identifier)).toList();
  }
}
