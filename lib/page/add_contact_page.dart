/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/presenter/add_contact_presenter.dart';
import 'package:cupertinocontacts/widget/add_contact_choose_ring_tone_button.dart';
import 'package:cupertinocontacts/widget/add_contact_group_container.dart';
import 'package:cupertinocontacts/widget/add_contact_info_group.dart';
import 'package:cupertinocontacts/widget/add_contact_normal_selection_button.dart';
import 'package:cupertinocontacts/widget/add_contact_normal_text_field.dart';
import 'package:cupertinocontacts/widget/add_contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/add_contact_remarks_text_field.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/3/30.
///
/// 添加联系人
const double _kMaxAvatarSize = 144.0;
const double _kMinAvatarSize = 48.0;

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key key}) : super(key: key);

  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends PresenterState<AddContactPage, AddContactPresenter> {
  _AddContactPageState() : super(AddContactPresenter());

  @override
  Widget builds(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;

    final children = List<Widget>();
    children.add(AddContactGroupContainer(
      itemCount: presenter.baseInfos.length,
      itemBuilder: (context, index) {
        var baseInfo = presenter.baseInfos[index];
        return AddContactNormalTextField(
          info: baseInfo,
        );
      },
    ));
    for (var contactInfo in presenter.groups) {
      if (contactInfo is ContactInfoGroup) {
        children.add(AddContactInfoGroup(
          infoGroup: contactInfo,
        ));
      } else if (contactInfo is DefaultSelectionContactInfo) {
        children.add(AddContactChooseRingToneButton());
      } else if (contactInfo is NormalSelectionContactInfo) {
        children.add(AddContactNormalSelectionButton());
      } else if (contactInfo is MultiEditableContactInfo) {
        children.add(AddContactRemarksTextField());
      }
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('新建联系人'),
        backgroundColor: CupertinoColors.tertiarySystemBackground,
        border: null,
        leading: NavigationBarAction(
          child: Text('取消'),
          onPressed: presenter.onCancelPressed,
        ),
        trailing: NavigationBarAction(
          child: Text('完成'),
          onPressed: presenter.onDonePressed,
        ),
      ),
      child: SupportNestedScrollView(
        physics: SnappingScrollPhysics(
          midScrollOffset: _kMaxAvatarSize,
        ),
        pinnedHeaderSliverHeightBuilder: (context) {
          return 64.0;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: AddContactPersistentHeaderDelegate(
                maxAvatarSize: _kMaxAvatarSize,
                minAvatarSize: _kMinAvatarSize,
              ),
            ),
          ];
        },
        body: CupertinoTheme(
          data: themeData.copyWith(
            textTheme: textTheme.copyWith(
              textStyle: textStyle.copyWith(
                fontSize: 15,
              ),
            ),
          ),
          child: CupertinoScrollbar(
            child: ListView.separated(
              itemCount: children.length,
              itemBuilder: (context, index) {
                return children[index];
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 40,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
