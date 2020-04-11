/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/util/native_service.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';

const double _kPaddingBottom = 16.0;
const double _kSpacing = 16.0;
const double _kTextSpacing = 4.0;
const double _kActionButtonHeight = 60;
const double _kNavigationBarHeight = 32;
const double _kNormalTextSize = 17.0;

class ContactDetailPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Contact contact;
  final double maxAvatarSize;
  final double minAvatarSize;
  final double maxNameSize;
  final double minNameSize;
  final double paddingTop;
  final HomeLaunchMode launchMode;
  final String routeTitle;

  const ContactDetailPersistentHeaderDelegate({
    @required this.contact,
    @required this.maxAvatarSize,
    @required this.minAvatarSize,
    @required this.maxNameSize,
    @required this.minNameSize,
    @required this.paddingTop,
    @required this.launchMode,
    @required this.routeTitle,
  })  : assert(maxAvatarSize != null),
        assert(minAvatarSize != null),
        assert(maxNameSize != null),
        assert(minNameSize != null),
        assert(paddingTop != null),
        assert(launchMode != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;

    final isSelection = launchMode == HomeLaunchMode.selection;

    final scrollExtent = maxExtent - minExtent;
    final offset = 1.0 - shrinkOffset / scrollExtent;
    final opacity = (1 - (1.8 * (1 - offset))).clamp(0.0, 1.0);

    var route = ModalRoute.of(context);
    var title;
    if (route is CupertinoPageRoute) {
      title = route.title;
    }

    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      foregroundDecoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoDynamicColor.resolve(
              separatorColor,
              context,
            ),
            width: 0.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: _kPaddingBottom,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: CupertinoNavigationBar(
              backgroundColor: CupertinoColors.secondarySystemGroupedBackground,
              border: null,
              previousPageTitle: title == null ? '通讯录' : '返回',
              trailing: NavigationBarAction(
                child: Text(isSelection ? '链接' : '编辑'),
                onPressed: () {
                  if (isSelection) {
                    Navigator.pop(context, contact);
                  } else {
                    Navigator.push(
                      context,
                      _PageRoute(
                        fullscreenDialog: true,
                        title: title,
                        builder: (context) {
                          return EditContactPage(
                            contact: contact,
                            launchMode: title == null ? EditLaunchMode.normal : EditLaunchMode.other,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WidgetGroup.spacing(
              alignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              direction: Axis.vertical,
              spacing: _kSpacing,
              children: <Widget>[
                CupertinoCircleAvatar.memory(
                  assetName: Images.ic_default_avatar,
                  bytes: contact.avatar,
                  borderSide: BorderSide.none,
                  size: minAvatarSize + (maxAvatarSize - minAvatarSize) * offset,
                ),
                WidgetGroup.spacing(
                  alignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  direction: Axis.vertical,
                  spacing: _kTextSpacing * offset,
                  children: [
                    Text(
                      contact.displayName ?? '无姓名',
                      style: textStyle.copyWith(
                        fontSize: minNameSize + (maxNameSize - minNameSize) * offset,
                        height: 1.0,
                      ),
                    ),
                    if (_hasJob)
                      Opacity(
                        opacity: opacity,
                        child: Text(
                          contact.jobTitle,
                          style: textStyle.copyWith(
                            color: CupertinoDynamicColor.resolve(
                              CupertinoColors.secondaryLabel,
                              context,
                            ),
                            fontSize: _kNormalTextSize * offset,
                            height: 1.0,
                          ),
                        ),
                      ),
                    if (_hasCompany)
                      Opacity(
                        opacity: opacity,
                        child: Text(
                          contact.company,
                          style: textStyle.copyWith(
                            color: CupertinoDynamicColor.resolve(
                              CupertinoColors.secondaryLabel,
                              context,
                            ),
                            fontSize: _kNormalTextSize * offset,
                            height: 1.0,
                          ),
                        ),
                      ),
                  ],
                ),
                WidgetGroup.spacing(
                  alignment: MainAxisAlignment.center,
                  spacing: 24,
                  children: [
                    _OperationButton(
                      icon: CupertinoIcons.info,
                      text: '信息',
                      onPressed: _hasPhone || _hasEmail ? () => NativeService.message('account') : null,
                    ),
                    _OperationButton(
                      icon: CupertinoIcons.info,
                      text: '呼叫',
                      onPressed: _hasPhone ? () => NativeService.call('phone') : null,
                    ),
                    _OperationButton(
                      icon: CupertinoIcons.info,
                      text: '视频',
                      onPressed: _hasPhone || _hasEmail ? () => NativeService.faceTime('account') : null,
                    ),
                    _OperationButton(
                      icon: CupertinoIcons.info,
                      text: '邮件',
                      onPressed: _hasEmail ? () => NativeService.email('account') : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get _hasPhone => contact.phones != null && contact.phones.isNotEmpty;

  bool get _hasEmail => contact.emails != null && contact.emails.isNotEmpty;

  bool get _hasJob => contact.jobTitle != null && contact.jobTitle.isNotEmpty;

  bool get _hasCompany => contact.company != null && contact.company.isNotEmpty;

  double get _jobTextSize => _hasJob ? _kNormalTextSize : 0;

  double get _companyTextSize => _hasCompany ? _kNormalTextSize : 0;

  double get _jobCompanySize => _jobTextSize + _companyTextSize + _kTextSpacing * 2;

  double get _spacing => _kActionButtonHeight + _kSpacing * 2 + _kPaddingBottom + paddingTop;

  @override
  double get maxExtent => maxAvatarSize + _spacing + _kNavigationBarHeight + maxNameSize + _jobCompanySize;

  @override
  double get minExtent => minAvatarSize + _spacing + minNameSize + (routeTitle == null ? 0 : _kNavigationBarHeight);

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

class _PageRoute<T> extends CupertinoPageRoute<T> {
  _PageRoute({
    @required WidgetBuilder builder,
    String title,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        assert(opaque),
        super(
          settings: settings,
          fullscreenDialog: fullscreenDialog,
          title: title,
          builder: builder,
          maintainState: maintainState,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: child,
    );
  }
}
