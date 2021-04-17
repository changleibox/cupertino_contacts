/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/31.
///
/// 搜索框
class SearchBar extends StatelessWidget {
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

  final double height;
  final TextEditingController queryController;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.only(
        left: 16,
        top: 6,
        right: 16,
        bottom: 14,
      ),
      child: SearchBarTextField(
        queryController: queryController,
        focusNode: focusNode,
        color: color,
        opacity: opacity,
        onChanged: onChanged,
      ),
    );
  }
}

class SearchBarTextField extends StatelessWidget {
  const SearchBarTextField({
    Key key,
    this.queryController,
    this.onChanged,
    this.focusNode,
    this.color,
    this.opacity = 1.0,
  })  : assert(opacity >= 0 && opacity <= 1.0),
        super(key: key);

  final TextEditingController queryController;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
            style: const TextStyle(
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
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
          ),
        ),
      ),
    );
  }
}
