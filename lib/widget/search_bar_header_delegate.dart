/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:ui';

import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/search_bar.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

const Duration _kDuration = Duration(milliseconds: 300);

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
  final FocusScopeNode focusNode;
  final double height;
  final double minHeight;
  final Color backgroundColor;
  final Color color;

  const SearchBarHeaderDelegate({
    this.queryController,
    this.onChanged,
    this.focusNode,
    @required this.height,
    this.minHeight,
    this.backgroundColor,
    this.color,
  }) : assert(height != null);

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
  final TextEditingController queryController;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final double height;
  final Color backgroundColor;
  final Color color;
  final double opacity;

  const SearchBarHeader({
    this.queryController,
    this.onChanged,
    this.focusNode,
    @required this.height,
    this.backgroundColor,
    this.color,
    this.opacity,
  }) : assert(height != null);

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
  final TextEditingController queryController;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final double height;
  final Color backgroundColor;
  final Color color;
  final double opacity;
  final bool hasCancelButton;
  final VoidCallback onCancelPressed;
  final EdgeInsets padding;

  const AnimatedSearchBarNavigationBar({
    this.queryController,
    this.onChanged,
    this.focusNode,
    @required this.height,
    this.backgroundColor,
    this.color,
    this.opacity,
    this.hasCancelButton = false,
    this.onCancelPressed,
    this.padding,
  })  : assert(height != null),
        assert(hasCancelButton != null);

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
      child: WidgetGroup(
        children: [
          Expanded(
            child: SizedBox(
              height: height,
              child: AnimatedContainer(
                duration: _kDuration,
                padding: padding,
                child: SearchBarTextField(
                  queryController: queryController,
                  color: color,
                  opacity: opacity ?? 1.0,
                  onChanged: onChanged,
                  focusNode: focusNode,
                ),
              ),
            ),
          ),
          if (hasCancelButton)
            CupertinoButton(
              child: Text('取消'),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              minSize: 0,
              borderRadius: BorderRadius.zero,
              onPressed: onCancelPressed,
            ),
        ],
      ),
    );
  }
}
