/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/contact_group_page.dart';
import 'package:cupertinocontacts/presenter/list_presenter.dart';
import 'package:flutter_contact/contacts.dart';

class ContactGroupPresenter extends ListPresenter<ContactGroupPage, Group> {
  @override
  Future<List<Group>> onLoad(bool showProgress) async {
    final groups = List<Group>();
    groups.add(Group(name: '所有"iPhone"'));
    groups.addAll(await Contacts.getGroups());
    return groups;
  }
}
