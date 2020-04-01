/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/presenter/contact_group_presenter.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/cupertino_progress.dart';
import 'package:cupertinocontacts/widget/error_tips.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/support_refresh_indicator.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/30.
///
/// 群组
class ContactGroupPage extends StatefulWidget {
  const ContactGroupPage({Key key}) : super(key: key);

  @override
  _ContactGroupPageState createState() => _ContactGroupPageState();
}

class _ContactGroupPageState extends PresenterState<ContactGroupPage, ContactGroupPresenter> {
  _ContactGroupPageState() : super(ContactGroupPresenter());

  List<Widget> _buildChildren() {
    final slivers = List<Widget>();
    if (presenter.showProgress) {
      slivers.add(SliverFillRemaining(
        child: CupertinoProgress(),
      ));
    } else {
      slivers.add(SupportSliverRefreshIndicator(
        onRefresh: presenter.onRefresh,
      ));
      if (presenter.isEmpty) {
        slivers.add(SliverFillRemaining(
          child: ErrorTips(
            exception: '暂无群组',
          ),
        ));
      } else {
        slivers.add(SliverPadding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 32,
            right: 16,
            bottom: 4,
          ),
          sliver: SliverToBoxAdapter(
            child: Text(
              'IPHONE',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.secondaryLabel,
                  context,
                ),
              ),
            ),
          ),
        ));
        slivers.add(SliverToBoxAdapter(
          child: Container(
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.tertiarySystemBackground,
              context,
            ),
            child: WidgetGroup.separated(
              alignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              direction: Axis.vertical,
              itemCount: presenter.itemCount,
              itemBuilder: (context, index) {
                return CupertinoButton(
                  child: WidgetGroup.spacing(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        presenter[index],
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                      ),
                      Icon(
                        CupertinoIcons.check_mark,
                        size: 40,
                        color: CupertinoTheme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 8,
                  ),
                  color: CupertinoColors.tertiarySystemBackground,
                  minSize: 44,
                  borderRadius: BorderRadius.zero,
                  onPressed: () {},
                );
              },
              separatorBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  child: CupertinoDivider(
                    color: separatorColor.withOpacity(0.2),
                  ),
                );
              },
            ),
          ),
        ));
      }
    }
    return slivers;
  }

  @override
  Widget builds(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('群组'),
        automaticallyImplyLeading: false,
        backgroundColor: CupertinoColors.tertiarySystemBackground,
        trailing: CupertinoButton(
          child: Text('完成'),
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
          minSize: 0,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      child: CustomScrollView(
        slivers: _buildChildren(),
      ),
    );
  }
}
