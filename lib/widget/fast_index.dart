/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

/// Created by box on 2020/2/26.
///
/// 快速索引
const Duration _duration = Duration(milliseconds: 200);
const Color _containerColor = CupertinoColors.tertiarySystemGroupedBackground;

typedef _FastIndexPositionGetter = FastIndexPosition Function(int index);

class FastIndexNotification extends Notification {
  final FastIndexDetails details;

  const FastIndexNotification({@required this.details}) : assert(details != null);

  @override
  bool operator ==(Object other) => identical(this, other) || other is FastIndexNotification && runtimeType == other.runtimeType && details == other.details;

  @override
  int get hashCode => details.hashCode;

  @protected
  @override
  void debugFillDescription(List<String> description) {
    super.debugFillDescription(description);
    description.add('$details');
  }
}

class IndexChangedNotification extends Notification {
  final int index;

  const IndexChangedNotification({@required this.index}) : assert(index != null);

  @override
  bool operator ==(Object other) => identical(this, other) || other is IndexChangedNotification && runtimeType == other.runtimeType && index == other.index;

  @override
  int get hashCode => index.hashCode;

  @protected
  @override
  void debugFillDescription(List<String> description) {
    super.debugFillDescription(description);
    description.add('$index');
  }
}

class FastIndexPosition with Diagnosticable {
  final Rect globalRect;
  final Rect localRect;
  final Offset globalPosition;
  final Offset localPosition;
  final Offset containerGlobalPosition;
  final Offset containerLocalPosition;

  const FastIndexPosition({
    @required this.globalRect,
    @required this.localRect,
    @required this.globalPosition,
    @required this.localPosition,
    @required this.containerGlobalPosition,
    @required this.containerLocalPosition,
  })  : assert(globalRect != null),
        assert(localRect != null),
        assert(globalPosition != null),
        assert(localPosition != null),
        assert(containerGlobalPosition != null),
        assert(containerLocalPosition != null);

  FastIndexPosition copyWith({
    Rect globalRect,
    Rect localRect,
    Offset globalPosition,
    Offset localPosition,
    Offset containerGlobalPosition,
    Offset containerLocalPosition,
  }) {
    return FastIndexPosition(
      globalRect: globalRect ?? this.globalRect,
      localRect: localRect ?? this.localRect,
      globalPosition: globalPosition ?? this.globalPosition,
      localPosition: localPosition ?? this.localPosition,
      containerGlobalPosition: containerGlobalPosition ?? this.containerGlobalPosition,
      containerLocalPosition: containerLocalPosition ?? this.containerLocalPosition,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FastIndexPosition &&
          runtimeType == other.runtimeType &&
          globalRect == other.globalRect &&
          localRect == other.localRect &&
          globalPosition == other.globalPosition &&
          localPosition == other.localPosition &&
          containerGlobalPosition == other.containerGlobalPosition &&
          containerLocalPosition == other.containerLocalPosition;

  @override
  int get hashCode =>
      globalRect.hashCode ^
      localRect.hashCode ^
      globalPosition.hashCode ^
      localPosition.hashCode ^
      containerGlobalPosition.hashCode ^
      containerLocalPosition.hashCode;

  @protected
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Rect>('globalRect', globalRect));
    properties.add(DiagnosticsProperty<Rect>('localRect', localRect));
    properties.add(DiagnosticsProperty<Offset>('globalPosition', globalPosition));
    properties.add(DiagnosticsProperty<Offset>('localPosition', localPosition));
    properties.add(DiagnosticsProperty<Offset>('containerGlobalPosition', containerGlobalPosition));
    properties.add(DiagnosticsProperty<Offset>('containerLocalPosition', containerLocalPosition));
  }
}

class FastIndexDetails with Diagnosticable {
  static const FastIndexDetails empty = FastIndexDetails();

  final int index;
  final FastIndexPosition position;

  const FastIndexDetails({
    this.index = -1,
    this.position,
  })  : assert(index != null),
        assert(index >= 0 || position == null);

  bool get isValid => index >= 0 && position != null;

  FastIndexDetails copyWith({
    int index,
    FastIndexPosition position,
  }) {
    return FastIndexDetails(
      index: index ?? this.index,
      position: position ?? this.position,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FastIndexDetails && runtimeType == other.runtimeType && index == other.index && position == other.position;

  @override
  int get hashCode => index.hashCode ^ position.hashCode;

  @protected
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', index));
    properties.add(DiagnosticsProperty<FastIndexPosition>(
      'position',
      position,
      ifNull: 'inactive',
    ));
  }
}

class FastIndexController extends ChangeNotifier implements ValueListenable<FastIndexDetails> {
  FastIndexDetails _details = FastIndexDetails.empty;
  _FastIndexPositionGetter _positionGetter;

  bool get isBind => _positionGetter != null;

  int get index => _details.index;

  set index(int newIndex) {
    assert(isBind, 'Not binded to FastIndex.');
    _value = _details.copyWith(
      index: newIndex,
      position: _positionGetter == null ? null : _positionGetter(newIndex),
    );
  }

  FastIndexPosition get position => _details.position;

  @override
  FastIndexDetails get value => _details;

  set _value(FastIndexDetails newValue) {
    assert(newValue != null);
    if (_details == newValue) {
      return;
    }
    _details = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

class FastIndex extends StatefulWidget {
  final FastIndexController controller;
  final List<String> indexs;

  const FastIndex({
    Key key,
    this.controller,
    @required this.indexs,
  })  : assert(indexs != null),
        super(key: key);

  @override
  _FastIndexState createState() => _FastIndexState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FastIndexController>('controller', controller));
    properties.add(IterableProperty('indexs', indexs));
  }
}

class _FastIndexState extends State<FastIndex> {
  final _indexKeys = List<GlobalKey>();

