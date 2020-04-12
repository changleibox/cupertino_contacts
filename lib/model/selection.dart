/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';
import 'dart:io';

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

abstract class _Selections {
  static final Map<String, Selection> _selectionsMap = HashMap();

  final iPhoneSelection = Selection._('iPhone');

  static _Selections get instance {
    switch (Platform.operatingSystem) {
      case 'android':
        return _AndroidSelections.instance;
      case 'ios':
        return _IOSSelections.instance;
    }
    return _UnsupportedSelections.instance;
  }

  _Selections() {
    phoneSelections?.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    emailSelections?.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    urlSelections?.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    addressSelections?.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    birthdaySelections?.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    dateSelections?.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    relatedPartySelections?.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    socialDataSelections?.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
    instantMessagingSelections?.forEach((element) {
      _selectionsMap[element.propertyName] = element;
    });
  }

  List<Selection> get phoneSelections;

  List<Selection> get emailSelections;

  List<Selection> get urlSelections;

  List<Selection> get addressSelections;

  List<Selection> get birthdaySelections;

  List<Selection> get dateSelections;

  List<Selection> get relatedPartySelections;

  List<Selection> get socialDataSelections;

  List<Selection> get instantMessagingSelections;

  Selection get streetSelection;

  Selection get citySelection;

  Selection get postcodeSelection;

  Selection get regionSelection;

  Selection get countrySelection;

  Selection get birthdaySelection;

  Selection get otherSelection;

  Selection buildSelection(String name) => Selection._(name);

  bool contains(String propertyName) {
    return [propertyName] != null;
  }

  Selection operator [](String propertyName) {
    assert(propertyName != null);
    return _selectionsMap[propertyName] ?? otherSelection;
  }
}

class _UnsupportedSelections extends _Selections {
  static _UnsupportedSelections get instance => _getInstance();

  static _UnsupportedSelections _instance;

  static _UnsupportedSelections _getInstance() {
    if (_instance == null) {
      _instance = _UnsupportedSelections._();
    }
    return _instance;
  }

  factory _UnsupportedSelections() => _getInstance();

  _UnsupportedSelections._() : super();

  @override
  List<Selection> get phoneSelections => [otherSelection];

  @override
  List<Selection> get emailSelections => [otherSelection];

  @override
  List<Selection> get urlSelections => [otherSelection];

  @override
  List<Selection> get addressSelections => [otherSelection];

  @override
  List<Selection> get birthdaySelections => [otherSelection];

  @override
  List<Selection> get dateSelections => [otherSelection];

  @override
  List<Selection> get relatedPartySelections => [otherSelection];

  @override
  List<Selection> get socialDataSelections => [otherSelection];

  @override
  List<Selection> get instantMessagingSelections => [otherSelection];

  @override
  Selection get streetSelection => otherSelection;

  @override
  Selection get citySelection => otherSelection;

  @override
  Selection get postcodeSelection => otherSelection;

  @override
  Selection get regionSelection => otherSelection;

  @override
  Selection get countrySelection => otherSelection;

  @override
  Selection get birthdaySelection => otherSelection;

  @override
  Selection get otherSelection => Selection._('不支持');
}

class _IOSSelections extends _Selections {
  static const _birthdaySelection = Selection._('birthday', labelName: '生日', selectionName: '默认生日');

  static const _homeSelection = Selection._('住宅');

  static const _workSelection = Selection._('工作');

  static const _schoolSelection = Selection._('学校');

  static const _otherSelection = Selection._('其他');

  static const _streetSelection = Selection._('街道');

  static const _citySelection = Selection._('城市');

  static const _postcodeSelection = Selection._('邮编');

  static const _regionSelection = Selection._('州/省');

  static const _countrySelection = Selection._('国家');

