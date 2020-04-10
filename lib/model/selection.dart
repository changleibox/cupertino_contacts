/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';

class Selection {
  final String propertyName;
  final String labelName;
  final String selectionName;

  const Selection._(
    this.propertyName, {
    String labelName,
    String selectionName,
  })  : assert(propertyName != null),
        this.labelName = labelName ?? selectionName ?? propertyName,
        this.selectionName = selectionName ?? labelName ?? propertyName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Selection &&
          runtimeType == other.runtimeType &&
          propertyName == other.propertyName &&
          labelName == other.labelName &&
          selectionName == other.selectionName;

  @override
  int get hashCode => propertyName.hashCode ^ labelName.hashCode ^ selectionName.hashCode;
}

final _Selections selections = _Selections.instance;

class _Selections {
  static const _birthdaySelection = Selection._('birthday', labelName: '生日', selectionName: '默认生日');

  static const _phoneSelections = [
    Selection._('住宅'),
    Selection._('工作'),
    Selection._('学校'),
    Selection._('iPhone'),
    Selection._('手机'),
    Selection._('主要'),
    Selection._('家庭传真'),
    Selection._('工作传真'),
    Selection._('传呼机'),
    Selection._('其他'),
  ];
  static const _emailSelections = [
    Selection._('住宅'),
    Selection._('工作'),
    Selection._('学校'),
    Selection._('iCloud'),
    Selection._('其他'),
  ];
  static const _urlSelections = [
    Selection._('主页'),
    Selection._('住宅'),
    Selection._('工作'),
    Selection._('学校'),
    Selection._('其他'),
  ];
  static const _addressSelections = [
    Selection._('住宅'),
    Selection._('工作'),
    Selection._('学校'),
    Selection._('其他'),
  ];
  static const _birthdaySelections = [
    _birthdaySelection,
    Selection._('农历生日'),
    Selection._('希伯来历'),
    Selection._('伊斯兰厉'),
  ];
  static const _dateSelections = [
    Selection._('纪念日'),
    Selection._('其他'),
  ];
  static const _relatedPartySelections = [
    Selection._('父母'),
    Selection._('兄弟'),
    Selection._('姐妹'),
    Selection._('子女'),
    Selection._('配偶'),
    Selection._('助理'),
    Selection._('父亲'),
    Selection._('母亲'),
    Selection._('哥哥'),
    Selection._('姐姐'),
    Selection._('弟弟'),
    Selection._('妹妹'),
    Selection._('丈夫'),
    Selection._('妻子'),
    Selection._('伴侣'),
    Selection._('儿子'),
    Selection._('女儿'),
    Selection._('朋友'),
    Selection._('上司'),
    Selection._('同事'),
    Selection._('其他'),
    Selection._('所有标签'),
  ];
  static const _socialDataSelections = [
    Selection._('Twitter'),
    Selection._('Facebook'),
    Selection._('Flickr'),
    Selection._('领英'),
    Selection._('Myspace'),
    Selection._('新浪微博'),
  ];
  static const _instantMessagingSelections = [
    Selection._('Skype'),
    Selection._('MSN'),
    Selection._('Google Talk'),
    Selection._('AIM'),
    Selection._('雅虎'),
    Selection._('ICQ'),
    Selection._('Jabber'),
    Selection._('QQ'),
    Selection._('Gadu-Gadu'),
  ];

  static final Map<String, Selection> _selectionsMap = HashMap();

  static _Selections get instance => _getInstance();

  static _Selections _instance;

  static _Selections _getInstance() {
    if (_instance == null) {
      _instance = _Selections._();
    }
    return _instance;
  }

  _Selections._() {
    _phoneSelections.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    _emailSelections.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    _urlSelections.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    _addressSelections.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    _birthdaySelections.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    _dateSelections.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    _relatedPartySelections.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    _socialDataSelections.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    _instantMessagingSelections.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
  }

  List<Selection> get phoneSelections => _phoneSelections;

  List<Selection> get emailSelections => _emailSelections;

  List<Selection> get urlSelections => _urlSelections;

  List<Selection> get addressSelections => _addressSelections;

  List<Selection> get birthdaySelections => _birthdaySelections;

  List<Selection> get dateSelections => _dateSelections;

  List<Selection> get relatedPartySelections => _relatedPartySelections;

  List<Selection> get socialDataSelections => _socialDataSelections;

  List<Selection> get instantMessagingSelections => _instantMessagingSelections;

  Selection get streetSelection => Selection._('街道');

  Selection get citySelection => Selection._('城市');

  Selection get postcodeSelection => Selection._('邮编');

  Selection get regionSelection => Selection._('州/省');

  Selection get countrySelection => Selection._('国家');

  Selection get birthdaySelection => _birthdaySelection;

  bool contains(String propertyName) {
    return _selectionsMap.containsKey(propertyName);
  }

  Selection operator [](String propertyName) {
    assert(propertyName != null);
    return _selectionsMap[propertyName];
  }
}
