/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';

class ContactUtils {
  const ContactUtils._();

  static final RegExp letterRegExp = RegExp(r'[A-Z|a-z]');

  static bool hasSpacing(Contact contact) {
    return contact.displayName != null && letterRegExp.hasMatch(contact.displayName);
  }

  static List<Widget> buildDisplayNameWidgets(Contact contact) {
    final hasSpacing = ContactUtils.hasSpacing(contact);
    final names = [
      Text(
        contact.prefix ?? '',
      ),
      if (hasSpacing)
        Text(
          contact.givenName ?? '',
        )
      else
        Text(
          contact.familyName ?? '',
        ),
      Text(
        contact.middleName ?? '',
      ),
      if (hasSpacing)
        Text(
          contact.familyName ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        )
      else
        Text(
          contact.givenName ?? '',
        ),
      Text(
        contact.suffix ?? '',
      ),
    ].where((element) {
      return element.data != null && element.data.isNotEmpty;
    }).toList();
    return names;
  }
}
