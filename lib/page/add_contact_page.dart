/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/add_contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/30.
///
/// 添加联系人
class AddContactPage extends StatefulWidget {
  const AddContactPage({Key key}) : super(key: key);

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('新建联系人'),
        backgroundColor: CupertinoColors.tertiarySystemBackground,
        border: null,
        leading: CupertinoButton(
          child: Text('取消'),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        trailing: CupertinoButton(
          child: Text('完成'),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      child: SupportNestedScrollView(
        pinnedHeaderSliverHeightBuilder: (context) {
          return 64.0;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: AddContactPersistentHeaderDelegate(),
            ),
          ];
        },
        body: ListView(
          children: <Widget>[
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 44,
                    child: CupertinoTextField(
                      placeholder: '姓氏',
                      placeholderStyle: TextStyle(
                        color: CupertinoDynamicColor.resolve(
                          placeholderColor,
                          context,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.tertiarySystemBackground,
                      ),
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 10,
                      ),
                      clearButtonMode: OverlayVisibilityMode.editing,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 10,
                      children: [
                        Icon(
                          CupertinoIcons.add_circled_solid,
                          color: CupertinoColors.systemGreen,
                        ),
                        Text(
                          '添加电话',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 10,
                      children: [
                        Icon(
                          CupertinoIcons.add_circled_solid,
                          color: CupertinoColors.systemGreen,
                        ),
                        Text(
                          '添加电话',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 16,
                      children: [
                        Text(
                          '电话铃声',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                        Expanded(
                          child: Text(
                            '默认',
                          ),
                        ),
                        Icon(
                          CupertinoIcons.forward,
                          color: CupertinoDynamicColor.resolve(
                            CupertinoColors.secondaryLabel,
                            context,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 16,
                      children: [
                        Text(
                          '短信铃声',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                        Expanded(
                          child: Text(
                            '默认',
                          ),
                        ),
                        Icon(
                          CupertinoIcons.forward,
                          color: CupertinoDynamicColor.resolve(
                            CupertinoColors.secondaryLabel,
                            context,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 10,
                      children: [
                        Icon(
                          CupertinoIcons.add_circled_solid,
                          color: CupertinoColors.systemGreen,
                        ),
                        Text(
                          '添加电话',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 10,
                      children: [
                        Icon(
                          CupertinoIcons.add_circled_solid,
                          color: CupertinoColors.systemGreen,
                        ),
                        Text(
                          '添加电话',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 10,
                      children: [
                        Icon(
                          CupertinoIcons.add_circled_solid,
                          color: CupertinoColors.systemGreen,
                        ),
                        Text(
                          '添加电话',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 10,
                      children: [
                        Icon(
                          CupertinoIcons.add_circled_solid,
                          color: CupertinoColors.systemGreen,
                        ),
                        Text(
                          '添加电话',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 10,
                      children: [
                        Icon(
                          CupertinoIcons.add_circled_solid,
                          color: CupertinoColors.systemGreen,
                        ),
                        Text(
                          '添加电话',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 10,
                      children: [
                        Icon(
                          CupertinoIcons.add_circled_solid,
                          color: CupertinoColors.systemGreen,
                        ),
                        Text(
                          '添加电话',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: WidgetGroup.spacing(
                      spacing: 10,
                      children: [
                        Icon(
                          CupertinoIcons.add_circled_solid,
                          color: CupertinoColors.systemGreen,
                        ),
                        Text(
                          '添加电话',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      ],
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: WidgetGroup.spacing(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                direction: Axis.vertical,
                children: [
                  Text(
                    '备注',
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                  ),
                  CupertinoTextField(
                    decoration: null,
                    minLines: 3,
                    maxLines: null,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
                context,
              ),
              child: WidgetGroup.separated(
                alignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                direction: Axis.vertical,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '添加信息栏',
                      ),
                    ),
                    onPressed: () {},
                  );
                },
                separatorBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(
                      color: separatorColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
