/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/contact_group_page.dart';
import 'package:cupertinocontacts/presenter/list_presenter.dart';

class ContactGroupPresenter extends ListPresenter<ContactGroupPage, String> {
  @override
  Future<List<String>> onLoad(bool showProgress) async {
    return [
      '所有"iPhone"',
      'Friends',
      'Work',
    ];
  }
}
