/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Created by box on 2020/4/2.
///
/// SlidableController
class PrimarySlidableController extends InheritedWidget {
  const PrimarySlidableController({
    Key key,
    @required this.controller,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  final SlidableController controller;

  static SlidableController of(BuildContext context) {
    final primarySlidableController = context.dependOnInheritedWidgetOfExactType<PrimarySlidableController>();
    return primarySlidableController?.controller;
  }

  @override
  bool updateShouldNotify(PrimarySlidableController oldWidget) {
    return controller != oldWidget.controller;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SlidableController>('controller', controller, ifNull: 'no controller', showName: false));
  }
}
