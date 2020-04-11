/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/enums/contact_item_type.dart';
import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/presenter/edit_contact_presenter.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/address_contact_info_group.dart';
import 'package:cupertinocontacts/widget/birthday_contact_info_group.dart';
import 'package:cupertinocontacts/widget/datetime_contact_info_group.dart';
import 'package:cupertinocontacts/widget/edit_contact_choose_ring_tone_button.dart';
import 'package:cupertinocontacts/widget/edit_contact_group_container.dart';
import 'package:cupertinocontacts/widget/edit_contact_info_group.dart';
import 'package:cupertinocontacts/widget/edit_contact_link_contact_info_group.dart';
import 'package:cupertinocontacts/widget/edit_contact_normal_button.dart';
import 'package:cupertinocontacts/widget/edit_contact_normal_selection_button.dart';
import 'package:cupertinocontacts/widget/edit_contact_normal_text_field.dart';
import 'package:cupertinocontacts/widget/edit_contact_remarks_text_field.dart';
import 'package:cupertinocontacts/widget/edit_contact_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/editable_selection_contact_info_group.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/primary_slidable_controller.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Created by box on 2020/3/30.
///
/// 添加联系人
const double _kMaxAvatarSize = 144.0;
const double _kMinAvatarSize = 48.0;

class EditContactPage extends StatefulWidget {
  final Contact contact;
  final EditLaunchMode launchMode;

  const EditContactPage({
    Key key,
    this.contact,
    this.launchMode = EditLaunchMode.normal,
  })  : assert(launchMode != null),
        super(key: key);

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

  String get _routeTitle {
    var route = ModalRoute.of(context);
    String title;
    if (route is CupertinoPageRoute) {
      title = route.title;
    }
    return title;
  }

  @override
  Widget builds(BuildContext context) {
    final children = List<Widget>();
    children.add(EditContactGroupContainer(
      itemCount: presenter.baseInfoMap.length,
      itemBuilder: (context, index) {
        var values = presenter.baseInfoMap.values;
        var baseInfo = values.elementAt(index);
        return EditContactNormalTextField(
          info: baseInfo,
        );
      },
    ));
    var itemKeys = presenter.itemMap.keys;
    for (var key in itemKeys) {
      final contactInfo = presenter.itemMap[key];
      if (key == ContactItemType.birthday) {
        children.add(
          BirthdayContactInfoGroup(infoGroup: contactInfo),
        );
      } else if (contactInfo is ContactInfoGroup<EditableItem>) {
        children.add(EditContactInfoGroup(
          infoGroup: contactInfo,
          inputType: convertInputType(key),
        ));
      } else if (contactInfo is ContactInfoGroup<DateTimeItem>) {
        children.add(DateTimeContactInfoGroup(
          infoGroup: contactInfo,
        ));
      } else if (contactInfo is ContactInfoGroup<AddressItem>) {
        children.add(
          AddressContactInfoGroup(infoGroup: contactInfo),
        );
      } else if (contactInfo is ContactInfoGroup<EditableSelectionItem>) {
        children.add(
          EditableSelectionContactInfoGroup(infoGroup: contactInfo),
        );
      } else if (contactInfo is DefaultSelectionContactInfo) {
        children.add(EditContactChooseRingToneButton(
          info: contactInfo,
        ));
      } else if (contactInfo is MultiEditableContactInfo) {
        children.add(EditContactRemarksTextField(
          info: contactInfo,
        ));
      } else if (contactInfo is NormalSelectionContactInfo) {
        children.add(EditContactNormalSelectionButton(
          info: contactInfo,
          onPressed: () {},
        ));
      } else if (contactInfo is ContactInfoGroup<ContactSelectionItem>) {
        children.add(EditContactLinkContactInfoGroup(
          infoGroup: contactInfo,
          currentContact: widget.contact,
        ));
      }
    }

    if (widget.contact != null) {
      children.add(EditContactNormalButton(
        text: '删除联系人',
        isDestructiveAction: true,
        onPressed: presenter.onDeleteContactPressed,
      ));
    }

    var persistentHeaderDelegate = EditContactPersistentHeaderDelegate(
      maxAvatarSize: _kMaxAvatarSize,
      minAvatarSize: _kMinAvatarSize,
      paddingTop: MediaQuery.of(context).padding.top,
      isEditContact: widget.contact != null,
      routeTitle: _routeTitle,
      operation: presenter,
    );

    var borderSide = BorderSide(
      color: CupertinoDynamicColor.resolve(
        separatorColor,
        context,
      ),
      width: 0.0,
    );

    return CupertinoPageScaffold(
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
              delegate: persistentHeaderDelegate,
            ),
          ];
        },
        body: PrimarySlidableController(
          controller: _slidableController,
          child: Listener(
            onPointerDown: (event) => _onDismissSlidable(),
            child: NotificationListener<ScrollStartNotification>(
              onNotification: (notification) {
                _onDismissSlidable();
                return false;
              },
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: CupertinoScrollbar(
                  child: ListView.separated(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      ContactItemType itemKey;
                      if (index > 0 && index <= itemKeys.length) {
                        itemKey = itemKeys.elementAt(index - 1);
                      }
                      Widget child = Container(
                        foregroundDecoration: BoxDecoration(
                          border: Border(
                            top: index == 0 ? BorderSide.none : borderSide,
                            bottom: borderSide,
                          ),
                        ),
                        child: children[index],
                      );
                      if (itemKey == ContactItemType.linkContact) {
                        child = WidgetGroup.spacing(
                          alignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          direction: Axis.vertical,
                          spacing: 6,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                '已链接的联系人',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CupertinoDynamicColor.resolve(
                                    CupertinoColors.secondaryLabel,
                                    context,
                                  ),
                                ),
                              ),
                            ),
                            child,
                          ],
                        );
                      }
                      return child;
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
