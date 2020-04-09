/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';

class Selection {
  final String propertyName;
  final String labelName;
  final String selectionName;

  const Selection(
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
  static const _phoneSelections = [
    Selection('住宅'),
    Selection('工作'),
    Selection('学校'),
    Selection('iPhone'),
    Selection('手机'),
    Selection('主要'),
    Selection('家庭传真'),
    Selection('工作传真'),
    Selection('传呼机'),
    Selection('其他'),
  ];
  static const _emailSelections = [
    Selection('住宅'),
    Selection('工作'),
    Selection('学校'),
    Selection('iCloud'),
    Selection('其他'),
  ];
  static const _urlSelections = [
    Selection('主页'),
    Selection('住宅'),
    Selection('工作'),
    Selection('学校'),
    Selection('其他'),
  ];
  static const _addressSelections = [
    Selection('住宅'),
    Selection('工作'),
    Selection('学校'),
    Selection('其他'),
  ];
  static const _birthdaySelections = [
    Selection('birthday', labelName: '生日', selectionName: '默认生日'),
    Selection('农历生日'),
    Selection('希伯来历'),
    Selection('伊斯兰厉'),
  ];
  static const _dateSelections = [
    Selection('纪念日'),
    Selection('其他'),
  ];
  static const _relatedPartySelections = [
    Selection('父母'),
    Selection('兄弟'),
    Selection('姐妹'),
    Selection('子女'),
    Selection('配偶'),
    Selection('助理'),
    Selection('父亲'),
    Selection('母亲'),
    Selection('哥哥'),
    Selection('姐姐'),
    Selection('弟弟'),
    Selection('妹妹'),
    Selection('丈夫'),
    Selection('妻子'),
    Selection('伴侣'),
    Selection('儿子'),
    Selection('女儿'),
    Selection('朋友'),
    Selection('上司'),
    Selection('同事'),
    Selection('其他'),
    Selection('所有标签'),
  ];
  static const _socialDataSelections = [
    Selection('Twitter'),
    Selection('Facebook'),
    Selection('Flickr'),
    Selection('领英'),
    Selection('Myspace'),
    Selection('新浪微博'),
  ];
  static const _instantMessagingSelections = [
    Selection('Skype'),
    Selection('MSN'),
    Selection('Google Talk'),
    Selection('AIM'),
    Selection('雅虎'),
    Selection('ICQ'),
    Selection('Jabber'),
    Selection('QQ'),
    Selection('Gadu-Gadu'),
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

  factory _Selections() => _getInstance();

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

  Selection operator [](String propertyName) {
    return _selectionsMap[propertyName];
  }
}
