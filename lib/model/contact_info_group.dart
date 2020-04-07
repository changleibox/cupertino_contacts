/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

abstract class ContactInfo<T> extends ValueNotifier<T> {
  final String name;

  ContactInfo({
    @required this.name,
    T value,
  })  : assert(name != null),
        super(value);

  @override
  void dispose() {
    super.dispose();
  }
}

class EditableContactInfo extends ContactInfo<String> {
  final TextEditingController controller;
  final TextInputType inputType;

  EditableContactInfo({
    @required String name,
    String value,
    this.inputType = TextInputType.text,
  })  : this.controller = TextEditingController(text: value),
        assert(inputType != null),
        super(name: name, value: value) {
    controller.addListener(() {
      var text = controller.text;
      this.value = text == null || text.isEmpty ? null : text;
    });
  }

  @override
  set value(String newValue) {
    controller.value = controller.value.copyWith(
      text: newValue,
    );
    super.value = newValue;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is EditableItem && runtimeType == other.runtimeType && controller == other.controller;

  @override
  int get hashCode => controller.hashCode;
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
  _SelectionContactInfo({
    @required String name,
  }) : super(name: name);
}

class DefaultSelectionContactInfo extends _SelectionContactInfo {
  DefaultSelectionContactInfo({
    @required String name,
  }) : super(name: name);

  @override
  void dispose() {
    super.dispose();
  }
}

class NormalSelectionContactInfo extends _SelectionContactInfo {
  NormalSelectionContactInfo({
    @required String name,
  }) : super(name: name);

  @override
  void dispose() {
    super.dispose();
  }
}

class ContactInfoGroup<T extends _Item> extends ContactInfo<List<T>> {
  final List<T> _items;
  final List<String> selections;

  ContactInfoGroup({
    @required String name,
    @required this.selections,
    List<T> items,
  })  : assert(name != null),
        assert(selections != null && selections.length > 0),
        this._items = List<T>()..addAll(items ?? []),
        super(name: name, value: List.unmodifiable(items ?? [])) {
    _items.forEach((element) => element.addListener(_itemListener));
  }

  void _itemListener() {
    value = List.unmodifiable(_items);
  }

  void add(T item) {
    item.addListener(_itemListener);
    _items.add(item);
    value = List.unmodifiable(_items);
  }

  void remove(T item) {
    item.removeListener(_itemListener);
    _items.remove(item);
    value = List.unmodifiable(_items);
  }

  void removeAt(int index) {
    _items[index].removeListener(_itemListener);
    _items.removeAt(index);
    value = List.unmodifiable(_items);
  }

  @override
  set value(List<T> newValue) {
    super.value = newValue;
  }

  @override
  void dispose() {
    _items?.forEach((element) => element.dispose());
    super.dispose();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactInfoGroup &&
          runtimeType == other.runtimeType &&
          DeepCollectionEquality.unordered().equals(_items, other._items) &&
          DeepCollectionEquality.unordered().equals(selections, other.selections);

  @override
  int get hashCode => _items.hashCode ^ selections.hashCode;
}

abstract class _Item<T> extends ValueNotifier<T> {
  final String label;

  _Item(this.label, {T value}) : super(value);

  @override
  void dispose() {
    super.dispose();
  }
}

class EditableItem extends _Item<String> {
  final TextEditingController controller;
  final TextInputType inputType;

  EditableItem({@required String label, String value, this.inputType = TextInputType.text})
      : this.controller = TextEditingController(text: value),
        assert(label != null),
        assert(inputType != null),
        super(label, value: value) {
    controller.addListener(() {
      var text = controller.text;
      this.value = text == null || text.isEmpty ? null : text;
    });
  }

  @override
  set value(String newValue) {
    controller.value = controller.value.copyWith(
      text: newValue,
    );
    super.value = newValue;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is EditableItem && runtimeType == other.runtimeType && controller == other.controller;

  @override
  int get hashCode => controller.hashCode;
}

class SelectionItem extends _Item {
  SelectionItem({@required String label, dynamic value})
      : assert(label != null),
        super(label, value: value);

  @override
  void dispose() {
    super.dispose();
  }
}
