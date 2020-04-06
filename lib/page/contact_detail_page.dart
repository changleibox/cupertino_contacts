/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:contacts_service/contacts_service.dart';
import 'package:cupertinocontacts/presenter/contact_detail_presenter.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/add_contact_remarks_text_field.dart';
import 'package:cupertinocontacts/widget/contact_detail_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/text_selection_overlay.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

/// Created by box on 2020/3/30.
///
/// 联系人详情
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
    var textStyle = textTheme.textStyle;

    var phones = widget.contact.phones;
    var emails = widget.contact.emails;
    var postalAddresses = widget.contact.postalAddresses;

    final children = List<Widget>();
    if (phones != null && phones.isNotEmpty) {
      children.addAll(phones.map((phone) {
        return _NormalGroupInfoWidget(
          name: phone.label,
          value: phone.value,
          valueColor: actionTextStyle.color,
          onPressed: () {},
        );
      }));
    }
    if (emails != null && emails.isNotEmpty) {
      children.addAll(emails.map((email) {
        return _NormalGroupInfoWidget(
          name: email.label,
          value: email.value,
          valueColor: actionTextStyle.color,
          onPressed: () {},
        );
      }));
    }
    if (postalAddresses != null && postalAddresses.isNotEmpty) {
      children.addAll(postalAddresses.map((address) {
        return _NormalGroupInfoWidget(
          name: address.label,
          value: [
            address.street,
            address.region,
            address.city,
            address.postcode,
            address.country,
          ].join(' '),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Container(
              width: 80,
              height: 80,
              foregroundDecoration: FlutterLogoDecoration(),
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.systemBackground,
                context,
              ),
            ),
            onPressed: () {},
          ),
          onPressed: () {},
        );
      }));
    }
    if (widget.contact.birthday != null) {
      children.add(_NormalGroupInfoWidget(
        name: '生日',
        value: widget.contact.birthday.toString(),
        valueColor: actionTextStyle.color,
        onPressed: () {},
      ));
    }
    children.add(AddContactRemarksTextField(
      info: presenter.remarksInfo,
      minLines: 2,
    ));
    children.add(_NormalButton(
      text: '发送信息',
    ));
    children.add(_NormalButton(
      text: '共享联系人',
    ));
    children.add(_NormalButton(
      text: '添加到个人收藏',
    ));
    children.add(_NormalButton(
      text: '添加到紧急联系人',
    ));
    children.add(_NormalButton(
      text: '共享我的位置',
    ));

    return CupertinoPageScaffold(
      child: SupportNestedScrollView(
        pinnedHeaderSliverHeightBuilder: (context) {
          return 198;
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverPersistentHeader(
              pinned: true,
              delegate: ContactDetailPersistentHeaderDelegate(
                contact: widget.contact,
                maxAvatarSize: 80,
                minAvatarSize: 44,
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
          child: MediaQuery.removePadding(
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
                  if (index == children.length - 2) {
                    return SizedBox(
                      height: 40,
                    );
                  }
                  return CupertinoDivider(
                    color: separatorColor.withOpacity(0.1),
                  );
                },
              ),
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
            _focusScopeNode.requestFocus();
          },
          onLongPress: () {
            showToolbar();
          },
          child: AnimatedOpacity(
            opacity: _focusScopeNode.hasFocus ? 0.4 : 1.0,
            duration: Duration(milliseconds: 150),
            child: CupertinoButton(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.tertiarySystemBackground,
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
                          style: textStyle,
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

  const _NormalButton({
    Key key,
    @required this.text,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    return CupertinoButton(
      minSize: 44,
      padding: EdgeInsets.only(
        left: 16,
        right: 10,
      ),
      borderRadius: BorderRadius.zero,
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemBackground,
        context,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: textTheme.actionTextStyle.copyWith(
            fontSize: 15,
          ),
        ),
      ),
      onPressed: () {},
    );
  }
}
