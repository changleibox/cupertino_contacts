/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/page/edit_contact_page.dart';
import 'package:cupertinocontacts/presenter/cupertino_contacts_presenter.dart';
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

class CupertinoContactsPage extends StatefulWidget {
  final HomeLaunchMode launchMode;
  final List<String> selectedIds;

  const CupertinoContactsPage({
    Key key,
    this.launchMode = HomeLaunchMode.normal,
    this.selectedIds,
  })  : assert(launchMode != null),
        super(key: key);

  @override
  _CupertinoContactsPageState createState() => _CupertinoContactsPageState();
}

class _CupertinoContactsPageState extends PresenterState<CupertinoContactsPage, CupertinoContactsPresenter> {
  _CupertinoContactsPageState() : super(CupertinoContactsPresenter());

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
      middle: Text('通讯录'),
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: 10,
      ),
      border: null,
      backgroundColor: _colorTween.end,
      leading: NavigationBarAction(
        child: Text('群组'),
        onPressed: presenter.onGroupPressed,
      ),
      trailing: NavigationBarAction(
        child: Text('取消'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildBody() {
    if (presenter.showProgress) {
      return CupertinoProgress();
    }
    var textTheme = CupertinoTheme.of(context).textTheme;
    var padding = MediaQuery.of(context).padding;
    final slivers = List<Widget>();
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
              var ids = widget.selectedIds;
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
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var navLargeTitleTextStyle = textTheme.navLargeTitleTextStyle;
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
              physics: SnappingScrollPhysics(
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
  final VoidCallback onGroupPressed;

  const _AnimatedCupertinoSliverNavigationBar({
    Key key,
    @required ColorTween colorTween,
    this.onGroupPressed,
  }) : super(key: key, colorTween: colorTween);

  @override
  Widget evaluateBuild(BuildContext context, Color color) {
    return CupertinoSliverNavigationBar(
      largeTitle: Text('通讯录'),
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: 10,
      ),
      border: null,
      backgroundColor: color,
      leading: NavigationBarAction(
        child: Text('群组'),
        onPressed: onGroupPressed,
      ),
      trailing: NavigationBarAction(
        child: Icon(
          CupertinoIcons.add,
          size: 35,
        ),
        onPressed: () {
          Navigator.push(
            context,
            RouteProvider.buildRoute(
              EditContactPage(),
              fullscreenDialog: true,
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
        onChanged: onQuery,
        backgroundColor: color,
      ),
    );
  }
}
