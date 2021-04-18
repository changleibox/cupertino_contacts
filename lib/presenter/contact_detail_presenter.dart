/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:async';

import 'package:cupertinocontacts/model/caches.dart';
import 'package:cupertinocontacts/page/contact_detail_page.dart';
import 'package:cupertinocontacts/presenter/object_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_contact/contacts.dart';

class ContactDetailPresenter extends ObjectPresenter<ContactDetailPage, Contact> {
  final remarksController = TextEditingController();

  StreamSubscription<dynamic> _subscription;

  @override
  void initState() {
    setObject(widget.contact);
    _subscription = Caches.listen((event) => onDefaultRefresh());
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Future<Contact> onLoad(bool showProgress) async {
    return Caches.getDetailContact(widget.identifier, widget.launchMode);
  }

  @override
  void onLoaded(Contact object) {
    remarksController.text = object?.note;
    super.onLoaded(object);
  }
}
