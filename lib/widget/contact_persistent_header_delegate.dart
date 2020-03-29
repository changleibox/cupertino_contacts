/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/contact_item_widget.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';

class ContactPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final MapEntry<String, List<Contact>> contactEntry;
  final double indexHeight;
  final double dividerHeight;
  final double itemHeight;

  const ContactPersistentHeaderDelegate({
    @required this.contactEntry,
    @required this.indexHeight,
    @required this.dividerHeight,
    @required this.itemHeight,
  })  : assert(contactEntry != null),
        assert(indexHeight != null),
        assert(dividerHeight != null),
        assert(itemHeight != null);

  Widget _buildIndex(BuildContext context, String index) {
    return Container(
      height: indexHeight,
      alignment: Alignment.centerLeft,
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemGroupedBackground,
        context,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Text(
        index,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.label,
            context,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var index = contactEntry.key;
    var contacts = contactEntry.value;
    return WidgetGroup(
      alignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      direction: Axis.vertical,
      divider: Container(
        color: CupertinoDynamicColor.resolve(
          separatorColor,
          context,
        ),
        height: dividerHeight,
      ),
      children: <Widget>[
        _buildIndex(context, index),
        ClipRect(
          child: Align(
            alignment: AlignmentDirectional(0.0, 1.0),
            heightFactor: 1.0 - (shrinkOffset / _contentHeight).clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: dividerHeight,
                    color: CupertinoDynamicColor.resolve(
                      separatorColor,
                      context,
                    ),
                  ),
                ),
              ),
              child: Container(
                color: CupertinoDynamicColor.resolve(
                  headerColor,
                  context,
                ),
                child: WidgetGroup.separated(
                  alignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  direction: Axis.vertical,
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return ContactItemWidget(
                      contact: contact,
                      height: itemHeight,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      color: separatorColor,
                      height: dividerHeight,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int get _contactCount => contactEntry.value.length;

  double get _contentHeight => (itemHeight + dividerHeight) * _contactCount;

  @override
  double get maxExtent => minExtent + _contentHeight;

  @override
  double get minExtent => indexHeight + dividerHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
