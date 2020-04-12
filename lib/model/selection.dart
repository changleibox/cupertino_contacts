/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:collection';
import 'dart:io';

enum SelectionType {
  phone,
  email,
  url,
  address,
  birthday,
  date,
  relatedParty,
  socialData,
  instantMessaging,
  linkContact,
}

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

class _SelectionGroup {
  final Map<String, Selection> _systemSelectionsMap = LinkedHashMap();
  final Map<String, Selection> _customSelectionsMap = LinkedHashMap();

  _SelectionGroup.fromList(List<Selection> selections) {
    selections?.forEach((element) {
      _systemSelectionsMap[element.propertyName] = element;
    });
  }

  List<Selection> get systemSelections => _systemSelectionsMap.values.toList();

  List<Selection> get customSelections => _customSelectionsMap.values.toList();

  Selection addCustomSelection(String propertyName) {
    assert(propertyName != null && propertyName.isNotEmpty);
    if (_customSelectionsMap.containsKey(propertyName)) {
      return _customSelectionsMap[propertyName];
    }
    var selection = Selection._(propertyName);
    _customSelectionsMap[propertyName] = selection;
    return selection;
  }

  Selection operator [](String propertyName) {
    return _systemSelectionsMap[propertyName] ?? _customSelectionsMap[propertyName];
  }
}

abstract class _Selections {
  final Map<SelectionType, _SelectionGroup> _selectionsMap = HashMap();

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
    _selectionsMap[SelectionType.phone] = _SelectionGroup.fromList(phoneSelections);
    _selectionsMap[SelectionType.email] = _SelectionGroup.fromList(emailSelections);
    _selectionsMap[SelectionType.url] = _SelectionGroup.fromList(urlSelections);
    _selectionsMap[SelectionType.address] = _SelectionGroup.fromList(addressSelections);
    _selectionsMap[SelectionType.birthday] = _SelectionGroup.fromList(birthdaySelections);
    _selectionsMap[SelectionType.date] = _SelectionGroup.fromList(dateSelections);
    _selectionsMap[SelectionType.relatedParty] = _SelectionGroup.fromList(relatedPartySelections);
    _selectionsMap[SelectionType.socialData] = _SelectionGroup.fromList(socialDataSelections);
    _selectionsMap[SelectionType.instantMessaging] = _SelectionGroup.fromList(instantMessagingSelections);
    _selectionsMap[SelectionType.linkContact] = _SelectionGroup.fromList(linkContactSelections);
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

  List<Selection> get linkContactSelections => [iPhoneSelection];

  Selection get streetSelection;

  Selection get citySelection;

  Selection get postcodeSelection;

  Selection get regionSelection;

  Selection get countrySelection;

  Selection get birthdaySelection;

  Selection get otherSelection;

  Selection addCustomSelection(SelectionType type, String propertyName) {
    assert(type != null);
    assert(propertyName != null);
    var selectionGroup = _selectionsMap[type];
    assert(selectionGroup != null, 'undefine type=$type');
    return selectionGroup.addCustomSelection(propertyName);
  }

  bool contains(SelectionType type, String propertyName) {
    assert(type != null);
    assert(propertyName != null);
    return _selectionsMap[type][propertyName] != null;
  }

  Selection selectionAtName(SelectionType type, String propertyName) {
    assert(type != null);
    assert(propertyName != null);
    var selectionGroup = _selectionsMap[type];
    assert(selectionGroup != null, 'undefine type=$type');
    return selectionGroup[propertyName] ?? selectionGroup.addCustomSelection(propertyName);
  }

  Selection systemSelectionAtIndex(SelectionType type, int index) {
    assert(type != null);
    assert(index != null && index >= 0);
    var list = systemSelectionsAt(type);
    return list[index % list.length];
  }

  List<Selection> systemSelectionsAt(SelectionType type) {
    assert(type != null);
    var selectionGroup = _selectionsMap[type];
    assert(selectionGroup != null, 'undefine type=$type');
    return selectionGroup.systemSelections;
  }

