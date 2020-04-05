/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

class Avatar<T> {
  final bool editable;
  final T src;
  T target;

  Avatar(this.src, {this.editable = true, this.target})
      : assert(src != null),
        assert(editable != null);

  T get avatar => target ?? src;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Avatar && runtimeType == other.runtimeType && src == other.src;

  @override
  int get hashCode => src.hashCode;
}

class Uint8ListAvatar extends Avatar<Uint8List> {
  Uint8ListAvatar(
    Uint8List src, {
    bool editable = true,
    Uint8List target,
  }) : super(
          src,
          target: target,
          editable: editable,
        );
}
