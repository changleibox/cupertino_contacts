/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/presenter/home_presenter.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/animated_color_widget.dart';
import 'package:cupertinocontacts/widget/contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/cupertino_progress.dart';
import 'package:cupertinocontacts/widget/drag_dismiss_keyboard_container.dart';
import 'package:cupertinocontacts/widget/error_tips.dart';
import 'package:cupertinocontacts/widget/fast_index_container.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/search_bar_header_delegate.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/support_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/29.
///
/// iOS风格联系人页面
const double _kSearchBarHeight = 56.0;
const double _kNavBarPersistentHeight = 44.0;
const double _kNavBarLargeTitleHeightExtension = 52.0;
const double _kIndexHeight = 26.0;
const double _kItemHeight = 44.0;

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    this.launchMode = HomeLaunchMode.normal,
    this.selectedIds,
  })  : assert(launchMode != null),
        super(key: key);

  final HomeLaunchMode launchMode;
  final List<String> selectedIds;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends PresenterState<HomePage, HomePresenter> {
  _HomePageState() : super(HomePresenter());

  ColorTween _colorTween;

  @override
  void didChangeDependencies() {
    _colorTween = ColorTween(
      begin: CupertinoDynamicColor.resolve(
        secondaryHeaderColor,
        context,
      ),
      end: CupertinoDynamicColor.resolve(
        headerColor,
        context,
      ),
    );
    super.didChangeDependencies();
  }

  double _buildPinnedHeaderSliverHeight(BuildContext context) {
    if (presenter.isSelectionMode) {
      return _kSearchBarHeight;
    }
    return MediaQuery.of(context).padding.top + _kNavBarPersistentHeight + _kSearchBarHeight;
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    return [
      if (!presenter.isSelectionMode)
        _AnimatedCupertinoSliverNavigationBar(
          colorTween: _colorTween,
          onGroupPressed: presenter.onGroupPressed,
        ),
      _AnimatedSliverSearchBar(
        colorTween: _colorTween,
        onQuery: presenter.onQuery,
      ),
    ];
  }

  ObstructingPreferredSizeWidget _buildNavigationBar() {
    if (!presenter.isSelectionMode) {
      return null;
    }
    return CupertinoNavigationBar(
      middle: const Text('通讯录'),
      padding: const EdgeInsetsDirectional.only(
        start: 16,
        end: 10,
      ),
      border: null,
      backgroundColor: _colorTween.end,
      leading: NavigationBarAction(
        onPressed: presenter.onGroupPressed,
        child: const Text('群组'),
      ),
      trailing: NavigationBarAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('取消'),
      ),
    );
  }

  Widget _buildBody() {
    if (presenter.showProgress) {
      return CupertinoProgress();
    }
    final textTheme = CupertinoTheme.of(context).textTheme;
    final padding = MediaQuery.of(context).padding;
    final slivers = <Widget>[];
    slivers.add(SupportSliverRefreshIndicator(
      onRefresh: presenter.onRefresh,
    ));
    if (presenter.isEmpty) {
      slivers.add(SliverFillRemaining(
        child: ErrorTips(
          exception: '无联系人',
          style: TextStyle(
            fontSize: 26,
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.secondaryLabel,
              context,
            ),
          ),
        ),
      ));
    } else {
      slivers.addAll(List.generate(presenter.keyCount, (index) {
        return SliverPersistentHeader(
          key: presenter.contactKeys[index],
          delegate: ContactPersistentHeaderDelegate(
            contactEntry: presenter.entries.elementAt(index),
            dividerHeight: 1.0 / MediaQuery.of(context).devicePixelRatio,
            indexHeight: _kIndexHeight,
            itemHeight: _kItemHeight,
            disableBuilder: (contact) {
              final ids = widget.selectedIds;
              return ids == null || !ids.contains(contact.identifier);
            },
            onItemPressed: presenter.onItemPressed,
          ),
        );
      }));
      slivers.add(SliverPadding(
        padding: padding.copyWith(
          top: 10.0,
          bottom: padding.bottom + 10,
        ),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: Text(
              '${presenter.itemCount}位联系人',
              style: textTheme.textStyle.copyWith(
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.secondaryLabel,
                  context,
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return FastIndexContainer(
      indexs: presenter.indexs,
      itemKeys: presenter.contactKeys,
      child: CustomScrollView(
        slivers: slivers,
      ),
    );
  }

  @override
  Widget builds(BuildContext context) {
    final themeData = CupertinoTheme.of(context);
    final textTheme = themeData.textTheme;
    final navLargeTitleTextStyle = textTheme.navLargeTitleTextStyle;
    return CupertinoTheme(
      data: themeData.copyWith(
        textTheme: textTheme.copyWith(
          navLargeTitleTextStyle: navLargeTitleTextStyle.copyWith(
            height: 0.0,
          ),
        ),
      ),
      child: CupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: SafeArea(
          top: presenter.isSelectionMode,
          bottom: false,
          child: DragDismissKeyboardContainer(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: SupportNestedScrollView(
              pinnedHeaderSliverHeightBuilder: _buildPinnedHeaderSliverHeight,
              headerSliverBuilder: _buildHeaderSliver,
              physics: const SnappingScrollPhysics(
                midScrollOffset: _kNavBarLargeTitleHeightExtension,
              ),
              body: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedCupertinoSliverNavigationBar extends AnimatedColorWidget {
  const _AnimatedCupertinoSliverNavigationBar({
    Key key,
    @required ColorTween colorTween,
    this.onGroupPressed,
  }) : super(key: key, colorTween: colorTween);

  final VoidCallback onGroupPressed;

  @override
  Widget evaluateBuild(BuildContext context, Color color) {
    return CupertinoSliverNavigationBar(
      largeTitle: const Text('通讯录'),
      padding: const EdgeInsetsDirectional.only(
        start: 16,
        end: 10,
      ),
      border: null,
      backgroundColor: color,
      leading: NavigationBarAction(
        onPressed: onGroupPressed,
        child: const Text('群组'),
      ),
      trailing: NavigationBarAction(
        onPressed: () {
          Navigator.push<void>(
            context,
            RouteProvider.buildRoute(
              const EditContactPage(),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(
          CupertinoIcons.add,
        ),
      ),
    );
  }
}

class _AnimatedSliverSearchBar extends AnimatedColorWidget {
  const _AnimatedSliverSearchBar({
    Key key,
    @required ColorTween colorTween,
    @required this.onQuery,
  }) : super(key: key, colorTween: colorTween);

  final ValueChanged<String> onQuery;

  @override
  Widget evaluateBuild(BuildContext context, Color color) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SearchBarHeaderDelegate(
        height: _kSearchBarHeight,
        onChanged: onQuery,
        backgroundColor: color,
      ),
    );
  }
}
