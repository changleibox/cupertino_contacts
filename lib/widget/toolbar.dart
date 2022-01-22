/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:math';

import 'package:cupertinocontacts/widget/text_selection_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// [TextSelectionDelegate.userUpdateTextEditingValue]
typedef UserUpdateTextEditingValue = void Function(TextEditingValue value, SelectionChangedCause cause);

/// Created by box on 2020/4/8.
///
/// 提供粘贴、复制、剪切、全选
class Toolbar extends StatefulWidget {
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
    this.setTextEditingValue,
    this.userUpdateTextEditingValue,
    this.bringIntoView,
  })  : assert(builder != null),
        assert(value != null),
        assert(options != null),
        super(key: key);

  final WidgetBuilder builder;
  final TextEditingValue value;
  final ToolbarOptions options;
  final ValueSetter<TextEditingValue> setTextEditingValue;
  final UserUpdateTextEditingValue userUpdateTextEditingValue;
  final ValueSetter<TextPosition> bringIntoView;

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
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) {
            _focusScopeNode.unfocus();
            FocusScope.of(context).unfocus();
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPress: () {
              showToolbar();
            },
            child: AnimatedOpacity(
              opacity: isShowing ? 0.4 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: widget.builder(context),
            ),
          ),
        ),
      ),
    );
  }

  bool get isShowing => _focusScopeNode.hasFocus && (_selectionOverlay?.toolbarIsVisible ?? false) && isEnabled;

  bool get isEnabled => widget.options.cut || widget.options.paste || widget.options.copy || widget.options.selectAll;

  @override
  bool get wantKeepAlive => _focusScopeNode.hasFocus;

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
    if (!isEnabled) {
      return;
    }

    _selectionOverlay?.hideToolbar();
    _selectionOverlay = null;

    _selectionOverlay = SimpleTextSelectionOverlay(
      context: context,
      toolbarLayerLink: _toolbarLayerLink,
      renderObject: context.findRenderObject() as RenderBox,
      delegate: this,
    );
    _selectionOverlay.showToolbar();

    _focusScopeNode.requestFocus();
  }

  @override
  void hideToolbar([bool hideHandles = true]) {
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
    if (widget.setTextEditingValue != null) {
      widget.setTextEditingValue(value);
    }
  }

  @override
  void userUpdateTextEditingValue(TextEditingValue value, SelectionChangedCause cause) {
    if (widget.userUpdateTextEditingValue != null) {
      widget.userUpdateTextEditingValue(value, cause);
    }
  }

  @override
  void copySelection(SelectionChangedCause cause) {
    final selection = textEditingValue.selection;
    final text = textEditingValue.text;
    assert(selection != null);
    if (selection.isCollapsed || !selection.isValid) {
      return;
    }
    Clipboard.setData(ClipboardData(text: selection.textInside(text)));

    bringIntoView(textEditingValue.selection.extent);
    hideToolbar(false);

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        break;
      case TargetPlatform.macOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        // Collapse the selection and hide the toolbar and handles.
        userUpdateTextEditingValue(
          TextEditingValue(
            text: textEditingValue.text,
            selection: TextSelection.collapsed(offset: textEditingValue.selection.end),
          ),
          SelectionChangedCause.toolbar,
        );
        break;
    }
  }

  @override
  void cutSelection(SelectionChangedCause cause) {
    final selection = textEditingValue.selection;
    if (!selection.isValid) {
      return;
    }
    final text = textEditingValue.text;
    assert(selection != null);
    if (selection.isCollapsed) {
      return;
    }
    Clipboard.setData(ClipboardData(text: selection.textInside(text)));
    setTextEditingValue(
      TextEditingValue(
        text: selection.textBefore(text) + selection.textAfter(text),
        selection: TextSelection.collapsed(
          offset: min(selection.start, selection.end),
          affinity: selection.affinity,
        ),
      ),
      cause,
    );

    bringIntoView(textEditingValue.selection.extent);
    hideToolbar();
  }

  @override
  Future<void> pasteText(SelectionChangedCause cause) async {
    final selection = textEditingValue.selection;
    if (!selection.isValid) {
      return;
    }
    final text = textEditingValue.text;
    assert(selection != null);
    if (!selection.isValid) {
      return;
    }
    // Snapshot the input before using `await`.
    // See https://github.com/flutter/flutter/issues/11427
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data == null) {
      return;
    }
    setTextEditingValue(
      TextEditingValue(
        text: selection.textBefore(text) + data.text + selection.textAfter(text),
        selection: TextSelection.collapsed(
          offset: min(selection.start, selection.end) + data.text.length,
          affinity: selection.affinity,
        ),
      ),
      cause,
    );

    bringIntoView(textEditingValue.selection.extent);
    hideToolbar();
  }

  @override
  void selectAll(SelectionChangedCause cause) {
    setSelection(
      textEditingValue.selection.copyWith(
        baseOffset: 0,
        extentOffset: textEditingValue.text.length,
      ),
      cause,
    );

    bringIntoView(textEditingValue.selection.extent);
  }

  /// {@macro flutter.widgets.TextEditingActionTarget.setTextEditingValue}
  void setTextEditingValue(TextEditingValue newValue, SelectionChangedCause cause) {
    if (newValue == textEditingValue) {
      return;
    }
    textEditingValue = newValue;
    userUpdateTextEditingValue(newValue, cause);
  }

  /// {@template flutter.widgets.TextEditingActionTarget.setSelection}
  /// Called to update the [TextSelection] in the current [TextEditingValue].
  /// {@endtemplate}
  void setSelection(TextSelection nextSelection, SelectionChangedCause cause) {
    if (nextSelection == textEditingValue.selection) {
      return;
    }
    setTextEditingValue(
      textEditingValue.copyWith(selection: nextSelection),
      cause,
    );
  }
}
