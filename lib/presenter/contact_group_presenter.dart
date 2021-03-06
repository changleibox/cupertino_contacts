/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/caches.dart';
import 'package:cupertinocontacts/page/contact_group_page.dart';
import 'package:cupertinocontacts/presenter/list_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contacts.dart';

class ContactGroupPresenter extends ListPresenter<ContactGroupPage, Group> {
  final _allIPhoneGroup = Group(name: '所有"iPhone"');
  final _selectedGroups = <Group>[];

  @override
  Future<List<Group>> onLoad(bool showProgress) async {
    final groups = <Group>[];
    groups.add(_allIPhoneGroup);
    groups.addAll(await Caches.getGroups());
    return groups;
  }

  @override
  void onLoaded(Iterable<Group> object) {
    super.onLoaded(object);
    _selectedGroups.clear();
    final selectedGroups = widget.selectedGroups;
    if (selectedGroups == null) {
      _selectedGroups.addAll(object);
    } else {
      final map = Map.fromEntries(object.map((e) => MapEntry(e.identifier, e)));
      _selectedGroups.addAll(selectedGroups.where((element) => map.containsKey(element.identifier)).map((e) => map[e.identifier]));
    }
  }

  void switchSelect(Group group) {
    if (_selectedGroups.contains(group)) {
      if (group == _allIPhoneGroup) {
        _selectedGroups.clear();
      } else {
        _selectedGroups.remove(_allIPhoneGroup);
        _selectedGroups.remove(group);
      }
    } else {
      if (group == _allIPhoneGroup) {
        _selectedGroups.clear();
        _selectedGroups.addAll(objects);
      } else {
        _selectedGroups.add(group);
      }
    }
    notifyDataSetChanged();
  }

  bool isSelected(Group group) {
    return _selectedGroups.contains(group);
  }

  void onDonePressed() {
    Navigator.pop(context, _selectedGroups.contains(_allIPhoneGroup) ? null : _selectedGroups);
  }
}
