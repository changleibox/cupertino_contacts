/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:typed_data';

import 'package:cupertinocontacts/page/stack_filter_page.dart';
import 'package:cupertinocontacts/route/route_provider.dart';
import 'package:cupertinocontacts/widget/image_crop.dart';
import 'package:cupertinocontacts/widget/load_prompt.dart';
import 'package:cupertinocontacts/widget/widget_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// Created by box on 2020/4/2.
///
/// 截图
const double _padding = 16;

class CropImagePage extends StatefulWidget {
  final Uint8List bytes;

  const CropImagePage({
    Key key,
    @required this.bytes,
  })  : assert(bytes != null),
        super(key: key);

  @override
  _CropImagePageState createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  final _cropKey = GlobalKey<ImageCropState>();

  _onCropPressed() {
    var currentState = _cropKey.currentState;
    if (currentState == null) {
      return;
    }

    var loadPrompt = LoadPrompt(context)..show();
    currentState.cropImage().then((value) {
      loadPrompt.dismiss();
      Navigator.push(
        context,
        RouteProvider.buildRoute(
          StackFilterPage(bytes: value),
          fullscreenDialog: true,
        ),
      ).then((value) {
        Navigator.pop(context, value);
      });
    }).catchError((errot) {
      loadPrompt.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoTheme.of(context).copyWith(
        brightness: Brightness.dark,
      ),
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.secondarySystemGroupedBackground,
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              ImageCrop(
                key: _cropKey,
                image: MemoryImage(widget.bytes),
                chipRadius: MediaQuery.of(context).size.width / 2 - _padding,
                chipShape: BoxShape.circle,
              ),
              Positioned(
                top: 20,
                child: SafeArea(
                  child: Text(
                    '移动和缩放',
                    style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                child: SafeArea(
                  child: WidgetGroup.spacing(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        child: Text(
                          '取消',
                          style: TextStyle(
                            fontSize: 17,
                            color: CupertinoColors.white,
                          ),
                        ),
                        padding: EdgeInsets.all(_padding),
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                      ),
                      CupertinoButton(
                        child: Text(
                          '选取',
                          style: TextStyle(
                            fontSize: 17,
                            color: CupertinoColors.white,
                          ),
                        ),
                        padding: EdgeInsets.all(_padding),
                        onPressed: _onCropPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
