/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 搜索框
class SearchBar extends StatelessWidget {
  final double height;
  final TextEditingController queryController;
  final ValueChanged<String> onChanged;
  final Color color;

  const SearchBar({
    Key key,
    @required this.height,
    this.queryController,
    this.onChanged,
    this.color,
  })  : assert(height != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.only(
        left: 16,
        top: 6,
        right: 16,
        bottom: 14,
      ),
      child: CupertinoTextField(
        controller: queryController,
        placeholder: '搜索',
        onChanged: onChanged,
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.resolve(
            color ?? systemFill,
            context,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        style: TextStyle(
          fontSize: 17,
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
        textInputAction: TextInputAction.search,
        clearButtonMode: OverlayVisibilityMode.editing,
        padding: EdgeInsets.symmetric(
          horizontal: 4,
        ),
      ),
    );
  }
}
