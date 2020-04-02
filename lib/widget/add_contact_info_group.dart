/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/contact_info_group.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/add_contact_info_button.dart';
import 'package:cupertinocontacts/widget/add_contact_info_text_field.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/primary_slidable_controller.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Created by box on 2020/3/31.
///
/// 添加联系人-信息组
class AddContactInfoGroup extends StatefulWidget {
  final ContactInfoGroup infoGroup;

  const AddContactInfoGroup({
    Key key,
    @required this.infoGroup,
  })  : assert(infoGroup != null),
        super(key: key);

  @override
  _AddContactInfoGroupState createState() => _AddContactInfoGroupState();
}

class _AddContactInfoGroupState extends State<AddContactInfoGroup> {
  final _animatedListKey = GlobalKey<AnimatedListState>();
  final _globalKeys = List<GlobalKey<SlidableState>>();

  SlidableController _slidableController;

  @override
  void initState() {
    widget.infoGroup.value.forEach((element) {
      _globalKeys.add(GlobalKey());
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _slidableController = PrimarySlidableController.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _slidableController?.activeState = null;
    super.dispose();
  }

  Widget _buildItemAsItem(EditableItem item, Animation<double> animation, {VoidCallback onDeletePressed}) {
    var items = widget.infoGroup.value;
    var index = items.indexOf(item);
    return Slidable.builder(
      controller: _slidableController,
      key: index < 0 ? null : _globalKeys[index],
      closeOnScroll: false,
      actionPane: SlidableScrollActionPane(),
      secondaryActionDelegate: SlideActionListDelegate(
        actions: [
          SlideAction(
            child: Text(
              '删除',
              style: CupertinoTheme.of(context).textTheme.textStyle,
            ),
            closeOnTap: true,
            color: CupertinoColors.destructiveRed,
            onTap: () {
              widget.infoGroup.removeAt(index);
              _globalKeys.removeAt(index);
              _animatedListKey.currentState.removeItem(index, (context, animation) {
                return _buildItemAsItem(item, animation);
              });
            },
          ),
        ],
      ),
      child: Container(
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: separatorColor.withOpacity(0.1),
              width: 0.5,
              style: items.indexOf(item) == items.length - 1 ? BorderStyle.none : BorderStyle.solid,
            ),
          ),
        ),
        margin: EdgeInsets.only(
          left: 16,
          right: 10,
        ),
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1.0,
          child: AddContactInfoTextField(
            name: widget.infoGroup.name,
            item: item,
            onDeletePressed: onDeletePressed,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index, Animation<double> animation) {
    var items = widget.infoGroup.value;
    var item = items[index];
    return _buildItemAsItem(
      item,
      animation,
      onDeletePressed: () {
        _onRemovePressed(index);
      },
    );
  }

  _onAddPressed() {
    var length = widget.infoGroup.value.length;
    var selections = widget.infoGroup.selections;
    widget.infoGroup.add(EditableItem(
      label: selections[length % selections.length],
    ));
    _globalKeys.add(GlobalKey());
    _animatedListKey.currentState.insertItem(length);
  }

  _onRemovePressed(int index) {
    var currentState = _globalKeys[index].currentState;
    if (currentState == null) {
      return;
    }
    currentState.open(actionType: SlideActionType.secondary);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemBackground,
        context,
      ),
      child: WidgetGroup(
        alignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        direction: Axis.vertical,
        divider: Padding(
          padding: const EdgeInsets.only(
            left: 16,
          ),
          child: CupertinoDivider(
            color: separatorColor.withOpacity(0.1),
          ),
        ),
        children: <Widget>[
          AnimatedList(
            key: _animatedListKey,
            initialItemCount: widget.infoGroup.value.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index, animation) {
              return _buildItem(index, animation);
            },
          ),
          AddContactInfoButton(
            text: '添加${widget.infoGroup.name}',
            onPressed: _onAddPressed,
          ),
        ],
      ),
    );
  }
}
