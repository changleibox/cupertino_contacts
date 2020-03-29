/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/widget/contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/drag_dismiss_keyboard_container.dart';
import 'package:cupertinocontacts/widget/fast_index_container.dart';
import 'package:cupertinocontacts/widget/search_bar_header_delegate.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:lpinyin/lpinyin.dart';

/// Created by box on 2020/3/29.
///
/// iOS风格联系人页面
const double _kSearchBarHeight = 56.0;
const double _kNavBarPersistentHeight = 44.0;

class CupertinoContactsPage extends StatefulWidget {
  const CupertinoContactsPage({Key key}) : super(key: key);

  @override
  _CupertinoContactsPageState createState() => _CupertinoContactsPageState();
}

class _CupertinoContactsPageState extends State<CupertinoContactsPage> {
  bool _isLoading = false;

  final _contactsMap = LinkedHashMap<String, List<Contact>>();
  final _contactKeys = List<GlobalKey>();

  @override
  void initState() {
    _requestContacts();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _requestContacts() async {
    _isLoading = true;
    await ContactsService.getContacts(query: null, orderByGivenName: true).then((contacts) {
      final contactsMap = LinkedHashMap<String, List<Contact>>();
      for (var contact in contacts) {
        var firstLetter = _analysisFirstLetter(contact.familyName ?? contact.displayName);
        var contacts = contactsMap[firstLetter];
        if (contacts == null) {
          contacts = List<Contact>();
        }
        contacts.add(contact);
        contactsMap[firstLetter] = contacts;
      }
      var entries = contactsMap.entries.toList();
      entries.sort((a, b) => a.key.compareTo(b.key));
      contactsMap.entries.toList().sort((a, b) => a.key.compareTo(b.key));

      _contactsMap.clear();
      _contactsMap.addEntries(entries);

      _contactKeys.clear();
      _contactKeys.addAll(List.generate(contactsMap.length, (index) => GlobalKey()));
    }).whenComplete(() {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  _analysisFirstLetter(String name) {
    String firstLetter = '#';
    if (name != null && name.isNotEmpty) {
      final upperCase = PinyinHelper.getShortPinyin(name)?.substring(0, 1)?.toUpperCase();
      firstLetter = upperCase == null || upperCase.isEmpty || !RegExp('[A-Z]').hasMatch(upperCase) ? '#' : upperCase;
    }
    return firstLetter;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DragDismissKeyboardContainer(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SupportNestedScrollView(
          pinnedHeaderSliverHeightBuilder: (context) {
            return MediaQuery.of(context).padding.top + _kNavBarPersistentHeight + _kSearchBarHeight;
          },
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              CupertinoSliverNavigationBar(
                largeTitle: Text('通讯录'),
                leading: CupertinoButton(
                  child: Text('群组'),
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  onPressed: () {},
                ),
                trailing: CupertinoButton(
                  child: Text('添加'),
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  onPressed: () {},
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SearchBarHeaderDelegate(
                  height: _kSearchBarHeight,
                ),
              ),
            ];
          },
          body: _isLoading
              ? CupertinoActivityIndicator(
                  radius: 20,
                )
              : FastIndexContainer(
                  indexs: _contactsMap.keys.toList(),
                  itemKeys: _contactKeys,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: _requestContacts,
                        ),
                        for (int index = 0; index < _contactsMap.length; index++)
                          SliverPersistentHeader(
                            key: _contactKeys[index],
                            delegate: ContactPersistentHeaderDelegate(
                              contactEntry: _contactsMap.entries.elementAt(index),
                              dividerHeight: 0.5,
                              indexHeight: 26,
                              itemHeight: 85,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
