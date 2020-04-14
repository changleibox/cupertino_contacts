/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/presenter/all_labels_presenter.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/label_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Created by box on 2020/4/14.
///
/// 所有labels
const double _kLargeSpacing = 40;
const int _kEveryGroupCount = 58;

class AllLabelsPage extends StatefulWidget {
  final SelectionType selectionType;

  const AllLabelsPage({
    Key key,
    @required this.selectionType,
  })  : assert(selectionType != null),
        super(key: key);

  @override
  _AllLabelsPageState createState() => _AllLabelsPageState();
}

class _AllLabelsPageState extends PresenterState<AllLabelsPage, AllLabelsPresenter> with SingleTickerProviderStateMixin {
  _AllLabelsPageState() : super(AllLabelsPresenter());

  Widget _buildBody(BuildContext context, LabelPageStatus status, FocusNode queryFoucsNode) {
    var selections = presenter.objects.toList();
    var length = selections.length;
    var groupCount = length ~/ _kEveryGroupCount + 1;
    final children = List<Widget>();
    List.generate(groupCount, (index) {
      var start = index * _kEveryGroupCount;
      var end = min((index + 1) * _kEveryGroupCount, length);
      children.add(SelectionGroupWidget(
        selections: selections.getRange(start, end),
        selectedSelection: null,
        onItemPressed: presenter.onItemPressed,
      ));
    });
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: CupertinoScrollbar(
        child: ListView.separated(
          itemCount: children.length,
          itemBuilder: (context, index) {
            return children[index];
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: _kLargeSpacing,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget builds(BuildContext context) {
    return CupertinoPageScaffold(
      child: AnimatedLabelPickerHeaderBody(
        onQuery: presenter.onQuery,
        builder: _buildBody,
      ),
    );
  }
}
