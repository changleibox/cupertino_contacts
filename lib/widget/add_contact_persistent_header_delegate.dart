/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';
import 'dart:typed_data';

import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

const double _kPaddingBottom = 16.0;
const double _kSpacing = 10.0;
const double _kTextHeight = 14.0;

class AddContactPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Uint8List avatar;
  final double maxAvatarSize;
  final double minAvatarSize;
  final VoidCallback onEditAvatarPressed;

  const AddContactPersistentHeaderDelegate({
    @required this.avatar,
    @required this.maxAvatarSize,
    @required this.minAvatarSize,
    this.onEditAvatarPressed,
  })  : assert(maxAvatarSize != null),
        assert(minAvatarSize != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final scrollExtent = maxAvatarSize - minAvatarSize;
    final offset = ((scrollExtent - shrinkOffset) / scrollExtent).clamp(0.0, 1.0);
    final offsetExtent = (_kSpacing + _kTextHeight) * (1.0 - offset);
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
      child: WidgetGroup.spacing(
        alignment: MainAxisAlignment.start,
        direction: Axis.vertical,
        spacing: _kSpacing * offset,
        children: [
          CupertinoCircleAvatar.memory(
            assetName: Images.ic_default_avatar,
            bytes: avatar,
            borderSide: BorderSide.none,
            size: max(maxAvatarSize - shrinkOffset + offsetExtent * (1.0 - offset), minAvatarSize),
            onPressed: onEditAvatarPressed,
          ),
          if (offset > 0)
            CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.zero,
              onPressed: onEditAvatarPressed,
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
    );
  }

  double get _spacing => _kTextHeight + _kPaddingBottom + _kSpacing;

  @override
  double get maxExtent => maxAvatarSize + _spacing;

  @override
  double get minExtent => minAvatarSize + _kPaddingBottom;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}