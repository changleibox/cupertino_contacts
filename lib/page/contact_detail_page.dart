/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/presenter/contact_detail_presenter.dart';
import 'package:cupertinocontacts/util/time_interval.dart';
import 'package:cupertinocontacts/widget/contact_detail_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/multi_line_text_field.dart';
import 'package:cupertinocontacts/widget/send_message_dialog.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/text_selection_overlay.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// Created by box on 2020/3/30.
///
/// 联系人详情
const double _kMaxAvatarSize = 80;
const double _kMinAvatarSize = 44;
const double _kMaxNameSize = 26;
const double _kMinNameSize = 17;

class ContactDetailPage extends StatefulWidget {
  final Contact contact;

  const ContactDetailPage({
    Key key,
    @required this.contact,
  })  : assert(contact != null),
        super(key: key);

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends PresenterState<ContactDetailPage, ContactDetailPresenter> {
  _ContactDetailPageState() : super(ContactDetailPresenter());

  @override
  Widget builds(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var actionTextStyle = textTheme.actionTextStyle;

    var phones = widget.contact.phones;
    var emails = widget.contact.emails;
    var postalAddresses = widget.contact.postalAddresses;

    final hasPhone = phones != null && phones.isNotEmpty;

    final children = List<Widget>();
    if (hasPhone) {
      children.addAll(phones.map((phone) {
        return _NormalGroupInfoWidget(
          name: phone.label,
          value: phone.value,
          valueColor: actionTextStyle.color,
          onPressed: () {
            launch('tel:${phone.value}');
          },
        );
      }));
    }
    if (emails != null && emails.isNotEmpty) {
      children.addAll(emails.map((email) {
        return _NormalGroupInfoWidget(
          name: email.label,
          value: email.value,
          valueColor: actionTextStyle.color,
          onPressed: () {
            launch('tel:${email.value}');
          },
        );
      }));
    }
    if (postalAddresses != null && postalAddresses.isNotEmpty) {
      children.addAll(postalAddresses.map((address) {
        final value = [
          address.street,
          address.region,
          address.city,
          address.postcode,
          address.country,
        ].join(' ');
        return _NormalGroupInfoWidget(
          name: address.label,
          value: value,
          trailing: Container(
            width: 80,
            height: 80,
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.tertiarySystemBackground,
              context,
            ),
            alignment: Alignment.center,
            child: Text('地图'),
          ),
          onPressed: () {
            launch('maps:${Uri.encodeComponent('$value')}');
          },
        );
      }));
    }
    if (widget.contact.birthday != null) {
      children.add(_NormalGroupInfoWidget(
        name: '生日',
        value: DateFormat('yyyy年MM月dd日').format(widget.contact.birthday),
        valueColor: actionTextStyle.color,
        onPressed: () {
          var birthday = widget.contact.birthday;
          var currentYear = DateTime.now().year;
          var currentYearBirthday = DateTime(currentYear, birthday.month, birthday.day);
          var timeIntervalSince = TimeInterval.timeIntervalSinceAsIOS(currentYearBirthday, isUtc: true);
          launch('calshow:${timeIntervalSince.toUtc().millisecondsSinceEpoch / 1000}');
        },
      ));
    }
    children.add(MultiLineTextField(
      controller: presenter.remarksController,
      name: '备注',
      minLines: 2,
      backgroundColor: CupertinoColors.secondarySystemBackground,
    ));
    if (hasPhone) {
      children.add(_NormalButton(
        text: '发送信息',
        onPressed: () {
          showSendMessageDialog(context, phones, emails);
        },
      ));
    }
    children.add(_NormalButton(
      text: '共享联系人',
      onPressed: () {
        launch('prefs:root=General&path=DATE_AND_TIME');
      },
    ));
    if (hasPhone) {
      children.add(_NormalButton(
        text: '添加到个人收藏',
        onPressed: () {},
      ));
      children.add(_NormalButton(
        text: '添加到紧急联系人',
        isDestructive: true,
        onPressed: () {},
      ));
      children.add(_NormalButton(
        text: '共享我的位置',
        onPressed: () {},
      ));
    }

    var persistentHeaderDelegate = ContactDetailPersistentHeaderDelegate(
      contact: widget.contact,
      maxAvatarSize: _kMaxAvatarSize,
      minAvatarSize: _kMinAvatarSize,
      maxNameSize: _kMaxNameSize,
      minNameSize: _kMinNameSize,
      paddingTop: MediaQuery.of(context).padding.top,
    );

    return CupertinoPageScaffold(
      child: SupportNestedScrollView(
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
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: CupertinoScrollbar(
            child: ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: children.length,
              itemBuilder: (context, index) {
                return children[index];
              },
              separatorBuilder: (context, index) {
                if (index == children.length - 2 && hasPhone) {
                  return SizedBox(
                    height: 40,
                  );
                }
                return Container(
                  color: CupertinoDynamicColor.resolve(
                    CupertinoColors.secondarySystemBackground,
                    context,
                  ),
                  padding: EdgeInsets.only(
                    left: 16,
                  ),
                  height: 1.0,
                  child: CupertinoDivider(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NormalGroupInfoWidget extends StatefulWidget {
  final String name;
  final String value;
  final Color valueColor;
  final Widget trailing;
  final VoidCallback onPressed;

  const _NormalGroupInfoWidget({
    Key key,
    @required this.name,
    @required this.value,
    this.valueColor,
    this.trailing,
    this.onPressed,
  })  : assert(name != null),
        super(key: key);

  @override
  _NormalGroupInfoWidgetState createState() => _NormalGroupInfoWidgetState();
}

class _NormalGroupInfoWidgetState extends State<_NormalGroupInfoWidget>
    with AutomaticKeepAliveClientMixin<_NormalGroupInfoWidget>
    implements TextSelectionDelegate {
  final LayerLink _toolbarLayerLink = LayerLink();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  SimpleTextSelectionOverlay _selectionOverlay;

  @override
  void dispose() {
    _selectionOverlay?.dispose();
    _selectionOverlay = null;
    _focusScopeNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var textStyle = CupertinoTheme.of(context).textTheme.textStyle;
    return FocusScope(
      node: _focusScopeNode,
      onFocusChange: (value) {
        if (!value) {
          hideToolbar();
        }
        setState(() {});
      },
      child: CompositedTransformTarget(
        link: _toolbarLayerLink,
        child: GestureDetector(
          onTapDown: (details) {
            var focusScopeNode = FocusScope.of(context);
            if (focusScopeNode != _focusScopeNode) {
              focusScopeNode.unfocus();
            }
          },
          onLongPress: () {
            showToolbar();
          },
          child: AnimatedOpacity(
            opacity: _focusScopeNode.hasFocus ? 0.4 : 1.0,
            duration: Duration(milliseconds: 150),
            child: CupertinoButton(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.secondarySystemBackground,
                context,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              borderRadius: BorderRadius.zero,
              minSize: 0,
              onPressed: () {
                hideToolbar();
                FocusScope.of(context).unfocus();
                if (widget.onPressed != null) {
                  widget.onPressed();
                }
              },
              child: WidgetGroup.spacing(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 80,
                children: <Widget>[
                  Expanded(
                    child: WidgetGroup.spacing(
                      alignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      direction: Axis.vertical,
                      children: [
                        Text(
                          widget.name,
                          style: textStyle.copyWith(
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          widget.value ?? '暂无',
                          style: textStyle.copyWith(
                            color: widget.valueColor ?? textStyle.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.trailing != null) widget.trailing,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  TextEditingValue get textEditingValue {
    return TextEditingValue(
      text: widget.value,
      selection: TextSelection(
        baseOffset: 0,
        extentOffset: widget.value.length,
      ),
    );
  }

  @override
  void bringIntoView(TextPosition position) {}

  /// Toggles the visibility of the toolbar.
  void toggleToolbar() {
    assert(_selectionOverlay != null);
    if (_selectionOverlay.toolbarIsVisible) {
      hideToolbar();
    } else {
      showToolbar();
    }
  }

  void showToolbar() {
    _selectionOverlay?.hideToolbar();
    _selectionOverlay = null;

    _selectionOverlay = SimpleTextSelectionOverlay(
      context: context,
      toolbarLayerLink: _toolbarLayerLink,
      renderObject: context.findRenderObject(),
      delegate: this,
    );
    _selectionOverlay.showToolbar();

    _focusScopeNode.requestFocus();
  }

  @override
  void hideToolbar() {
    _selectionOverlay?.hideToolbar();
    _selectionOverlay = null;
    if (_focusScopeNode.hasFocus) {
      _focusScopeNode.unfocus();
    }
  }

  @override
  bool get copyEnabled => true;

  @override
  bool get cutEnabled => false;

  @override
  bool get pasteEnabled => false;

  @override
  bool get selectAllEnabled => false;

  @override
  set textEditingValue(TextEditingValue value) {}
}

class _NormalButton extends StatelessWidget {
  final String text;
  final bool isDestructive;
  final VoidCallback onPressed;

  const _NormalButton({
    Key key,
    @required this.text,
    this.isDestructive = false,
    this.onPressed,
  })  : assert(text != null),
        assert(isDestructive != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var actionTextStyle = textTheme.actionTextStyle;
    if (isDestructive) {
      actionTextStyle = actionTextStyle.copyWith(
        color: CupertinoColors.destructiveRed,
      );
    }
    return CupertinoButton(
      minSize: 44,
      padding: EdgeInsets.only(
        left: 16,
        right: 10,
      ),
      borderRadius: BorderRadius.zero,
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemBackground,
        context,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: actionTextStyle,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
