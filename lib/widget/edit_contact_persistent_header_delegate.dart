/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/presenter/edit_contact_presenter.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

const double _kPaddingBottom = 16.0;
const double _kSpacing = 10.0;
const double _kTextHeight = 14.0;
const double _kNavigationBarHeight = 44;

class EditContactPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxAvatarSize;
  final double minAvatarSize;
  final double paddingTop;
  final bool isEditContact;
  final EditContactPresenter presenter;

  const EditContactPersistentHeaderDelegate({
    @required this.maxAvatarSize,
    @required this.minAvatarSize,
    @required this.paddingTop,
    @required this.isEditContact,
    @required this.presenter,
  })  : assert(maxAvatarSize != null),
        assert(minAvatarSize != null),
        assert(paddingTop != null),
        assert(isEditContact != null),
        assert(presenter != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final scrollExtent = maxExtent - minExtent;
    final offset = 1.0 - shrinkOffset / scrollExtent;
    return Container(
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
        bottom: _kPaddingBottom,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: CupertinoNavigationBar(
              backgroundColor: CupertinoColors.tertiarySystemBackground,
              border: null,
              middle: isEditContact ? null : Text('新建联系人'),
              leading: NavigationBarAction(
                child: Text('取消'),
                onPressed: presenter.onCancelPressed,
              ),
              trailing: ValueListenableBuilder<Contact>(
                valueListenable: presenter,
                builder: (context, value, child) {
                  return NavigationBarAction(
                    child: Text('完成'),
                    onPressed: presenter.isChanged ? presenter.onDonePressed : null,
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
              alignment: MainAxisAlignment.start,
              direction: Axis.vertical,
              spacing: _kSpacing * offset,
              children: [
                CupertinoCircleAvatar.memory(
                  assetName: Images.ic_default_avatar,
                  bytes: presenter.avatar,
                  borderSide: BorderSide.none,
                  size: minAvatarSize + (maxAvatarSize - minAvatarSize) * offset,
                  onPressed: presenter.onEditAvatarPressed,
                ),
                if (offset > 0)
                  CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.zero,
                    onPressed: presenter.onEditAvatarPressed,
                    child: SizedBox(
                      height: _kTextHeight * offset,
                      child: Opacity(
                        opacity: offset,
                        child: Text(
                          '添加照片',
                          style: TextStyle(
                            fontSize: _kTextHeight * offset,
                            color: CupertinoTheme.of(context).primaryColor,
                            height: 1.0,
                          ),
                        ),
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

  double get _spacing => _kTextHeight + _kPaddingBottom + _kSpacing;

  @override
  double get maxExtent => maxAvatarSize + _spacing + _kNavigationBarHeight + paddingTop;

  @override
  double get minExtent => minAvatarSize + _kPaddingBottom + paddingTop + (isEditContact ? 0 : _kNavigationBarHeight);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
