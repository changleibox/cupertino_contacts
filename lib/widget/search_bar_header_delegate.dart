/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:ui';

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const Color _kDefaultNavBarBorderColor = Color(0x4D000000);

const Border _kDefaultNavBarBorder = Border(
  bottom: BorderSide(
    color: _kDefaultNavBarBorderColor,
    width: 0.0, // One physical pixel.
    style: BorderStyle.solid,
  ),
);

Widget _wrapWithBackground({
  Border border,
  Color backgroundColor,
  Brightness brightness,
  Widget child,
  bool updateSystemUiOverlay = true,
}) {
  Widget result = child;
  if (updateSystemUiOverlay) {
    final bool isDark = backgroundColor.computeLuminance() < 0.179;
    final Brightness newBrightness = brightness ?? (isDark ? Brightness.dark : Brightness.light);
    SystemUiOverlayStyle overlayStyle;
    switch (newBrightness) {
      case Brightness.dark:
        overlayStyle = SystemUiOverlayStyle.light;
        break;
      case Brightness.light:
      default:
        overlayStyle = SystemUiOverlayStyle.dark;
        break;
    }
    result = AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      sized: true,
      child: result,
    );
  }
  final DecoratedBox childWithBackground = DecoratedBox(
    decoration: BoxDecoration(
      border: border,
      color: backgroundColor,
    ),
    child: result,
  );

  if (backgroundColor.alpha == 0xFF) return childWithBackground;

  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10.0,
        sigmaY: 10.0,
      ),
      child: childWithBackground,
    ),
  );
}

class SearchBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController queryController;
  final ValueChanged<String> onChanged;
  final double height;
  final Color backgroundColor;
  final Color color;

  const SearchBarHeaderDelegate({
    this.queryController,
    this.onChanged,
    @required this.height,
    this.backgroundColor,
    this.color,
  }) : assert(height != null);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _wrapWithBackground(
      border: _kDefaultNavBarBorder,
      backgroundColor: CupertinoDynamicColor.resolve(
        backgroundColor,
        context,
      ),
      child: Container(
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: CupertinoDynamicColor.resolve(
                separatorColor,
                context,
              ),
              width: 0.0,
            ),
          ),
        ),
        child: SearchBar(
          height: height,
          queryController: queryController,
          color: color,
          onChanged: onChanged,
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
