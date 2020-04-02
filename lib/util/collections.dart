/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:collection/collection.dart';

class Collections {
  static bool equals(dynamic e1, dynamic e2) {
    return DeepCollectionEquality.unordered().equals(e1, e2);
  }
}
