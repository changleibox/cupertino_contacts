/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/page/contact_detail_page.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/util/contact_utils.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contact/contact.dart';

const double _kHorizontalPadding = 16.0;

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
        labelColor,
        context,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: _kHorizontalPadding,
      ),
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: Text(
          index,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Contact> contacts) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoDynamicColor.resolve(
          itemColor,
          context,
        ),
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
      child: WidgetGroup.separated(
        alignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        direction: Axis.vertical,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          final names = ContactUtils.buildDisplayNameWidgets(contact);
          final hasSpacing = ContactUtils.hasSpacing(contact);
          return CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            borderRadius: BorderRadius.zero,
            child: Container(
              height: itemHeight,
              padding: EdgeInsets.symmetric(
                horizontal: _kHorizontalPadding,
              ),
              alignment: Alignment.centerLeft,
              child: DefaultTextStyle(
                style: CupertinoTheme.of(context).textTheme.textStyle,
                child: names.isEmpty
                    ? Text('无姓名')
                    : WidgetGroup.spacing(
                        alignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: hasSpacing ? 5 : 0,
                        children: names,
                      ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                RouteProvider.buildRoute(
                  ContactDetailPage(contact: contact),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            color: CupertinoDynamicColor.resolve(
              separatorColor,
              context,
            ),
            height: dividerHeight,
            margin: EdgeInsets.symmetric(
              horizontal: _kHorizontalPadding,
            ),
          );
        },
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
      divider: CupertinoDivider(
        height: dividerHeight,
      ),
      children: <Widget>[
        _buildIndex(context, index),
        ClipRect(
          child: Align(
            alignment: AlignmentDirectional(0.0, 1.0),
            heightFactor: 1.0 - (shrinkOffset / _contentHeight).clamp(0.0, 1.0),
            child: _buildContent(context, contacts),
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
