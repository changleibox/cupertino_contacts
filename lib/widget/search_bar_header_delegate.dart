/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

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

  const SearchBarHeaderDelegate({
    this.queryController,
    this.onChanged,
    @required this.height,
  }) : assert(height != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      padding: EdgeInsets.only(
        left: 16,
        top: 4,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).barBackgroundColor,
        border: _kDefaultNavBarBorder,
      ),
      child: CupertinoTextField(
        controller: queryController,
        placeholder: '搜索',
        onChanged: onChanged,
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.white,
            darkColor: CupertinoColors.black,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        prefix: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 6,
          ),
          child: Icon(
            CupertinoIcons.search,
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.placeholderText,
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
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
