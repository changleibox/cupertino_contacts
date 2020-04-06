/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';

class ContactUtils {
  static final RegExp letterRegExp = RegExp(r'[A-Z|a-z]');

  static bool hasSpacing(Contact contact) {
    return contact.displayName != null && letterRegExp.hasMatch(contact.displayName);
  }

  static String buildDisplayName(Contact contact) {
    final names = [
      contact.prefix,
      contact.givenName,
      contact.middleName,
      contact.familyName,
      contact.suffix,
    ].where((element) => element != null && element.isNotEmpty).toList();
    final hasSpacing = names.where((element) => letterRegExp.hasMatch(element)).length > 0;
    return names.join(hasSpacing ? ' ' : '');
  }

  static List<Widget> buildDisplayNameWidgets(Contact contact) {
    final names = [
      Text(
        contact.prefix ?? '',
      ),
      Text(
        contact.givenName ?? '',
      ),
      Text(
        contact.middleName ?? '',
      ),
      Text(
        contact.familyName ?? '',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        contact.suffix,
      ),
    ].where((element) {
      return element.data != null && element.data.isNotEmpty;
    }).toList();
    return names;
  }
}
