/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/model/color_matrix.dart';
import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/util/image.dart';
import 'package:cupertinocontacts/widget/circle_avatar.dart';
import 'package:cupertinocontacts/widget/load_prompt.dart';
import 'package:cupertinocontacts/widget/navigation_bar_action.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// Created by box on 2020/4/4.
///
/// 叠加滤镜
const double _spacing = 20;
const double _padding = 16;

class StackFilterPage extends StatefulWidget {
  final Uint8List bytes;

  const StackFilterPage({
    Key key,
    @required this.bytes,
  })  : assert(bytes != null),
        super(key: key);

  @override
  _StackFilterPageState createState() => _StackFilterPageState();
}

class _StackFilterPageState extends State<StackFilterPage> {
  final _filters = List<_ColorMatrixFilter>();

  @override
  void initState() {
    _filters.add(_ColorMatrixFilter(
      name: '原片',
      matrix: ColorMatrix.identity(),
    ));
    _filters.add(_ColorMatrixFilter(
      name: '鲜明',
      matrix: ColorMatrix.luminosity(10) + ColorMatrix.saturation(1.5),
    ));
    _filters.add(_ColorMatrixFilter(
      name: '鲜暖色',
      matrix: (ColorMatrix.luminosity(10)..setEntry(0, 4, 30)) + ColorMatrix.saturation(1.5),
    ));
    _filters.add(_ColorMatrixFilter(
      name: '鲜冷色',
      matrix: (ColorMatrix.luminosity(10)..setEntry(2, 4, 30)) + ColorMatrix.saturation(1.5),
    ));
    _filters.add(_ColorMatrixFilter(
      name: '反差色',
      matrix: ColorMatrix.luminosity(-20),
    ));
    _filters.add(_ColorMatrixFilter(
      name: '反差暖色',
      matrix: ColorMatrix.luminosity(-20)..setEntry(0, 4, 0),
    ));
    _filters.add(_ColorMatrixFilter(
      name: '反差冷色',
      matrix: ColorMatrix.luminosity(-20)..setEntry(2, 4, 0),
    ));
    _filters.add(_ColorMatrixFilter(
      name: '单色',
      matrix: ColorMatrix.greyscale(),
    ));
    _filters.add(_ColorMatrixFilter(
      name: '银色调',
      matrix: ColorMatrix.greyscale() + ColorMatrix.luminosity(-60) + ColorMatrix.identity()
        ..setEntry(0, 0, 192.0 / 255.0)
        ..setEntry(1, 0, 192.0 / 255.0)
        ..setEntry(2, 0, 192.0 / 255.0),
    ));
    _filters.add(_ColorMatrixFilter(
      name: '夜色',
      matrix: ColorMatrix.greyscale() + ColorMatrix.luminosity(-20),
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = (MediaQuery.of(context).size.width - _spacing) / 2 - _padding;
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.tertiarySystemBackground,
        middle: Text('选取滤镜'),
        leading: NavigationBarAction(
          child: Text('取消'),
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: _spacing,
          crossAxisSpacing: _spacing,
          childAspectRatio: imageSize / (imageSize + 8 + 12),
        ),
        padding: MediaQuery.of(context).padding.copyWith(top: 0) + EdgeInsets.all(_padding),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          var filter = _filters[index];
          var storage = filter.matrix.storage;
          Widget imageChild = CupertinoCircleAvatar.memory(
            assetName: Images.ic_default_avatar,
            bytes: widget.bytes,
            borderSide: BorderSide.none,
            size: double.infinity,
            onPressed: () {
              var src = ImageFilterSrc(
                image: widget.bytes,
                matrix: storage,
              );
              var loadPrompt = LoadPrompt(context)..show();
              ImageFilters.colorMatrixFilter(src).then((value) {
                loadPrompt.dismiss();
                Navigator.pop(context, value);
              }).catchError((_) {
                loadPrompt.dismiss();
              });
            },
          );
          if (filter.matrix != null) {
            imageChild = ColorFiltered(
              colorFilter: ColorFilter.matrix(storage),
              child: imageChild,
            );
          }
          return WidgetGroup.spacing(
            alignment: MainAxisAlignment.center,
            direction: Axis.vertical,
            spacing: 8,
            children: [
              Flexible(
                child: imageChild,
              ),
              Text(
                filter.name,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontSize: 12,
                      height: 1.0,
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ColorMatrixFilter {
  final String name;
  final ColorMatrix matrix;

  const _ColorMatrixFilter({
    @required this.name,
    this.matrix,
  }) : assert(name != null);
}
