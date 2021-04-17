/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/9.
///
/// item容器，有左边线
class ContactItemContainer extends StatelessWidget {
  const ContactItemContainer({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: WidgetGroup(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  CupertinoDynamicColor.resolve(
                    CupertinoColors.separator.withOpacity(0.0),
                    context,
                  ),
                  CupertinoDynamicColor.resolve(
                    CupertinoColors.separator,
                    context,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
