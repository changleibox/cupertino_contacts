/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contact/contact.dart';

abstract class ContactInfo<T> extends ValueNotifier<T> {
  ContactInfo({
    @required this.name,
    T value,
  })  : assert(name != null),
        super(value);

  final String name;

  @override
  void dispose() {
    super.dispose();
  }
}

class EditableContactInfo extends ContactInfo<String> {
  EditableContactInfo({
    @required String name,
    String value,
  })  : controller = TextEditingController(text: value),
        super(name: name, value: value) {
    controller.addListener(() {
      final text = controller.text;
      this.value = text == null || text.isEmpty ? null : text;
    });
  }

  final TextEditingController controller;

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
  }) : super(name: name, value: value);
}

abstract class _SelectionContactInfo extends ContactInfo<dynamic> {
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

class ContactInfoGroup<T extends GroupItem<dynamic>> extends ContactInfo<List<T>> {
  ContactInfoGroup({
    @required String name,
    @required this.selectionType,
    List<T> items,
  })  : assert(name != null),
        assert(selectionType != null),
        _items = [...?items],
        super(name: name, value: List.unmodifiable(<T>[...?items])) {
    for (var element in _items) {
      element.addListener(_itemListener);
    }
  }

  final List<T> _items;
  final SelectionType selectionType;

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
    for (var element in _items) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ContactInfoGroup && runtimeType == other.runtimeType && _items == other._items && selectionType == other.selectionType;

  @override
  int get hashCode => _items.hashCode ^ selectionType.hashCode;
}

abstract class GroupItem<T> extends ValueNotifier<T> {
  GroupItem(this._label, {T value}) : super(value);

  Selection _label;

  Selection get label => _label;

  set label(Selection label) {
    if (label == _label) {
      return;
    }
    _label = label;
    notifyListeners();
  }

  bool get isEmpty => value == null;

  bool get isNotEmpty => value != null;

  @override
  void dispose() {
    super.dispose();
  }
}

class EditableItem extends GroupItem<String> {
  EditableItem({@required Selection label, String value})
      : controller = TextEditingController(text: value),
        assert(label != null),
        super(label, value: value) {
    controller.addListener(() {
      final text = controller.text;
      this.value = text == null || text.isEmpty ? null : text;
    });
  }

  final TextEditingController controller;

  @override
  set value(String newValue) {
    controller.value = controller.value.copyWith(
      text: newValue,
    );
    super.value = newValue;
  }

  @override
  bool get isEmpty => value == null || value.isEmpty;

  @override
  bool get isNotEmpty => value != null && value.isNotEmpty;

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

class EditableSelectionItem extends GroupItem<String> {
  EditableSelectionItem({@required Selection label, String value})
      : controller = TextEditingController(text: value),
        assert(label != null),
        super(label, value: value) {
    controller.addListener(() {
      final text = controller.text;
      this.value = text == null || text.isEmpty ? null : text;
    });
  }

  final TextEditingController controller;

  @override
  set value(String newValue) {
    controller.value = controller.value.copyWith(
      text: newValue,
    );
    super.value = newValue;
  }

  @override
  bool get isEmpty => value == null || value.isEmpty;

  @override
  bool get isNotEmpty => value != null && value.isNotEmpty;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is EditableSelectionItem && runtimeType == other.runtimeType && controller == other.controller;

  @override
  int get hashCode => controller.hashCode;
}

class DateTimeItem extends GroupItem<DateTime> {
  DateTimeItem({
    @required Selection label,
    DateTime value,
  }) : super(label, value: value ?? DateTime.now());
}

class SelectionItem extends GroupItem<String> {
  SelectionItem({@required Selection label, String value})
      : assert(label != null),
        super(label, value: value);

  @override
  bool get isEmpty => value == null || value.isEmpty;

  @override
  bool get isNotEmpty => value != null && value.isNotEmpty;

  @override
  void dispose() {
    super.dispose();
  }
}

class ContactSelectionItem extends GroupItem<Contact> {
  ContactSelectionItem({@required Selection label, Contact value})
      : assert(label != null),
        super(label, value: value);

  @override
  void dispose() {
    super.dispose();
  }
}

class AddressItem extends GroupItem<Address> {
  AddressItem({
    @required Selection label,
    @required Address value,
  })  : assert(value != null),
        super(label, value: value) {
    value._street1.addListener(_itemListener);
    value._street2.addListener(_itemListener);
    value._city.addListener(_itemListener);
    value._region.addListener(_itemListener);
    value._postcode.addListener(_itemListener);
    value._country.addListener(_itemListener);
  }

  void _itemListener() {
    notifyListeners();
  }

  @override
  set value(Address newValue) {
    value._street1.value = newValue?._street1?.value;
    value._street2.value = newValue?._street2?.value;
    value._city.value = newValue?._city?.value;
    value._region.value = newValue?._region?.value;
    value._postcode.value = newValue?._postcode?.value;
    value._country.value = newValue?._country?.value;
  }

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  void dispose() {
    value._street1.dispose();
    value._street2.dispose();
    value._city.dispose();
    value._region.dispose();
    value._postcode.dispose();
    value._country.dispose();
    super.dispose();
  }
}

class Address {
  Address({
    String street1,
    String street2,
    String city,
    String postcode,
    String region,
    String country,
  })  : _street1 = EditableItem(label: selections.streetSelection, value: street1),
        _street2 = EditableItem(label: selections.streetSelection, value: street2),
        _city = EditableItem(label: selections.citySelection, value: city),
        _postcode = EditableItem(label: selections.postcodeSelection, value: postcode),
        _region = EditableItem(label: selections.regionSelection, value: region),
        _country = SelectionItem(label: selections.countrySelection, value: country);

  final EditableItem _street1;
  final EditableItem _street2;
  final EditableItem _city;
  final EditableItem _postcode;
  final EditableItem _region;
  final SelectionItem _country;

  EditableItem get street1 => _street1;

  EditableItem get street2 => _street2;

  EditableItem get city => _city;

  EditableItem get postcode => _postcode;

  EditableItem get region => _region;

  SelectionItem get country => _country;

  bool get isEmpty => _street1.isEmpty && _street2.isEmpty && _city.isEmpty && _postcode.isEmpty && _region.isEmpty && _country.isEmpty;

  bool get isNotEmpty => _street1.isNotEmpty || _street2.isNotEmpty || _city.isNotEmpty || _postcode.isNotEmpty || _region.isNotEmpty || _country.isNotEmpty;
}