  static const _phoneSelections = [
    _homeSelection,
    _workSelection,
    _schoolSelection,
    Selection._('iPhone'),
    Selection._('手机'),
    Selection._('主要'),
    Selection._('家庭传真'),
    Selection._('工作传真'),
    Selection._('传呼机'),
    _otherSelection,
  ];
  static const _emailSelections = [
    _homeSelection,
    _workSelection,
    _schoolSelection,
    Selection._('iCloud'),
    _otherSelection,
  ];
  static const _urlSelections = [
    Selection._('主页'),
    _homeSelection,
    _workSelection,
    _schoolSelection,
    _otherSelection,
  ];
  static const _addressSelections = [
    _homeSelection,
    _workSelection,
    _schoolSelection,
    _otherSelection,
  ];
  static const _birthdaySelections = [
    _birthdaySelection,
    Selection._('农历生日'),
    Selection._('希伯来历'),
    Selection._('伊斯兰厉'),
  ];
  static const _dateSelections = [
    Selection._('纪念日'),
    _otherSelection,
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
    _otherSelection,
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

  static _IOSSelections get instance => _getInstance();

  static _IOSSelections _instance;

  static _IOSSelections _getInstance() {
    if (_instance == null) {
      _instance = _IOSSelections._();
    }
    return _instance;
  }

  factory _IOSSelections() => _getInstance();

  _IOSSelections._() : super();

  @override
  List<Selection> get phoneSelections => _phoneSelections;

  @override
  List<Selection> get emailSelections => _emailSelections;

  @override
  List<Selection> get urlSelections => _urlSelections;

  @override
  List<Selection> get addressSelections => _addressSelections;

  @override
  List<Selection> get birthdaySelections => _birthdaySelections;

  @override
  List<Selection> get dateSelections => _dateSelections;

  @override
  List<Selection> get relatedPartySelections => _relatedPartySelections;

  @override
  List<Selection> get socialDataSelections => _socialDataSelections;

  @override
  List<Selection> get instantMessagingSelections => _instantMessagingSelections;

  @override
  Selection get streetSelection => _streetSelection;

  @override
  Selection get citySelection => _citySelection;

  @override
  Selection get postcodeSelection => _postcodeSelection;

  @override
  Selection get regionSelection => _regionSelection;

  @override
  Selection get countrySelection => _countrySelection;

  @override
  Selection get birthdaySelection => _birthdaySelection;

  @override
  Selection get otherSelection => _otherSelection;
}

class _AndroidSelections extends _Selections {
  static const _birthdaySelection = Selection._('birthday', labelName: '生日', selectionName: '默认生日');

  static const _homeSelection = Selection._('home', labelName: '住宅');

  static const _workSelection = Selection._('work', labelName: '工作');

  static const _schoolSelection = Selection._('school', labelName: '学校');

  static const _otherSelection = Selection._('other', labelName: '其他');

  static const _streetSelection = Selection._('街道');

  static const _citySelection = Selection._('城市');

  static const _postcodeSelection = Selection._('邮编');

  static const _regionSelection = Selection._('州/省');

  static const _countrySelection = Selection._('国家');

  static const _phoneSelections = [
    _homeSelection,
    _workSelection,
    _schoolSelection,
    Selection._('mobile', labelName: '手机'),
    Selection._('main', labelName: '主要'),
    Selection._('home work', labelName: '家庭传真'),
    Selection._('fax work', labelName: '工作传真'),
    Selection._('pager', labelName: '传呼机'),
    Selection._('company', labelName: '公司总机'),
    _otherSelection,
  ];
  static const _emailSelections = [
    _homeSelection,
    _workSelection,
    _schoolSelection,
    Selection._('iCloud'),
    _otherSelection,
  ];
  static const _urlSelections = [
    Selection._('主页'),
    _homeSelection,
    _workSelection,
    _schoolSelection,
    _otherSelection,
  ];
  static const _addressSelections = [
    _homeSelection,
    _workSelection,
    _schoolSelection,
    _otherSelection,
  ];
  static const _birthdaySelections = [
    _birthdaySelection,
    Selection._('农历生日'),
    Selection._('希伯来历'),
    Selection._('伊斯兰厉'),
  ];
  static const _dateSelections = [
    Selection._('纪念日'),
    _otherSelection,
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
    _otherSelection,
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

  static _AndroidSelections get instance => _getInstance();

  static _AndroidSelections _instance;

  static _AndroidSelections _getInstance() {
    if (_instance == null) {
      _instance = _AndroidSelections._();
    }
    return _instance;
  }

  factory _AndroidSelections() => _getInstance();

  _AndroidSelections._() : super();

  @override
  List<Selection> get phoneSelections => _phoneSelections;

  @override
  List<Selection> get emailSelections => _emailSelections;

  @override
  List<Selection> get urlSelections => _urlSelections;

  @override
  List<Selection> get addressSelections => _addressSelections;

  @override
  List<Selection> get birthdaySelections => _birthdaySelections;

  @override
  List<Selection> get dateSelections => _dateSelections;

  @override
  List<Selection> get relatedPartySelections => _relatedPartySelections;

  @override
  List<Selection> get socialDataSelections => _socialDataSelections;

  @override
  List<Selection> get instantMessagingSelections => _instantMessagingSelections;

  @override
  Selection get streetSelection => _streetSelection;

  @override
  Selection get citySelection => _citySelection;

  @override
  Selection get postcodeSelection => _postcodeSelection;

  @override
  Selection get regionSelection => _regionSelection;

  @override
  Selection get countrySelection => _countrySelection;

  @override
  Selection get birthdaySelection => _birthdaySelection;

  @override
  Selection get otherSelection => _otherSelection;
}
