/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

abstract class ContactInfo {
  final String name;

  const ContactInfo({
    @required this.name,
  }) : assert(name != null);
}

class EditableContactInfo extends ContactInfo {
  final TextEditingController controller;

  EditableContactInfo({
    @required String name,
    String value,
  })  : this.controller = TextEditingController(text: value),
        super(name: name);
}

class MultiEditableContactInfo extends EditableContactInfo {
  MultiEditableContactInfo({
    @required String name,
    String value,
  }) : super(
          name: name,
          value: value,
        );
}

class _SelectionContactInfo extends ContactInfo {
  const _SelectionContactInfo({
    @required String name,
  }) : super(name: name);
}

class DefaultSelectionContactInfo extends _SelectionContactInfo {
  const DefaultSelectionContactInfo({
    @required String name,
  }) : super(name: name);
}

class NormalSelectionContactInfo extends _SelectionContactInfo {
  const NormalSelectionContactInfo({
    @required String name,
  }) : super(name: name);
}

class ContactInfoGroup extends ContactInfo {
  final List<_Item> items;

  const ContactInfoGroup({
    @required String name,
    this.items,
  })  : assert(name != null),
        super(name: name);
}

abstract class _Item {
  final String label;

  const _Item(this.label);
}

class EditableItem extends _Item {
  final TextEditingController controller;

  EditableItem({String label, String value})
      : this.controller = TextEditingController(text: value),
        super(label);
}

class SelectionItem extends _Item {
  const SelectionItem(String label) : super(label);
}
