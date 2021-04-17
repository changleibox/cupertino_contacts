/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Created by box on 2020/4/1.
///
/// iOS风格的进度条
class CupertinoProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(
        radius: 14,
      ),
    );
  }
}
