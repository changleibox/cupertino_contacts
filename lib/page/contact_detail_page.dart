/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/presenter/contact_detail_presenter.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/add_contact_remarks_text_field.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/30.
///
/// 联系人详情
class ContactDetailPage extends StatefulWidget {
  final Contact contact;

  const ContactDetailPage({
    Key key,
    @required this.contact,
  })  : assert(contact != null),
        super(key: key);

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends PresenterState<ContactDetailPage, ContactDetailPresenter> {
  _ContactDetailPageState() : super(ContactDetailPresenter());

  @override
  Widget builds(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;
    return CupertinoPageScaffold(
      child: SupportNestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: CupertinoNavigationBar(
                backgroundColor: CupertinoColors.tertiarySystemBackground,
                border: null,
                middle: Text('联系人'),
                previousPageTitle: '通讯录',
                trailing: NavigationBarAction(
                  child: Text('编辑'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      RouteProvider.buildRoute(
                        EditContactPage(),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.tertiarySystemBackground,
                  context,
                ),
                foregroundDecoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: CupertinoDynamicColor.resolve(
                        separatorColor.withOpacity(0.1),
                        context,
                      ),
                      width: 0.0, // One physical pixel.
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                  bottom: 16,
                ),
                child: WidgetGroup.spacing(
                  alignment: MainAxisAlignment.center,
                  direction: Axis.vertical,
                  spacing: 8,
                  children: <Widget>[
                    CupertinoCircleAvatar.memory(
                      assetName: Images.ic_default_avatar,
                      bytes: widget.contact.avatar,
                      borderSide: BorderSide.none,
                      size: 80,
                    ),
                    Text(
                      widget.contact.displayName,
                      style: textTheme.textStyle.copyWith(
                        fontSize: 26,
                      ),
                    ),
                    WidgetGroup.spacing(
                      alignment: MainAxisAlignment.center,
                      spacing: 24,
                      children: [
                        _OperationButton(
                          icon: CupertinoIcons.info,
                          text: '信息',
                          onPressed: () {},
                        ),
                        _OperationButton(
                          icon: CupertinoIcons.info,
                          text: '呼叫',
                          onPressed: null,
                        ),
                        _OperationButton(
                          icon: CupertinoIcons.info,
                          text: '视频',
                          onPressed: null,
                        ),
                        _OperationButton(
                          icon: CupertinoIcons.info,
                          text: '邮件',
                          onPressed: null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: CupertinoTheme(
          data: themeData.copyWith(
            textTheme: textTheme.copyWith(
              textStyle: textStyle.copyWith(
                fontSize: 15,
              ),
            ),
          ),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: CupertinoScrollbar(
              child: ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: <Widget>[
                  AddContactRemarksTextField(
                    info: presenter.remarksInfo,
                    minLines: 2,
                  ),
                  CupertinoDivider(
                    color: separatorColor.withOpacity(0.1),
                  ),
                  CupertinoButton(
                    minSize: 44,
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 10,
                    ),
                    borderRadius: BorderRadius.zero,
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.tertiarySystemBackground,
                      context,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '共享联系人',
                        style: textTheme.actionTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OperationButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const _OperationButton({
    Key key,
    @required this.icon,
    @required this.text,
    this.onPressed,
  })  : assert(icon != null),
        assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      borderRadius: BorderRadius.zero,
      child: WidgetGroup.spacing(
        alignment: MainAxisAlignment.center,
        direction: Axis.vertical,
        spacing: 4,
        children: [
          Icon(
            icon,
            size: 44,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
