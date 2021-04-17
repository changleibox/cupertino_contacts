/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/enums/contact_launch_mode.dart';
import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/page/contact_detail_page.dart';
import 'package:cupertinocontacts/page/cupertino_contacts_page.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/contact_info_group_widget.dart';
import 'package:cupertinocontacts/widget/selection_info_group_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';

/// Created by box on 2020/4/10.
///
/// 链接联系人
class EditContactLinkContactInfoGroup extends StatelessWidget {
  const EditContactLinkContactInfoGroup({
    Key key,
    @required this.infoGroup,
    @required this.currentContact,
  })  : assert(infoGroup != null),
        super(key: key);

  final ContactInfoGroup<ContactSelectionItem> infoGroup;
  final Contact currentContact;

  @override
  Widget build(BuildContext context) {
    return ContactInfoGroupWidget(
      infoGroup: infoGroup,
      addButtonText: infoGroup.name,
      changeLabelInterceptor: (context, item) => ChangeLabelType.disable,
      itemFactory: (index, label) async {
        final selectedContactIds = <String>[];
        final currentIdentifier = currentContact?.identifier;
        if (currentIdentifier != null) {
          selectedContactIds.add(currentIdentifier);
        }
        selectedContactIds.addAll(infoGroup.value.map((e) => e.value.identifier));
        final contact = await Navigator.push<Contact>(
          context,
          RouteProvider.buildRoute(
            CupertinoContactsPage(
              launchMode: HomeLaunchMode.selection,
              selectedIds: selectedContactIds,
            ),
            fullscreenDialog: true,
          ),
        );
        return contact == null ? null : ContactSelectionItem(label: label, value: contact);
      },
      itemBuilder: (context, item) {
        final contact = (item as ContactSelectionItem).value;
        return SelectionInfoGroupItem(
          item: item,
          hasStartDivier: false,
          valueGetter: () {
            return contact?.displayName;
          },
          onPressed: () {
            if (contact == null) {
              return;
            }
            Navigator.push<void>(
              context,
              RouteProvider.buildRoute(
                ContactDetailPage(
                  identifier: contact.identifier,
                  contact: contact,
                  launchMode: DetailLaunchMode.editView,
                ),
                title: item.label.labelName,
              ),
            );
          },
        );
      },
    );
  }
}
