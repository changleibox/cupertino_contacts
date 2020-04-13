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
  final FocusNode focusNode;
  final Color color;
  final double opacity;

  const SearchBar({
    Key key,
    @required this.height,
    this.queryController,
    this.onChanged,
    this.focusNode,
    this.color,
    this.opacity = 1.0,
  })  : assert(height != null),
        assert(opacity >= 0 && opacity <= 1.0),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CupertinoDynamicColor.resolve(
              color ?? systemFill,
              context,
            ),
          ),
          child: Opacity(
            opacity: opacity,
            child: CupertinoTextField(
              controller: queryController,
              placeholder: '搜索',
              onChanged: onChanged,
              focusNode: focusNode,
              decoration: null,
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
          ),
        ),
      ),
    );
  }
}
