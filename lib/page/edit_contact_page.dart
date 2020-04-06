/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/presenter/edit_contact_presenter.dart';
import 'package:cupertinocontacts/widget/add_contact_choose_ring_tone_button.dart';
import 'package:cupertinocontacts/widget/add_contact_group_container.dart';
import 'package:cupertinocontacts/widget/add_contact_info_group.dart';
import 'package:cupertinocontacts/widget/add_contact_normal_selection_button.dart';
import 'package:cupertinocontacts/widget/add_contact_normal_text_field.dart';
import 'package:cupertinocontacts/widget/add_contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/add_contact_remarks_text_field.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/primary_slidable_controller.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Created by box on 2020/3/30.
///
/// 添加联系人
const double _kMaxAvatarSize = 144.0;
const double _kMinAvatarSize = 48.0;

class EditContactPage extends StatefulWidget {
  final Contact initialContact;

  const EditContactPage({
    Key key,
    this.initialContact,
  }) : super(key: key);

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends PresenterState<EditContactPage, EditContactPresenter> {
  _EditContactPageState() : super(EditContactPresenter());

  SlidableController _slidableController;

  @override
  void initState() {
    _slidableController = SlidableController(
      onSlideAnimationChanged: (value) {},
      onSlideIsOpenChanged: (value) {},
    );
    super.initState();
  }

  @override
  void onRootTap() {
    _onDismissSlidable();
    super.onRootTap();
  }

  _onDismissSlidable() {
    _slidableController.activeState?.close();
  }

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
        children.add(AddContactChooseRingToneButton(
          info: contactInfo,
        ));
      } else if (contactInfo is NormalSelectionContactInfo) {
        children.add(AddContactNormalSelectionButton(
          info: contactInfo,
        ));
      } else if (contactInfo is MultiEditableContactInfo) {
        children.add(AddContactRemarksTextField(
          info: contactInfo,
        ));
      }
    }

    var persistentHeaderDelegate = AddContactPersistentHeaderDelegate(
      avatar: presenter.avatar,
      maxAvatarSize: _kMaxAvatarSize,
      minAvatarSize: _kMinAvatarSize,
      onEditAvatarPressed: presenter.onEditAvatarPressed,
    );

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
        trailing: ValueListenableBuilder<Contact>(
          valueListenable: presenter,
          builder: (context, value, child) {
            return NavigationBarAction(
              child: Text('完成'),
              onPressed: presenter.isChanged ? presenter.onDonePressed : null,
            );
          },
        ),
      ),
      child: SupportNestedScrollView(
        physics: SnappingScrollPhysics(
          midScrollOffset: _kMaxAvatarSize,
        ),
        pinnedHeaderSliverHeightBuilder: (context) {
          return persistentHeaderDelegate.minExtent;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: AddContactPersistentHeaderDelegate(
                avatar: presenter.avatar,
                maxAvatarSize: _kMaxAvatarSize,
                minAvatarSize: _kMinAvatarSize,
                onEditAvatarPressed: presenter.onEditAvatarPressed,
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
          child: PrimarySlidableController(
            controller: _slidableController,
            child: Listener(
              onPointerDown: (event) => _onDismissSlidable(),
              child: NotificationListener<ScrollStartNotification>(
                onNotification: (notification) {
                  _onDismissSlidable();
                  return false;
                },
                child: CupertinoScrollbar(
                  child: ListView.separated(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
          ),
        ),
      ),
    );
  }
}
