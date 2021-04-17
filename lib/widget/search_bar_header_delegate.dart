/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:ui';

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const double _kPadding = 16;
const double _kCancelButtonWidth = 68;

Widget _wrapWithBackground({
  Border border,
  Color backgroundColor,
  Brightness brightness,
  Widget child,
  bool updateSystemUiOverlay = true,
}) {
  var result = child;
  if (updateSystemUiOverlay) {
    final isDark = backgroundColor.computeLuminance() < 0.179;
    final newBrightness = brightness ?? (isDark ? Brightness.dark : Brightness.light);
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
  final childWithBackground = DecoratedBox(
    decoration: BoxDecoration(
      border: border,
      color: backgroundColor,
    ),
    child: result,
  );

  if (backgroundColor.alpha == 0xFF) {
    return childWithBackground;
  }

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
  const SearchBarHeaderDelegate({
    this.queryController,
    this.onChanged,
    this.focusNode,
    @required this.height,
    this.minHeight,
    this.backgroundColor,
    this.color,
  }) : assert(height != null);

  final TextEditingController queryController;
  final ValueChanged<String> onChanged;
  final FocusScopeNode focusNode;
  final double height;
  final double minHeight;
  final Color backgroundColor;
  final Color color;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SearchBarHeader(
      height: height,
      color: color,
      backgroundColor: backgroundColor,
      queryController: queryController,
      onChanged: onChanged,
      focusNode: focusNode,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => minHeight ?? height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class SearchBarHeader extends StatelessWidget {
  const SearchBarHeader({
    this.queryController,
    this.onChanged,
    this.focusNode,
    @required this.height,
    this.backgroundColor,
    this.color,
    this.opacity,
  }) : assert(height != null);

  final TextEditingController queryController;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final double height;
  final Color backgroundColor;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return _wrapWithBackground(
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
      backgroundColor: CupertinoDynamicColor.resolve(
        backgroundColor,
        context,
      ),
      child: SearchBar(
        height: height,
        queryController: queryController,
        color: color,
        opacity: opacity ?? 1.0,
        onChanged: onChanged,
        focusNode: focusNode,
      ),
    );
  }
}

class AnimatedSearchBarNavigationBar extends StatelessWidget {
  const AnimatedSearchBarNavigationBar({
    this.queryController,
    this.onChanged,
    this.focusNode,
    @required this.height,
    this.backgroundColor,
    this.color,
    this.opacity,
    this.onCancelPressed,
    this.animation,
  }) : assert(height != null);

  final TextEditingController queryController;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final double height;
  final Color backgroundColor;
  final Color color;
  final double opacity;
  final VoidCallback onCancelPressed;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final value = animation?.value ?? 1.0;
    final padding = EdgeInsets.only(
      left: _kPadding,
      top: 10.0 - 6 * value,
      bottom: 10.0 + 6 * value,
    );
    return _wrapWithBackground(
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
      backgroundColor: CupertinoDynamicColor.resolve(
        backgroundColor,
        context,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -(_kCancelButtonWidth - _kPadding) * value,
            child: Container(
              width: _kCancelButtonWidth,
              height: height,
              padding: padding.copyWith(
                left: 0.0,
                right: 0.0,
              ),
              child: CupertinoButton(
                minSize: 0,
                borderRadius: BorderRadius.zero,
                padding: EdgeInsets.zero,
                onPressed: onCancelPressed,
                child: const Text('取消'),
              ),
            ),
          ),
          Container(
            width: width - (_kCancelButtonWidth - (_kCancelButtonWidth - _kPadding) * value),
            height: height,
            padding: padding,
            child: SearchBarTextField(
              queryController: queryController,
              color: color,
              opacity: opacity ?? 1.0,
              onChanged: onChanged,
              focusNode: focusNode,
            ),
          ),
        ],
      ),
    );
  }
}
