/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:collection/collection.dart';

class Collections {
  const Collections._();

  static bool equals(dynamic e1, dynamic e2) {
    return const DeepCollectionEquality.unordered().equals(e1, e2);
  }
}
