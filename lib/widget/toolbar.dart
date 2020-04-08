/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/text_selection_overlay.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2020/4/8.
///
/// 提供粘贴、复制、剪切、全选
class Toolbar extends StatefulWidget {
  final WidgetBuilder builder;
  final TextEditingValue value;
  final ToolbarOptions options;
  final ValueSetter<TextEditingValue> valueSetter;
  final ValueSetter<TextPosition> bringIntoView;

  const Toolbar({
    Key key,
    @required this.builder,
    @required this.value,
    this.options = const ToolbarOptions(
      copy: true,
      cut: true,
      paste: true,
      selectAll: true,
    ),
    this.valueSetter,
    this.bringIntoView,
  })  : assert(builder != null),
        assert(value != null),
        assert(options != null),
        super(key: key);

  @override
  ToolbarState createState() => ToolbarState();
}

class ToolbarState extends State<Toolbar> with AutomaticKeepAliveClientMixin<Toolbar> implements TextSelectionDelegate {
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
            FocusScope.of(context).unfocus();
            _focusScopeNode.unfocus();
          },
          onLongPress: () {
            showToolbar();
          },
          child: AnimatedOpacity(
            opacity: _focusScopeNode.hasFocus ? 0.4 : 1.0,
            duration: Duration(milliseconds: 150),
            child: widget.builder(context),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  TextEditingValue get textEditingValue => widget.value;

  @override
  void bringIntoView(TextPosition position) {
    if (widget.bringIntoView != null) {
      widget.bringIntoView(position);
    }
  }

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
  bool get copyEnabled => widget.options.copy;

  @override
  bool get cutEnabled => widget.options.cut;

  @override
  bool get pasteEnabled => widget.options.paste;

  @override
  bool get selectAllEnabled => widget.options.selectAll;

  @override
  set textEditingValue(TextEditingValue value) {
    if (widget.valueSetter != null) {
      widget.valueSetter(value);
    }
  }
}
