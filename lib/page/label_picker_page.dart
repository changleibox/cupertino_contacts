/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/animated_color_widget.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/search_bar_header_delegate.dart';
import 'package:cupertinocontacts/widget/sliver_list_view.dart';
import 'package:cupertinocontacts/widget/sliver_persistent_header_widget.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/11.
///
/// 选择标签
const double _kSearchBarHeight = 56.0;
const double _kNavigationBarHeight = 44.0;

class LabelPickerPage extends StatefulWidget {
  final List<Selection> selections;

  const LabelPickerPage({
    Key key,
    @required this.selections,
  })  : assert(selections != null && selections.length > 0),
        super(key: key);

  @override
  _LabelPickerPageState createState() => _LabelPickerPageState();
}

class _LabelPickerPageState extends State<LabelPickerPage> {
  ColorTween _colorTween;

  @override
  void didChangeDependencies() {
    _colorTween = ColorTween(
      begin: CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemGroupedBackground,
        context,
      ),
      end: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
    );
    super.didChangeDependencies();
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    return [
      _AnimatedCupertinoSliverNavigationBar(
        colorTween: _colorTween,
        onGroupPressed: () {},
      ),
      _AnimatedSliverSearchBar(
        colorTween: _colorTween,
        onQuery: (text) {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = CupertinoTheme.of(context).textTheme;
    var textStyle = textTheme.textStyle;
    var borderSide = BorderSide(
      color: CupertinoDynamicColor.resolve(
        separatorColor,
        context,
      ),
      width: 0.0,
    );
    var originalSelections = widget.selections;
    var originalLength = originalSelections.length;

    final customSelections = List<Selection>();
    customSelections.add(selections.addCustomSelection);

    var customLength = customSelections.length;

    return CupertinoPageScaffold(
      child: SupportNestedScrollView(
        pinnedHeaderSliverHeightBuilder: (context) {
          return _kNavigationBarHeight + MediaQuery.of(context).padding.top;
        },
        headerSliverBuilder: _buildHeaderSliver,
        physics: SnappingScrollPhysics(
          midScrollOffset: _kSearchBarHeight,
        ),
        body: CustomScrollView(
          slivers: [
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: SliverListView.separated(
                itemCount: originalLength,
                itemBuilder: (context, index) {
                  var selection = originalSelections[index];
                  return Container(
                    foregroundDecoration: BoxDecoration(
                      border: Border(
                        top: index == 0 ? borderSide : BorderSide.none,
                        bottom: index == originalLength - 1 ? borderSide : BorderSide.none,
                      ),
                    ),
                    child: CupertinoButton(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selection.selectionName,
                          style: textStyle,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      borderRadius: BorderRadius.zero,
                      color: CupertinoColors.secondarySystemGroupedBackground,
                      onPressed: () {},
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.secondarySystemGroupedBackground,
                      context,
                    ),
                    padding: EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            ),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: SliverListView.separated(
                itemCount: customLength,
                itemBuilder: (context, index) {
                  var selection = customSelections[index];
                  return Container(
                    foregroundDecoration: BoxDecoration(
                      border: Border(
                        top: index == 0 ? borderSide : BorderSide.none,
                        bottom: index == customLength - 1 ? borderSide : BorderSide.none,
                      ),
                    ),
                    child: CupertinoButton(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selection.selectionName,
                          style: textStyle,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      borderRadius: BorderRadius.zero,
                      color: CupertinoColors.secondarySystemGroupedBackground,
                      onPressed: () {},
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    color: CupertinoDynamicColor.resolve(
                      CupertinoColors.secondarySystemGroupedBackground,
                      context,
                    ),
                    padding: EdgeInsets.only(
                      left: 16,
                    ),
                    child: CupertinoDivider(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCupertinoSliverNavigationBar extends AnimatedColorWidget {
  final VoidCallback onGroupPressed;

  const _AnimatedCupertinoSliverNavigationBar({
    Key key,
    @required ColorTween colorTween,
    this.onGroupPressed,
  }) : super(key: key, colorTween: colorTween);

  @override
  Widget evaluateBuild(BuildContext context, Color color) {
    final height = _kNavigationBarHeight + MediaQuery.of(context).padding.top;
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverPersistentHeaderWidget(
        maxExtent: height,
        minExtent: height,
        builder: (context, shrinkOffset, overlapsContent) {
          return CupertinoNavigationBar(
            backgroundColor: color,
            middle: Text('标签'),
            automaticallyImplyLeading: false,
            border: null,
            leading: NavigationBarAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            trailing: NavigationBarAction(
              child: Text('编辑'),
              onPressed: null,
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedSliverSearchBar extends AnimatedColorWidget {
  final ValueChanged<String> onQuery;

  const _AnimatedSliverSearchBar({
    Key key,
    @required ColorTween colorTween,
    @required this.onQuery,
  }) : super(key: key, colorTween: colorTween);

  @override
  Widget evaluateBuild(BuildContext context, Color color) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SearchBarHeaderDelegate(
        height: _kSearchBarHeight,
        minHeight: 0,
        onChanged: onQuery,
        backgroundColor: color,
        color: CupertinoColors.secondarySystemFill,
      ),
    );
  }
}
