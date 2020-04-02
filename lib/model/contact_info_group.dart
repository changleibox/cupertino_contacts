/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

abstract class ContactInfo {
  final String name;

  const ContactInfo({
    @required this.name,
  }) : assert(name != null);

  void dispose();
}

class EditableContactInfo extends ContactInfo {
  final TextEditingController controller;

  EditableContactInfo({
    @required String name,
    String value,
  })  : this.controller = TextEditingController(text: value),
        super(name: name);

  String get value {
    var text = controller.text;
    return text == null || text.isEmpty ? null : text;
  }

  @override
  void dispose() {
    controller.dispose();
  }
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

abstract class _SelectionContactInfo extends ContactInfo {
  const _SelectionContactInfo({
    @required String name,
  }) : super(name: name);
}

class DefaultSelectionContactInfo extends _SelectionContactInfo {
  const DefaultSelectionContactInfo({
    @required String name,
  }) : super(name: name);

  @override
  void dispose() {}
}

class NormalSelectionContactInfo extends _SelectionContactInfo {
  const NormalSelectionContactInfo({
    @required String name,
  }) : super(name: name);

  @override
  void dispose() {}
}

class ContactInfoGroup<T extends _Item> extends ContactInfo {
  final List<T> items;
  final List<String> selections;

  const ContactInfoGroup({
    @required String name,
    @required this.items,
    @required this.selections,
  })  : assert(name != null),
        assert(items != null),
        assert(selections != null && selections.length > 0),
        super(name: name);

  @override
  void dispose() {
    items?.forEach((element) => element.dispose());
  }
}

abstract class _Item {
  final String label;

  const _Item(this.label);

  void dispose();
}

class EditableItem extends _Item {
  final TextEditingController controller;

  EditableItem({@required String label, String value})
      : this.controller = TextEditingController(text: value),
        assert(label != null),
        super(label);

  String get value {
    var text = controller.text;
    return text == null || text.isEmpty ? null : text;
  }

  @override
  void dispose() {
    controller.dispose();
  }
}

class SelectionItem extends _Item {
  const SelectionItem({@required String label})
      : assert(label != null),
        super(label);

  @override
  void dispose() {}
}
