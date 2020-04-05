/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class SimpleTextSelectionOverlay {
  final BuildContext context;
  final LayerLink toolbarLayerLink;
  final RenderBox renderObject;
  final TextSelectionDelegate delegate;

  OverlayEntry _toolbar;

  SimpleTextSelectionOverlay({
    @required this.context,
    @required this.toolbarLayerLink,
    @required this.renderObject,
    @required this.delegate,
  })  : assert(context != null),
        assert(toolbarLayerLink != null),
        assert(renderObject != null),
        assert(delegate != null) {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    assert(
        overlay != null,
        'No Overlay widget exists above $context.\n'
        'Usually the Navigator created by WidgetsApp provides the overlay. Perhaps your '
        'app content was created above the Navigator with the WidgetsApp builder parameter.');
    _toolbarController = AnimationController(duration: fadeDuration, vsync: overlay);
  }

  bool get toolbarIsVisible => _toolbar != null;

  static const Duration fadeDuration = Duration(milliseconds: 150);

  AnimationController _toolbarController;

  Animation<double> get _toolbarOpacity => _toolbarController.view;

  void showToolbar() {
    _toolbar = OverlayEntry(builder: _buildToolbar);
    Overlay.of(context, rootOverlay: false).insert(_toolbar);
    _toolbarController.forward(from: 0.0);
  }

  void hideToolbar() {
    assert(_toolbar != null);
    _toolbarController.stop();
    _toolbar.remove();
    _toolbar = null;
  }

  void dispose() {
    hideToolbar();
    _toolbarController.dispose();
  }

  Widget _buildToolbar(BuildContext context) {
    final Rect editingRegion = Rect.fromPoints(
      renderObject.localToGlobal(Offset.zero),
      renderObject.localToGlobal(renderObject.size.bottomRight(Offset.zero)),
    );

    return FadeTransition(
      opacity: _toolbarOpacity,
      child: CompositedTransformFollower(
        link: toolbarLayerLink,
        showWhenUnlinked: false,
        offset: -editingRegion.topLeft,
        child: cupertinoTextSelectionControls.buildToolbar(
          context,
          editingRegion,
          0,
          Offset(editingRegion.width / 2, 0),
          [
            TextSelectionPoint(Offset(0, 0), Directionality.of(context)),
            TextSelectionPoint(Offset(0, 0), Directionality.of(context)),
          ],
          delegate,
        ),
      ),
    );
  }
}
