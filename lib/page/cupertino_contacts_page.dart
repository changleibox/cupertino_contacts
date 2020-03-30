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
import 'package:cupertinocontacts/widget/search_bar_header_delegate.dart';
import 'package:cupertinocontacts/widget/support_refresh_indicator.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

/// Created by box on 2020/3/29.
///
/// iOS风格联系人页面
const double _kSearchBarHeight = 56.0;
const double _kNavBarPersistentHeight = 44.0;
const double _kIndexHeight = 26.0;
const double _kDividerSize = 0.5;
const double _kItemHeight = 85.0;

class CupertinoContactsPage extends StatefulWidget {
  const CupertinoContactsPage({Key key}) : super(key: key);

  @override
  _CupertinoContactsPageState createState() => _CupertinoContactsPageState();
}

class _CupertinoContactsPageState extends PresenterState<CupertinoContactsPage, CupertinoContactsPresenter> {
  _CupertinoContactsPageState() : super(CupertinoContactsPresenter());

  double _buildPinnedHeaderSliverHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top + _kNavBarPersistentHeight + _kSearchBarHeight;
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    return [
      CupertinoSliverNavigationBar(
        largeTitle: Text('通讯录'),
        leading: CupertinoButton(
          child: Text('群组'),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
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
        trailing: CupertinoButton(
          child: Icon(
            CupertinoIcons.add,
            size: 30,
          ),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
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
        padding: EdgeInsetsDirectional.only(
          start: 16,
          end: 10,
        ),
        border: null,
        backgroundColor: headerColor,
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: SearchBarHeaderDelegate(
          height: _kSearchBarHeight,
          onChanged: presenter.onQuery,
          backgroundColor: headerColor,
        ),
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
    slivers.add(SupportRefreshIndicator(
      onRefresh: presenter.onRefresh,
    ));
    slivers.add(SliverToBoxAdapter(
      child: CustomContactItemWidget(
        avatar: null,
        name: 'Box',
        describe: '我的名片',
        height: _kItemHeight,
      ),
    ));
    if (presenter.isEmpty) {
      slivers.add(SliverFillRemaining(
        child: Center(
          child: Text(
            '暂无联系人',
            style: textTheme.textStyle,
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
    }
    slivers.add(SliverPadding(
      padding: padding.copyWith(
        top: 10.0,
      ),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Text(
            '${presenter.contactCount}位联系人',
            style: textTheme.textStyle,
          ),
        ),
      ),
    ));
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
    return CupertinoPageScaffold(
      child: DragDismissKeyboardContainer(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SupportNestedScrollView(
          pinnedHeaderSliverHeightBuilder: _buildPinnedHeaderSliverHeight,
          headerSliverBuilder: _buildHeaderSliver,
          body: _buildBody(),
        ),
      ),
    );
  }
}