  List<Selection> customSelectionsAt(SelectionType type) {
    assert(type != null);
    var selectionGroup = _selectionsMap[type];
    assert(selectionGroup != null, 'undefine type=$type');
    return selectionGroup.customSelections;
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
    Selection._('配偶'),
    Selection._('大哥'),
    Selection._('大姐'),
    Selection._('小弟'),
    Selection._('小妹'),
    Selection._('爷爷'),
    Selection._('奶奶'),
    Selection._('外公/姥爷'),
    Selection._('外婆/姥姥'),
    Selection._('伯父'),
    Selection._('伯母'),
    Selection._('叔叔'),
    Selection._('婶婶'),
    Selection._('姑姑（父亲的姐妹）'),
    Selection._('姑父（父亲姐姐/妹妹的丈夫）'),
    Selection._('舅舅'),
    Selection._('舅妈'),
    Selection._('姨妈'),
    Selection._('姨夫（母亲姐姐/妹妹的丈夫）'),
    Selection._('堂哥'),
    Selection._('堂姐'),
    Selection._('堂妹'),
    Selection._('堂弟（伯伯的儿子）'),
    Selection._('表哥'),
    Selection._('表姐'),
    Selection._('堂弟/表弟'),
    Selection._('堂妹/表妹'),
    Selection._('子女'),
    Selection._('侄子（兄弟的儿子或丈夫兄弟的儿子）'),
    Selection._('侄女（兄/弟的女儿或丈夫兄/弟/姐/妹的女儿）'),
    Selection._('外甥'),
    Selection._('外甥女（姐妹的女儿或妻子兄/弟/姐/妹的女儿）'),
    Selection._('（外）孙子'),
    Selection._('（外）孙女'),
    Selection._('继父'),
    Selection._('继母'),
    Selection._('继子'),
    Selection._('继女'),
    Selection._('亲家公'),
    Selection._('亲家母'),
    Selection._('公公'),
    Selection._('婆婆'),
    Selection._('岳父'),
    Selection._('岳母'),
    Selection._('姐夫'),
    Selection._('妹夫'),
    Selection._('哥哥的妻子'),
    Selection._('弟媳'),
    Selection._('女婿'),
    Selection._('儿媳'),
    Selection._('男朋友'),
    Selection._('女朋友'),
    Selection._('伴侣（男性）'),
    Selection._('伴侣（女性）'),
    Selection._('朋友（男性）'),
    Selection._('朋友（女性）'),
    Selection._('老师'),
    Selection._('助理'),
    Selection._('上司'),
    Selection._('同事'),
    Selection._('兄弟姐妹'),
    Selection._('弟弟/妹妹'),
    Selection._('哥哥/姐姐'),
    Selection._('姐妹'),
    Selection._('妹妹'),
    Selection._('姐姐'),
    Selection._('兄弟'),
    Selection._('弟弟'),
    Selection._('哥哥'),
    Selection._('朋友'),
    Selection._('妻子'),
    Selection._('丈夫'),
    Selection._('伴侣'),
    Selection._('女朋友或男朋友'),
    Selection._('父母'),
    Selection._('母亲'),
    Selection._('父亲'),
    Selection._('女儿'),
    Selection._('儿子'),
    Selection._('（外）祖父母'),
    Selection._('（外）祖母'),
    Selection._('（外）祖父'),
    Selection._('（外）曾祖父/母'),
    Selection._('（外）曾祖父'),
    Selection._('（外）曾祖母'),
    Selection._('孙辈子女'),
    Selection._('外孙女'),
    Selection._('孙女'),
    Selection._('外孙'),
    Selection._('孙子'),
    Selection._('曾孙子/女'),
    Selection._('（外）曾孙子'),
    Selection._('（外）曾孙女'),
    Selection._('公公/婆婆/岳父/岳母'),
    Selection._('婆婆/岳母'),
    Selection._('公公/岳父'),
    Selection._('亲家公/母'),
    Selection._('兄弟姐妹的配偶'),
    Selection._('兄弟姐妹的配偶的弟/妹'),
    Selection._('兄弟姐妹的配偶的哥/姐'),
    Selection._('大姑/小姑/大姨子/小姨子'),
    Selection._('小姨子/小姑子'),
    Selection._('大姑'),
    Selection._('大姑/小姑/大姨子/小姨子（配偶的姐妹）'),
    Selection._('大/小姨子'),
    Selection._('大/小姑'),
    Selection._('嫂子/弟媳'),
    Selection._('夫或妻的兄弟'),
    Selection._('小舅子/小叔子'),
    Selection._('夫或妻的哥哥'),
    Selection._('配偶的兄/弟'),
    Selection._('大伯/小叔'),
    Selection._('大/小舅子'),
    Selection._('姐/妹的丈夫'),
    Selection._('妻子兄/弟的妻子'),
    Selection._('大嫂/弟媳'),
    Selection._('姨丈'),
    Selection._('丈夫的姐/妹的丈夫'),
    Selection._('配偶兄弟姐妹的兄弟姐妹/配偶'),
    Selection._('配偶兄弟姐妹的姐妹/妻子'),
    Selection._('配偶兄弟姐妹的兄弟/丈夫'),
    Selection._('子女的配偶'),
    Selection._('兄/弟/姐/妹（堂表亲）'),
    Selection._('堂/表弟妹'),
    Selection._('堂/表哥'),
    Selection._('兄/弟（堂表亲）'),
    Selection._('姐/妹（堂表亲）'),
    Selection._('堂表兄/弟/姐/妹'),
    Selection._('堂表兄弟'),
    Selection._('堂/表弟'),
    Selection._('表哥/堂哥'),
    Selection._('堂表姐妹'),
    Selection._('堂/表妹'),
    Selection._('表姐/堂姐'),
    Selection._('表姐妹'),
    Selection._('表妹'),
    Selection._('表姐（姨妈的女儿）'),
    Selection._('表兄弟'),
    Selection._('表弟'),
    Selection._('表哥（姨妈的儿子'),
    Selection._('表姐/妹'),
    Selection._('表妹（舅舅的女儿）'),
    Selection._('表姐（舅舅的女儿）'),
    Selection._('舅舅的儿子'),
    Selection._('表弟（舅舅弟儿子）'),
    Selection._('表哥（舅舅的儿子）'),
    Selection._('表姐妹（姑姑的女儿）'),
    Selection._('表妹（姑姑的女儿）'),
    Selection._('表姐（姑姑的女儿）'),
    Selection._('堂兄弟'),
    Selection._('表弟（姑姑的儿子）'),
    Selection._('表哥（姑姑的儿子）'),
    Selection._('堂姐/妹'),
    Selection._('伯伯的儿子'),
    Selection._('表伯叔/表姑母/表堂姨'),
    Selection._('表姑母/表堂姨'),
    Selection._('表伯叔'),
    Selection._('父母的兄/弟/姐/妹'),
    Selection._('姑姨叔舅'),
    Selection._('父母的哥哥/姐姐'),
    Selection._('舅/姨'),
    Selection._('小舅/小姨'),
    Selection._('舅舅/姨'),
    Selection._('姑/伯/叔'),
    Selection._('叔叔/姑姑'),
    Selection._('姑/伯'),
    Selection._('姑姨婶母'),
    Selection._('父母的姐妹'),
    Selection._('父母的妹妹'),
    Selection._('父母的姐姐'),
    Selection._('姑姑（父亲的妹妹）'),
    Selection._('姑姑（父亲的姐姐）'),
    Selection._('伯母/婶婶'),
    Selection._('姨妈（妈妈的妹妹）'),
    Selection._('姨妈（妈妈的姐姐）'),
    Selection._('叔/伯祖母'),
    Selection._('伯父/叔叔/舅舅/姑父/姨丈'),
    Selection._('伯/叔父/舅舅'),
    Selection._('叔叔/舅舅'),
    Selection._('伯父/舅舅'),
    Selection._('舅舅（妈妈的弟弟）'),
    Selection._('舅舅（妈妈的哥哥）'),
    Selection._('伯/叔父'),
    Selection._('姑丈'),
    Selection._('姑父（父亲姐姐的丈夫）'),
    Selection._('舅公/叔公'),
    Selection._('兄/弟/姐/妹的子女'),
    Selection._('侄女/外甥女'),
    Selection._('外甥女（姐姐/妹妹的女儿）'),
    Selection._('侄女'),
    Selection._('甥/侄'),
    Selection._('外甥（姐妹的儿子）'),
    Selection._('侄子'),
    Selection._('甥孙女/侄孙女/侄外孙女/甥外孙女'),
    Selection._('侄外孙女/甥外孙女'),
    Selection._('甥孙女/侄孙女'),
    Selection._('甥孙/侄孙/甥外孙/侄外孙'),
    Selection._('甥外孙/侄外孙'),
    Selection._('甥孙/侄孙'),
    Selection._('继父/母'),
    Selection._('继子/女'),
    Selection._('继兄弟'),
    Selection._('继姐/妹'),
    Selection._('婆婆/岳母或继母'),
    Selection._('公公/岳父或继父'),
    Selection._('儿媳妇或继女'),
    Selection._('女婿或继子'),
    Selection._('兄/弟/姐/妹（堂表亲）或兄/弟/姐/妹的孩子'),
    Selection._('侄女/外甥女或兄/弟/姐/妹（堂表亲）'),
    Selection._('甥/侄或兄/弟姐/妹（堂表亲）'),
    Selection._('孙辈子女或兄/弟/姐/妹的孩子'),
    Selection._('曾孙子/女或兄/弟/姐/妹的孙辈子女'),
    Selection._('儿媳妇或夫或妻的姐妹'),
    Selection._('女婿或夫或妻的兄弟'),
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
