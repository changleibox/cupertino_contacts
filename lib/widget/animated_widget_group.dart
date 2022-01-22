/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:cupertinocontacts/widget/child_delegate.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

// The default insert/remove animation duration.
const Duration _kDuration = Duration(milliseconds: 300);

// Incoming and outgoing AnimatedList items.
class _ActiveItem implements Comparable<_ActiveItem> {
  _ActiveItem.incoming(this.controller, this.itemIndex) : removedItemBuilder = null;

  _ActiveItem.outgoing(this.controller, this.itemIndex, this.removedItemBuilder);

  _ActiveItem.index(this.itemIndex)
      : controller = null,
        removedItemBuilder = null;

  final AnimationController controller;
  final AnimatedListRemovedItemBuilder removedItemBuilder;
  int itemIndex;

  @override
  int compareTo(_ActiveItem other) => itemIndex - other.itemIndex;
}

class AnimatedWidgetGroup extends StatefulWidget {
  /// Creates a sliver that animates items when they are inserted or removed.
  const AnimatedWidgetGroup({
    Key key,
    @required this.itemBuilder,
    this.initialItemCount = 0,
  })  : assert(itemBuilder != null),
        assert(initialItemCount != null && initialItemCount >= 0),
        super(key: key);

  /// Called, as needed, to build list item widgets.
  ///
  /// List items are only built when they're scrolled into view.
  ///
  /// The [AnimatedListItemBuilder] index parameter indicates the item's
  /// position in the list. The value of the index parameter will be between 0
  /// and [initialItemCount] plus the total number of items that have been
  /// inserted with [AnimatedWidgetGroupState.insertItem] and less the total
  /// number of items that have been removed with
  /// [AnimatedWidgetGroupState.removeItem].
  ///
  /// Implementations of this callback should assume that
  /// [AnimatedWidgetGroupState.removeItem] removes an item immediately.
  final AnimatedListItemBuilder itemBuilder;

  /// {@macro flutter.widgets.animatedList.initialItemCount}
  final int initialItemCount;

  @override
  AnimatedWidgetGroupState createState() => AnimatedWidgetGroupState();

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [AnimatedWidgetGroup] item widgets that
  /// insert or remove items in response to user input.
  ///
  /// ```dart
  /// SliverAnimatedListState animatedList = SliverAnimatedList.of(context);
  /// ```
  static AnimatedWidgetGroupState of(BuildContext context, {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final result = context.findAncestorStateOfType<AnimatedWidgetGroupState>();
    if (nullOk || result != null) {
      return result;
    }
    throw FlutterError('SliverAnimatedList.of() called with a context that does not contain a SliverAnimatedList.\n'
        'No SliverAnimatedListState ancestor could be found starting from the '
        'context that was passed to SliverAnimatedListState.of(). This can '
        'happen when the context provided is from the same StatefulWidget that '
        'built the AnimatedList. Please see the SliverAnimatedList documentation '
        'for examples of how to refer to an AnimatedListState object: '
        'https://docs.flutter.io/flutter/widgets/SliverAnimatedListState-class.html \n'
        'The context used was:\n'
        '  $context');
  }
}

class AnimatedWidgetGroupState extends State<AnimatedWidgetGroup> with TickerProviderStateMixin {
  final List<_ActiveItem> _incomingItems = <_ActiveItem>[];
  final List<_ActiveItem> _outgoingItems = <_ActiveItem>[];
  int _itemsCount = 0;

  @override
  void initState() {
    super.initState();
    _itemsCount = widget.initialItemCount;
  }

  @override
  void dispose() {
    for (final item in _incomingItems.followedBy(_outgoingItems)) {
      item.controller.dispose();
    }
    super.dispose();
  }

  _ActiveItem _removeActiveItemAt(List<_ActiveItem> items, int itemIndex) {
    final i = binarySearch(items, _ActiveItem.index(itemIndex));
    return i == -1 ? null : items.removeAt(i);
  }

  _ActiveItem _activeItemAt(List<_ActiveItem> items, int itemIndex) {
    final i = binarySearch(items, _ActiveItem.index(itemIndex));
    return i == -1 ? null : items[i];
  }

  // The insertItem() and removeItem() index parameters are defined as if the
  // removeItem() operation removed the corresponding list entry immediately.
  // The entry is only actually removed from the ListView when the remove animation
  // finishes. The entry is added to _outgoingItems when removeItem is called
  // and removed from _outgoingItems when the remove animation finishes.

