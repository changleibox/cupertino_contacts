/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:ui';

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:flutter/cupertino.dart';

const Color _kDefaultNavBarBorderColor = Color(0x4D000000);

const Border _kDefaultNavBarBorder = Border(
  bottom: BorderSide(
    color: _kDefaultNavBarBorderColor,
    width: 0.0, // One physical pixel.
    style: BorderStyle.solid,
  ),
);

class SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController queryController;
  final ValueChanged<String> onChanged;
  final double height;
  final Color backgroundColor;

  const SearchBarHeaderDelegate({
    this.queryController,
    this.onChanged,
    @required this.height,
    this.backgroundColor,
  }) : assert(height != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: height,
          padding: EdgeInsets.only(
            left: 16,
            top: 4,
            right: 16,
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: CupertinoDynamicColor.resolve(
              backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor,
              context,
            ),
            border: _kDefaultNavBarBorder,
          ),
          child: CupertinoTextField(
            controller: queryController,
            placeholder: '搜索',
            onChanged: onChanged,
            decoration: BoxDecoration(
              color: CupertinoDynamicColor.resolve(
                systemFill,
                context,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            placeholderStyle: TextStyle(
              fontSize: 17,
              color: CupertinoDynamicColor.resolve(
                placeholderColor,
                context,
              ),
            ),
            prefix: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 6,
              ),
              child: Icon(
                CupertinoIcons.search,
                color: CupertinoDynamicColor.resolve(
                  placeholderColor,
                  context,
                ),
                size: 22,
              ),
            ),
            clearButtonMode: OverlayVisibilityMode.editing,
            padding: EdgeInsets.symmetric(
              horizontal: 4,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
