/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contact/contact.dart';

const double _kPaddingBottom = 16.0;
const double _kSpacing = 10.0;
const double _kTextHeight = 14.0;
const double _kNavigationBarHeight = 44;

abstract class EditContactOperation implements ValueListenable<Contact> {
  Uint8List get avatar;

  bool get isChanged;

  void onCancelPressed();

  void onDonePressed();

  void onEditAvatarPressed();
}

class EditContactPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const EditContactPersistentHeaderDelegate({
    @required this.maxAvatarSize,
    @required this.minAvatarSize,
    @required this.paddingTop,
    @required this.routeTitle,
    @required this.isEditContact,
    @required this.operation,
  })  : assert(maxAvatarSize != null),
        assert(minAvatarSize != null),
        assert(paddingTop != null),
        assert(isEditContact != null),
        assert(operation != null);

  final double maxAvatarSize;
  final double minAvatarSize;
  final double paddingTop;
  final bool isEditContact;
  final String routeTitle;
  final EditContactOperation operation;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final scrollExtent = maxExtent - minExtent;
    final offset = 1.0 - shrinkOffset / scrollExtent;

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
      padding: const EdgeInsets.only(
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
              middle: isEditContact ? null : const Text('新建联系人'),
              leading: NavigationBarAction(
                onPressed: operation.onCancelPressed,
                child: const Text('取消'),
              ),
              trailing: ValueListenableBuilder<Contact>(
                valueListenable: operation,
                builder: (context, value, child) {
                  return NavigationBarAction(
                    onPressed: operation.isChanged ? operation.onDonePressed : null,
                    child: Text(isEditContact ? '更新' : '完成'),
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
                  bytes: operation.avatar,
                  borderSide: BorderSide.none,
                  size: minAvatarSize + (maxAvatarSize - minAvatarSize) * offset,
                  onPressed: operation.onEditAvatarPressed,
                ),
                if (offset > 0)
                  CupertinoButton(
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.zero,
                    onPressed: operation.onEditAvatarPressed,
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
  double get minExtent => minAvatarSize + _kPaddingBottom + paddingTop + (isEditContact && routeTitle == null ? 0 : _kNavigationBarHeight);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