  int _indexToItemIndex(int index) {
    var itemIndex = index;
    for (final item in _outgoingItems) {
      if (item.itemIndex <= itemIndex) {
        itemIndex += 1;
      } else {
        break;
      }
    }
    return itemIndex;
  }

  int _itemIndexToIndex(int itemIndex) {
    var index = itemIndex;
    for (final item in _outgoingItems) {
      assert(item.itemIndex != itemIndex);
      if (item.itemIndex < itemIndex) {
        index -= 1;
      } else {
        break;
      }
    }
    return index;
  }

  ChildDelegate _createDelegate() {
    return ChildBuilderDelegate(
      _itemBuilder,
      childCount: _itemsCount,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      addSemanticIndexes: false,
    );
  }

  /// Insert an item at [index] and start an animation that will be passed to
  /// [AnimatedWidgetGroup.itemBuilder] when the item is visible.
  ///
  /// This method's semantics are the same as Dart's [List.insert] method:
  /// it increases the length of the list by one and shifts all items at or
  /// after [index] towards the end of the list.
  void insertItem(int index, {Duration duration = _kDuration}) {
    assert(index != null && index >= 0);
    assert(duration != null);

    final itemIndex = _indexToItemIndex(index);
    assert(itemIndex >= 0 && itemIndex <= _itemsCount);

    // Increment the incoming and outgoing item indices to account
    // for the insertion.
    for (final item in _incomingItems) {
      if (item.itemIndex >= itemIndex) {
        item.itemIndex += 1;
      }
    }
    for (final item in _outgoingItems) {
      if (item.itemIndex >= itemIndex) {
        item.itemIndex += 1;
      }
    }

    final controller = AnimationController(
      duration: duration,
      vsync: this,
    );
    final incomingItem = _ActiveItem.incoming(
      controller,
      itemIndex,
    );
    setState(() {
      _incomingItems
        ..add(incomingItem)
        ..sort();
      _itemsCount += 1;
    });

    controller.forward().then<void>((_) {
      _removeActiveItemAt(_incomingItems, incomingItem.itemIndex).controller.dispose();
    });
  }

  /// Remove the item at [index] and start an animation that will be passed
  /// to [builder] when the item is visible.
  ///
  /// Items are removed immediately. After an item has been removed, its index
  /// will no longer be passed to the [AnimatedWidgetGroup.itemBuilder]. However
  /// the item will still appear in the list for [duration] and during that time
  /// [builder] must construct its widget as needed.
  ///
  /// This method's semantics are the same as Dart's [List.remove] method:
  /// it decreases the length of the list by one and shifts all items at or
  /// before [index] towards the beginning of the list.
  void removeItem(int index, AnimatedListRemovedItemBuilder builder, {Duration duration = _kDuration}) {
    assert(index != null && index >= 0);
    assert(builder != null);
    assert(duration != null);

    final itemIndex = _indexToItemIndex(index);
    assert(itemIndex >= 0 && itemIndex < _itemsCount);
    assert(_activeItemAt(_outgoingItems, itemIndex) == null);

    final incomingItem = _removeActiveItemAt(_incomingItems, itemIndex);
    final controller = incomingItem?.controller ?? AnimationController(duration: duration, value: 1.0, vsync: this);
    final outgoingItem = _ActiveItem.outgoing(controller, itemIndex, builder);
    setState(() {
      _outgoingItems
        ..add(outgoingItem)
        ..sort();
    });

    controller.reverse().then<void>((void value) {
      _removeActiveItemAt(_outgoingItems, outgoingItem.itemIndex).controller.dispose();

      // Decrement the incoming and outgoing item indices to account
      // for the removal.
      for (final item in _incomingItems) {
        if (item.itemIndex > outgoingItem.itemIndex) {
          item.itemIndex -= 1;
        }
      }
      for (final item in _outgoingItems) {
        if (item.itemIndex > outgoingItem.itemIndex) {
          item.itemIndex -= 1;
        }
      }

      setState(() => _itemsCount -= 1);
    });
  }

  Widget _itemBuilder(BuildContext context, int itemIndex) {
    final outgoingItem = _activeItemAt(_outgoingItems, itemIndex);
    if (outgoingItem != null) {
      return outgoingItem.removedItemBuilder(
        context,
        outgoingItem.controller.view,
      );
    }

    final incomingItem = _activeItemAt(_incomingItems, itemIndex);
    final animation = incomingItem?.controller?.view ?? kAlwaysCompleteAnimation;
    return widget.itemBuilder(
      context,
      _itemIndexToIndex(itemIndex),
      animation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetGroup.custom(
      alignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      direction: Axis.vertical,
      childrenDelegate: _createDelegate(),
    );
  }
}
