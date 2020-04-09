/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:collection/collection.dart';
import 'package:cupertinocontacts/constant/selection.dart';
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

  EditableContactInfo({
    @required String name,
    String value,
  })  : this.controller = TextEditingController(text: value),
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
  }) : super(name: name, value: value);
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

class ContactInfoGroup<T extends GroupItem> extends ContactInfo<List<T>> {
  final List<T> _items;
  final List<Selection> selections;

  ContactInfoGroup({
    @required String name,
    @required this.selections,
    List<T> items,
  })  : assert(name != null),
        assert(selections != null && selections.length > 0),
        this._items = [...?items],
        super(name: name, value: List.unmodifiable([...?items])) {
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

abstract class GroupItem<T> extends ValueNotifier<T> {
  final Selection label;

  GroupItem(this.label, {T value}) : super(value);

  bool get isEmpty => value == null;

  bool get isNotEmpty => value != null;

  @override
  void dispose() {
    super.dispose();
  }
}

class EditableItem extends GroupItem<String> {
  final TextEditingController controller;

  EditableItem({@required Selection label, String value})
      : this.controller = TextEditingController(text: value),
        assert(label != null),
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
  final TextEditingController controller;

  EditableSelectionItem({@required Selection label, String value})
      : this.controller = TextEditingController(text: value),
        assert(label != null),
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
  SelectionItem({@required Selection label, dynamic value})
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
  final EditableItem _street1;
  final EditableItem _street2;
  final EditableItem _city;
  final EditableItem _postcode;
  final EditableItem _region;
  final SelectionItem _country;

  Address({
    String street1,
    String street2,
    String city,
    String postcode,
    String region,
    String country,
  })  : _street1 = EditableItem(label: Selection('街道'), value: street1),
        _street2 = EditableItem(label: Selection('街道'), value: street2),
        _city = EditableItem(label: Selection('城市'), value: city),
        _postcode = EditableItem(label: Selection('邮编'), value: postcode),
        _region = EditableItem(label: Selection('州/省'), value: region),
        _country = SelectionItem(label: Selection('国家'), value: country);

  EditableItem get street1 => _street1;

  EditableItem get street2 => _street2;

  EditableItem get city => _city;

  EditableItem get postcode => _postcode;

  EditableItem get region => _region;

  SelectionItem get country => _country;

  bool get isEmpty => _street1.isEmpty && _street2.isEmpty && _city.isEmpty && _postcode.isEmpty && _region.isEmpty && _country.isEmpty;

  bool get isNotEmpty => _street1.isNotEmpty || _street2.isNotEmpty || _city.isNotEmpty || _postcode.isNotEmpty || _region.isNotEmpty || _country.isNotEmpty;
}
