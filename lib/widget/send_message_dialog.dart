/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/util/native_service.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';

Future<void> showSendMessageDialog(BuildContext context, Iterable<Item> phones, Iterable<Item> emails) {
  final textStyle = CupertinoTheme.of(context).textTheme.textStyle;
  final items = <Item>[...phones, ...emails];
  return showCupertinoModalPopup(
    context: context,
    builder: (context) {
      final actions = <Widget>[];
      actions.add(Container(
        alignment: Alignment.centerLeft,
        height: 64,
        child: WidgetGroup.spacing(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Icon(
                CupertinoIcons.conversation_bubble,
                size: 30,
                color: textStyle.color,
              ),
            ),
            Text(
              '信息',
              style: textStyle,
            ),
          ],
        ),
      ));
      actions.addAll(items.map((e) {
        return _SheetActionButton(
          label: e.label,
          value: e.value,
          onPressed: () {
            NativeService.message(e.value);
          },
        );
      }));
      return CupertinoActionSheet(
        actions: actions,
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('取消'),
        ),
      );
    },
  );
}

class _SheetActionButton extends StatelessWidget {
  const _SheetActionButton({
    Key key,
    @required this.label,
    @required this.value,
    this.onPressed,
  })  : assert(label != null),
        assert(value != null),
        super(key: key);

  final String label;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textStyle = CupertinoTheme.of(context).textTheme.textStyle;
    return CupertinoButton(
      padding: const EdgeInsets.only(
        left: 78,
        top: 10,
        right: 16,
        bottom: 10,
      ),
      onPressed: () {
        Navigator.pop(context);
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: WidgetGroup.spacing(
          alignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          direction: Axis.vertical,
          children: <Widget>[
            Text(
              label,
              style: textStyle,
            ),
            Text(
              value,
              style: textStyle.copyWith(
                fontSize: 12,
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.tertiaryLabel,
                  context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
