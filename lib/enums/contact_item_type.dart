/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';

enum ContactItemType {
  baseInfo,
  phone,
  email,
  phoneRinging,
  smsRinging,
  url,
  address,
  birthday,
  date,
  relatedParty,
  socialData,
  instantMessaging,
  remarks,
  addInfo,
}

TextInputType convertInputType(ContactItemType itemType) {
  TextInputType inputType = TextInputType.text;
  switch (itemType) {
    case ContactItemType.phone:
      inputType = TextInputType.phone;
      break;
    case ContactItemType.email:
      inputType = TextInputType.emailAddress;
      break;
    case ContactItemType.url:
      inputType = TextInputType.url;
      break;
    case ContactItemType.baseInfo:
    case ContactItemType.phoneRinging:
    case ContactItemType.smsRinging:
    case ContactItemType.address:
    case ContactItemType.birthday:
    case ContactItemType.date:
    case ContactItemType.relatedParty:
    case ContactItemType.socialData:
    case ContactItemType.instantMessaging:
    case ContactItemType.remarks:
    case ContactItemType.addInfo:
  }
  return inputType;
}