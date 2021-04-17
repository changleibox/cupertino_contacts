/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/presenter/all_labels_presenter.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/label_picker_widget.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/14.
///
/// 所有labels
const double _kLargeSpacing = 40;

class AllLabelsPage extends StatefulWidget {
  const AllLabelsPage({
    Key key,
    @required this.selectionType,
  })  : assert(selectionType != null),
        super(key: key);

  final SelectionType selectionType;

  @override
  _AllLabelsPageState createState() => _AllLabelsPageState();
}

class _AllLabelsPageState extends PresenterState<AllLabelsPage, AllLabelsPresenter> {
  _AllLabelsPageState() : super(AllLabelsPresenter());

  Widget _buildBody(BuildContext context, LabelPageStatus status) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: CupertinoScrollbar(
        child: ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: presenter.itemCount,
          itemBuilder: (context, index) {
            return SelectionGroupWidget(
              selections: presenter[index],
              selectedSelection: null,
              onItemPressed: presenter.onItemPressed,
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
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
