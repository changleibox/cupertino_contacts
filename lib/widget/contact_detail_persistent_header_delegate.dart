/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

const double _kPaddingBottom = 16.0;
const double _kSpacing = 10.0;
const double _kTextHeight = 14.0;

class ContactDetailPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Contact contact;
  final double maxAvatarSize;
  final double minAvatarSize;
  final double paddingTop;
  final VoidCallback onEditAvatarPressed;

  const ContactDetailPersistentHeaderDelegate({
    @required this.contact,
    @required this.maxAvatarSize,
    @required this.minAvatarSize,
    @required this.paddingTop,
    this.onEditAvatarPressed,
  })  : assert(maxAvatarSize != null),
        assert(minAvatarSize != null),
        assert(paddingTop != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;

    final scrollExtent = maxAvatarSize - minAvatarSize;
    final offset = ((scrollExtent - shrinkOffset) / scrollExtent).clamp(0.0, 1.0);
    final offsetExtent = (_kSpacing + _kTextHeight) * (1.0 - offset);
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemBackground,
        context,
      ),
      foregroundDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoDynamicColor.resolve(
              separatorColor,
              context,
            ),
            width: 0.5, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: _kPaddingBottom,
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: CupertinoNavigationBar(
                backgroundColor: CupertinoColors.secondarySystemBackground,
                border: null,
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
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: WidgetGroup.spacing(
                alignment: MainAxisAlignment.center,
                direction: Axis.vertical,
                spacing: 8,
                children: <Widget>[
                  CupertinoCircleAvatar.memory(
                    assetName: Images.ic_default_avatar,
                    bytes: contact.avatar,
                    borderSide: BorderSide.none,
                    size: maxAvatarSize,
                  ),
                  Text(
                    contact.displayName,
                    style: textStyle.copyWith(
                      fontSize: 26,
                      height: 1.0,
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
          ],
        ),
      ),
    );
  }

  double get _spacing => 60 + 16 + 26 + _kPaddingBottom + paddingTop;

  @override
  double get maxExtent => maxAvatarSize + _spacing + 44;

  @override
  double get minExtent => minAvatarSize + _spacing;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
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
              height: 1.0,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
