/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:io';
import 'dart:typed_data';

import 'package:cupertinocontacts/resource/assets.dart';
import 'package:cupertinocontacts/resource/colors.dart';
import 'package:cupertinocontacts/widget/animated_fade_in.dart';
import 'package:flutter/cupertino.dart';

/// Created by box on 2019-12-20.
///
/// 圆形头像
class CupertinoCircleAvatarContainer extends StatelessWidget {
  const CupertinoCircleAvatarContainer({
    Key key,
    @required this.child,
    @required this.size,
    this.borderSide = const BorderSide(
      color: separatorColor,
      width: 0.5,
    ),
    this.onPressed,
  })  : assert(size != null && size > 0),
        assert(child != null),
        super(key: key);

  final Widget child;
  final double size;
  final BorderSide borderSide;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox.fromSize(
      size: Size.square(size),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: size,
        borderRadius: BorderRadius.circular(size / 2),
        onPressed: onPressed,
        child: ClipOval(
          child: this.child,
        ),
      ),
    );
    if (borderSide != null) {
      child = Container(
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: borderSide.copyWith(
              color: CupertinoDynamicColor.resolve(
                borderSide.color,
                context,
              ),
            ),
          ),
          color: CupertinoDynamicColor.resolve(
            CupertinoTheme.of(context).scaffoldBackgroundColor,
            context,
          ),
        ),
        child: child,
      );
    }

    return child;
  }
}

class CupertinoCircleAvatar extends StatelessWidget {
  const CupertinoCircleAvatar({
    Key key,
    @required Widget child,
    @required this.size,
    this.borderSide = const BorderSide(
      color: separatorColor,
      width: 0.5,
    ),
    this.onPressed,
  })  : assert(size != null && size > 0),
        _child = child,
        super(key: key);

  CupertinoCircleAvatar.file({
    Key key,
    String assetName,
    @required File file,
    @required this.size,
    bool clickable = true,
    dynamic previewTag,
    bool canPreview = true,
    this.borderSide = const BorderSide(
      color: separatorColor,
      width: 0.5,
    ),
    this.onPressed,
    WidgetBuilder bottomBarBuilder,
  })  : assert(size != null && size > 0),
        assert(assetName != null || file != null),
        assert(canPreview != null),
        _child = _LocationImage(
          size: size,
          file: file,
          assetName: assetName,
        ),
        super(key: key);

  CupertinoCircleAvatar.asset({
    Key key,
    @required String name,
    @required this.size,
    this.borderSide = const BorderSide(
      color: separatorColor,
      width: 0.5,
    ),
    this.onPressed,
  })  : assert(size != null && size > 0),
        assert(name != null),
        _child = _LocationImage(
          assetName: name,
          size: size,
        ),
        super(key: key);

  CupertinoCircleAvatar.memory({
    Key key,
    String assetName,
    @required Uint8List bytes,
    @required this.size,
    this.borderSide = const BorderSide(
      color: separatorColor,
      width: 0.5,
    ),
    this.onPressed,
  })  : assert(size != null && size > 0),
        assert(assetName != null || bytes != null),
        _child = _LocationImage.memory(
          size: size,
          bytes: bytes,
          assetName: assetName,
        ),
        super(key: key);

  final double size;
  final BorderSide borderSide;
  final Widget _child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoCircleAvatarContainer(
      size: size,
      borderSide: borderSide,
      onPressed: onPressed,
      child: _child,
    );
  }
}

class DefaultCircleImage extends StatelessWidget {
  const DefaultCircleImage({
    Key key,
    this.size,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Images.ic_default_avatar,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}

class _LocationImage extends StatelessWidget {
  const _LocationImage({
    Key key,
    this.assetName,
    this.file,
    this.size,
  })  : bytes = null,
        super(key: key);

  const _LocationImage.memory({
    Key key,
    this.assetName,
    @required this.bytes,
    this.size,
  })  : file = null,
        super(key: key);

  Image _image({
    @required ImageProvider image,
    ImageFrameBuilder frameBuilder,
    ImageErrorWidgetBuilder errorBuilder,
  }) {
    assert(image != null);
    return Image(
      image: image,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: size,
      height: size,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      excludeFromSemantics: true,
    );
  }

  final String assetName;
  final File file;
  final Uint8List bytes;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeHolder = AssetImage(
      assetName ?? Images.ic_default_avatar,
    );
    ImageProvider imageProvider = placeHolder;
    if (file != null) {
      imageProvider = FileImage(file, scale: 1.0);
    } else if (bytes != null && bytes.isNotEmpty) {
      imageProvider = MemoryImage(bytes, scale: 1.0);
    }
    return _image(
      image: imageProvider,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedFadeIn(
          target: child,
          placeholder: _image(image: placeHolder),
          isTargetLoaded: frame != null,
          fadeInDuration: const Duration(milliseconds: 300),
          fadeInCurve: Curves.easeIn,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _image(image: placeHolder);
      },
    );
  }
}
