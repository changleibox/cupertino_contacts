/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/add_contact_page.dart';
import 'package:cupertinocontacts/page/contact_group_page.dart';
import 'package:cupertinocontacts/presenter/cupertino_contacts_presenter.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/contact_item_widget.dart';
import 'package:cupertinocontacts/widget/contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/drag_dismiss_keyboard_container.dart';
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
const double _kDividerSize = 0.5;
const double _kItemHeight = 85.0;

class CupertinoContactsPage extends StatefulWidget {
  const CupertinoContactsPage({Key key}) : super(key: key);

  @override
  _CupertinoContactsPageState createState() => _CupertinoContactsPageState();
}

class _CupertinoContactsPageState extends PresenterState<CupertinoContactsPage, CupertinoContactsPresenter> with SingleTickerProviderStateMixin {
  _CupertinoContactsPageState() : super(CupertinoContactsPresenter());

  AnimationController _animationController;
  Animation<double> _animation;
  ColorTween _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = _animationController.drive(CurveTween(
      curve: Curves.easeIn,
    ));
    super.initState();
  }

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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _buildPinnedHeaderSliverHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top + _kNavBarPersistentHeight + _kSearchBarHeight;
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    if (innerBoxIsScrolled) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    return [
      _AnimatedCupertinoSliverNavigationBar(
        animation: _animation,
        colorTween: _colorTween,
      ),
      _AnimatedSliverSearchBar(
        animation: _animation,
        colorTween: _colorTween,
        onQuery: presenter.onQuery,
      ),
    ];
  }

  Widget _buildBody() {
    if (presenter.isLoading && presenter.isEmpty) {
      return Center(
        child: CupertinoActivityIndicator(
          radius: 14,
        ),
      );
    }
    var textTheme = CupertinoTheme.of(context).textTheme;
    var padding = MediaQuery.of(context).padding;
    final slivers = List<Widget>();
    slivers.add(SupportSliverRefreshIndicator(
      onRefresh: presenter.onRefresh,
    ));
    slivers.add(SliverToBoxAdapter(
      child: Container(
        color: CupertinoDynamicColor.resolve(
          itemColor,
          context,
        ),
        child: CustomContactItemWidget(
          avatar: null,
          name: 'Box',
          describe: '我的名片',
          height: _kItemHeight,
        ),
      ),
    ));
    if (presenter.isEmpty) {
      slivers.add(SliverFillRemaining(
        child: Center(
          child: Text(
            '暂无联系人',
            style: textTheme.textStyle.copyWith(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.secondaryLabel,
                context,
              ),
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
            dividerHeight: _kDividerSize,
            indexHeight: _kIndexHeight,
            itemHeight: _kItemHeight,
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
              '${presenter.contactCount}位联系人',
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
    );
  }
}

abstract class _AnimatedColorWidget extends AnimatedWidget {
  final ColorTween colorTween;

  const _AnimatedColorWidget({
    Key key,
    @required this.colorTween,
    @required Listenable listenable,
  })  : assert(colorTween != null),
        assert(listenable != null),
        super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    return evaluateBuild(context, colorTween.evaluate(listenable));
  }

  Widget evaluateBuild(BuildContext context, Color color);
}

class _AnimatedCupertinoSliverNavigationBar extends _AnimatedColorWidget {
  const _AnimatedCupertinoSliverNavigationBar({
    Key key,
    @required ColorTween colorTween,
    @required Animation<double> animation,
  }) : super(key: key, colorTween: colorTween, listenable: animation);

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
        onPressed: () {
          Navigator.push(
            context,
            RouteProvider.buildRoute(
              ContactGroupPage(),
              fullscreenDialog: true,
            ),
          );
        },
      ),
      trailing: NavigationBarAction(
        child: Icon(
          CupertinoIcons.add,
          size: 30,
        ),
        onPressed: () {
          Navigator.push(
            context,
            RouteProvider.buildRoute(
              AddContactPage(),
              fullscreenDialog: true,
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedSliverSearchBar extends _AnimatedColorWidget {
  final ValueChanged<String> onQuery;

  const _AnimatedSliverSearchBar({
    Key key,
    @required ColorTween colorTween,
    @required Animation<double> animation,
    @required this.onQuery,
  }) : super(key: key, colorTween: colorTween, listenable: animation);

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
