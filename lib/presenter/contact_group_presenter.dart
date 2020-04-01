/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/contact_group_page.dart';
import 'package:cupertinocontacts/presenter/presenter.dart';

class ContactGroupPresenter extends Presenter<ContactGroupPage> {
  final _items = List<String>();

  List<String> get items => List.unmodifiable(_items);

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future<void> onRefresh() async {
    _items.clear();
    _items.addAll([
      '所有"iPhone"',
      'Friends',
      'Work',
    ]);
    notifyDataSetChanged();
  }
}
