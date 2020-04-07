/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';

/// Created by box on 2020/3/26.
///
/// 联系人列表item
class ContactItemWidget extends StatelessWidget {
  final Contact contact;

  const ContactItemWidget({
    Key key,
    @required this.contact,
  })  : assert(contact != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var phones = contact.phones;
    var phone;
    if (phones != null && phones.isNotEmpty) {
      phone = phones.first.value;
    }
    return CustomContactItemWidget(
      avatar: contact.avatar,
      name: contact.displayName,
      describe: phone,
    );
  }
}

class CustomContactItemWidget extends StatelessWidget {
  final Uint8List avatar;
  final String name;
  final String describe;

  const CustomContactItemWidget({
    Key key,
    @required this.avatar,
    @required this.name,
    @required this.describe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: WidgetGroup.spacing(
        alignment: MainAxisAlignment.start,
        spacing: 10,
        children: <Widget>[
          CupertinoCircleAvatar.memory(
            bytes: avatar,
            assetName: Images.ic_default_avatar,
            size: 65,
          ),
          Expanded(
            child: WidgetGroup.spacing(
              alignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              direction: Axis.vertical,
              spacing: 4,
              children: <Widget>[
                Text(
                  name ?? '',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.label,
                      context,
                    ),
                  ),
                ),
                Text(
                  describe ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.secondaryLabel,
                      context,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