  Color _color;
  FastIndexDetails _currentDetails = FastIndexDetails.empty;

  _onVerticalDragDown(DragDownDetails details) {
    _callback(_analysisIndex(details.globalPosition));
  }

  _onVerticalDragStart(DragStartDetails details) {
    _callback(_analysisIndex(details.globalPosition));
  }

  _onVerticalDragUpdate(DragUpdateDetails details) {
    _callback(_analysisIndex(details.globalPosition));
  }

  _onVerticalDragEnd(DragEndDetails details) {
    _callback(FastIndexDetails.empty);
  }

  _onVerticalDragCancel() {
    _callback(FastIndexDetails.empty);
  }

  FastIndexPosition _analysisIndexPosition(int index) {
    if (index < 0 || index >= _indexKeys.length) {
      return null;
    }
    final key = _indexKeys[index];
    var renderBox = key.currentContext?.findRenderObject() as RenderBox;
    if (renderBox == null || !renderBox.hasSize) {
      return null;
    }
    final currentRenderBox = context.findRenderObject() as RenderBox;
    final currentGlobalPosition = currentRenderBox.localToGlobal(Offset.zero);
    final currentLocalPosition = currentRenderBox.localToGlobal(Offset.zero, ancestor: currentRenderBox.parent);
    final globalPosition = renderBox.localToGlobal(Offset.zero);
    final localPosition = renderBox.localToGlobal(Offset.zero, ancestor: currentRenderBox);
    return FastIndexPosition(
      globalRect: globalPosition & renderBox.size,
      localRect: localPosition & renderBox.size,
      globalPosition: globalPosition,
      localPosition: localPosition,
      containerGlobalPosition: currentGlobalPosition,
      containerLocalPosition: currentLocalPosition,
    );
  }

  FastIndexDetails _analysisIndex(Offset globalPosition) {
    if (widget.indexs.isEmpty || globalPosition == null) {
      return FastIndexDetails.empty;
    }
    for (int index = 0; index < _indexKeys.length; index++) {
      var position = _analysisIndexPosition(index);
      if (position == null) {
        continue;
      }
      final localPosition = globalPosition - position.containerGlobalPosition;
      var rect = position.localRect;
      if (rect.contains(Offset(rect.left, localPosition.dy))) {
        return FastIndexDetails(index: index, position: position);
      }
    }
    return FastIndexDetails.empty;
  }

  _recalculationCurrentDetailsPoisition() {
    int oldIndex = _currentDetails.index;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      var newIndex = _currentDetails.index;
      if (oldIndex != newIndex) {
        return;
      }
      _callback(_currentDetails.copyWith(
        position: _analysisIndexPosition(newIndex),
      ));
    });
  }

  _callback(FastIndexDetails details) {
    details ??= FastIndexDetails.empty;
    if (_currentDetails == details) {
      return;
    }
    if (details == FastIndexDetails.empty) {
      _color = _containerColor.withOpacity(0.0);
    } else {
      _color = _containerColor;
    }
    final isIndexChanged = _currentDetails.index != details.index;
    _currentDetails = details;
    setState(() {});
    widget.controller?._value = details;
    FastIndexNotification(details: _currentDetails).dispatch(context);
    if (isIndexChanged) {
      IndexChangedNotification(index: _currentDetails.index).dispatch(context);
    }
    _recalculationCurrentDetailsPoisition();
  }

  _didChangeFaseIndexDetails() {
    var value = widget.controller?.value;
    if (value == _currentDetails) {
      return;
    }
    _callback(widget.controller?.value);
    _callback(FastIndexDetails.empty);
  }

  _resetIndexKeys() {
    _indexKeys.clear();
    _indexKeys.addAll(List.generate(widget.indexs.length, (index) => GlobalKey()));
  }

  @override
  void initState() {
    _resetIndexKeys();
    widget.controller?._positionGetter = _analysisIndexPosition;
    widget.controller?.addListener(_didChangeFaseIndexDetails);
    super.initState();
  }

  @override
  void didUpdateWidget(FastIndex oldWidget) {
    if (widget.indexs.length != oldWidget.indexs.length) {
      _resetIndexKeys();
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_didChangeFaseIndexDetails);
      widget.controller?.addListener(_didChangeFaseIndexDetails);
      _didChangeFaseIndexDetails();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_didChangeFaseIndexDetails);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragDown: _onVerticalDragDown,
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      onVerticalDragCancel: _onVerticalDragCancel,
      child: AnimatedContainer(
        duration: _duration,
        decoration: BoxDecoration(
          color: CupertinoDynamicColor.resolve(
            _color,
            context,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.indexs.length, (index) {
            var isActive = _currentDetails.index == index;
            return Padding(
              key: _indexKeys[index],
              padding: const EdgeInsets.all(2.0),
              child: AnimatedDefaultTextStyle(
                duration: _duration,
                style: DefaultTextStyle.of(context).style.copyWith(
                      fontSize: 14,
                      color: isActive
                          ? CupertinoTheme.of(context).primaryColor
                          : CupertinoDynamicColor.resolve(
                              CupertinoColors.label,
                              context,
                            ),
                      height: 1.0,
                    ),
                child: Text(
                  widget.indexs.elementAt(index),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
