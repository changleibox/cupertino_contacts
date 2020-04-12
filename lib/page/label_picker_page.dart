/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/model/selection.dart';
import 'package:cupertinocontacts/presenter/label_picker_presenter.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/animated_color_widget.dart';
import 'package:cupertinocontacts/widget/cupertino_divider.dart';
import 'package:cupertinocontacts/widget/framework.dart';
import 'package:cupertinocontacts/widget/label_picker_persistent_header_delegate.dart';
import 'package:cupertinocontacts/widget/sliver_list_view.dart';
import 'package:cupertinocontacts/widget/snapping_scroll_physics.dart';
import 'package:cupertinocontacts/widget/support_nested_scroll_view.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

/// Created by box on 2020/4/11.
///
/// 选择标签
const double _kSearchBarHeight = 56.0;
const double _kNavigationBarHeight = 44.0;

class LabelPickerPage extends StatefulWidget {
  final List<Selection> selections;
  final Selection selectedSelection;

  const LabelPickerPage({
    Key key,
    @required this.selections,
    @required this.selectedSelection,
  })  : assert(selections != null && selections.length > 0),
        super(key: key);

  @override
  _LabelPickerPageState createState() => _LabelPickerPageState();
}

class _LabelPickerPageState extends PresenterState<LabelPickerPage, LabelPickerPresenter> {
  _LabelPickerPageState() : super(LabelPickerPresenter());

  ColorTween _colorTween;
  ScrollController _scrollController;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController?.jumpTo(_kSearchBarHeight);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _colorTween = ColorTween(
      begin: CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground,
        context,
      ),
      end: CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemGroupedBackground,
        context,
      ),
    );
    super.didChangeDependencies();
  }

  List<Widget> _buildHeaderSliver(BuildContext context, bool innerBoxIsScrolled) {
    _scrollController = PrimaryScrollController.of(context);
    return [
      _AnimatedCupertinoSliverNavigationBar(
        colorTween: _colorTween,
        onEditPressed: () {},
        onQuery: presenter.onQuery,
      ),
    ];
  }

  @override
  Widget builds(BuildContext context) {
    return CupertinoPageScaffold(
      child: SupportNestedScrollView(
        pinnedHeaderSliverHeightBuilder: (context) {
          return _kNavigationBarHeight + MediaQuery.of(context).padding.top;
        },
        headerSliverBuilder: _buildHeaderSliver,
        physics: SnappingScrollPhysics(
          midScrollOffset: _kSearchBarHeight,
        ),
        body: CustomScrollView(
          slivers: [
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: _SelectionGroupWidget(
                selections: presenter.objects,
                selectedSelection: widget.selectedSelection,
                onItemPressed: (value) {
                  Navigator.pop(context, value);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
              ),
            ),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: _SelectionGroupWidget(
                selections: presenter.customSelections,
                selectedSelection: widget.selectedSelection,
                onItemPressed: (value) {
                  if (value == selections.addCustomSelection) {
                    // TODO 添加自定义标签
                  } else {
                    Navigator.pop(context, value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedCupertinoSliverNavigationBar extends AnimatedColorWidget {
  final VoidCallback onEditPressed;
  final ValueChanged<String> onQuery;

  const _AnimatedCupertinoSliverNavigationBar({
    Key key,
    @required ColorTween colorTween,
    this.onEditPressed,
    this.onQuery,
  }) : super(key: key, colorTween: colorTween);

  @override
  Widget evaluateBuild(BuildContext context, Color color) {
    final paddingTop = MediaQuery.of(context).padding.top;
    return SliverPersistentHeader(
      pinned: true,
      delegate: LabelPickePersistentHeaderDelegate(
        paddingTop: paddingTop,
        navigationBarHeight: _kNavigationBarHeight,
        searchBarHeight: _kSearchBarHeight,
        backgroundColor: color,
        onEditPressed: onEditPressed,
        onQuery: onQuery,
      ),
    );
  }
}

class _SelectionGroupWidget extends StatelessWidget {
  final List<Selection> selections;
  final Selection selectedSelection;
  final ValueChanged<Selection> onItemPressed;

  const _SelectionGroupWidget({
    Key key,
    @required this.selections,
    @required this.selectedSelection,
    this.onItemPressed,
  })  : assert(selections != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var length = selections.length;
    return SliverListView.separated(
      itemCount: length,
      itemBuilder: (context, index) {
        var selection = selections[index];
        return _SelectionItemWidget(
          selection: selection,
          isFirst: index == 0,
          isLast: index == length - 1,
          selected: selection == selectedSelection,
          onPressed: () {
            if (onItemPressed != null) {
              onItemPressed(selection);
            }
          },
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.secondarySystemGroupedBackground,
            context,
          ),
          padding: EdgeInsets.only(
            left: 16,
          ),
          child: CupertinoDivider(),
        );
      },
    );
  }
}

class _SelectionItemWidget extends StatelessWidget {
  final Selection selection;
  final bool isFirst;
  final bool isLast;
  final bool selected;
  final VoidCallback onPressed;

  const _SelectionItemWidget({
    Key key,
    @required this.selection,
    @required this.isFirst,
    @required this.isLast,
    this.selected = false,
    this.onPressed,
  })  : assert(selection != null),
        assert(isFirst != null),
        assert(isLast != null),
        assert(selected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = CupertinoTheme.of(context);
    var textTheme = themeData.textTheme;
    var textStyle = textTheme.textStyle;

    var borderSide = BorderSide(
      color: CupertinoDynamicColor.resolve(
        separatorColor,
        context,
      ),
      width: 0.0,
    );

    return Container(
      foregroundDecoration: BoxDecoration(
        border: Border(
          top: isFirst ? borderSide : BorderSide.none,
          bottom: isLast ? borderSide : BorderSide.none,
        ),
      ),
      child: CupertinoButton(
        child: Align(
          alignment: Alignment.centerLeft,
          child: WidgetGroup.spacing(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selection.labelName,
                  style: textStyle,
                ),
              ),
              if (selection != selections.addCustomSelection && selected)
                Icon(
                  CupertinoIcons.check_mark,
                  size: 40,
                  color: themeData.primaryColor,
                ),
            ],
          ),
        ),
        padding: EdgeInsets.only(
          left: 16,
          right: 8,
        ),
        borderRadius: BorderRadius.zero,
        color: CupertinoColors.secondarySystemGroupedBackground,
        onPressed: onPressed,
      ),
    );
  }
}
