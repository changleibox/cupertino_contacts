/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;
import 'dart:ui' as ui;

const _kCropOverlayActiveOpacity = 0.3;
const _kCropOverlayInactiveOpacity = 0.7;

class _CropInfos {
  final int srcWidth;
  final int srcHeight;
  final Uint8List bytes;
  final double scale;
  final Rect area;

  _CropInfos({
    this.srcWidth,
    this.srcHeight,
    this.bytes,
    this.scale,
    this.area,
  });
}

Uint8List _cropImageAsSync(_CropInfos infos) {
  var srcRect = Rect.fromLTWH(
    0,
    0,
    infos.srcWidth.toDouble(),
    infos.srcHeight.toDouble(),
  );
  var cropRect = Rect.fromLTRB(
    max(srcRect.width * infos.area.left, srcRect.left),
    max(srcRect.height * infos.area.top, srcRect.top),
    min(srcRect.width * infos.area.right, srcRect.right),
    min(srcRect.height * infos.area.bottom, srcRect.bottom),
  );

  var copyCropImage = image.copyCrop(
    image.decodeImage(infos.bytes),
    cropRect.left.floor(),
    cropRect.top.floor(),
    cropRect.width.floor(),
    cropRect.height.floor(),
  );
  return image.encodePng(copyCropImage);
}

Future<Uint8List> _cropImage(_CropInfos cropInfos) {
  return compute(_cropImageAsSync, cropInfos);
}

enum _CropAction { none, moving, scaling }

class ImageCrop extends StatefulWidget {
  final ImageProvider image;
  final double maximumScale;
  final ImageErrorListener onImageError;
  final double chipRadius;
  final BoxShape chipShape;

  const ImageCrop({
    Key key,
    this.image,
    this.maximumScale: 2.0,
    this.onImageError,
    this.chipRadius = 150,
    this.chipShape = BoxShape.circle,
  })  : assert(image != null),
        assert(maximumScale != null),
        super(key: key);

  ImageCrop.file(
    File file, {
    Key key,
    double scale = 1.0,
    this.maximumScale: 2.0,
    this.onImageError,
    this.chipRadius = 150,
    this.chipShape = BoxShape.circle,
  })  : image = FileImage(file, scale: scale),
        assert(maximumScale != null),
        super(key: key);

  ImageCrop.asset(
    String assetName, {
    Key key,
    AssetBundle bundle,
    String package,
    this.chipRadius = 150,
    this.maximumScale: 2.0,
    this.onImageError,
    this.chipShape = BoxShape.circle,
  })  : image = AssetImage(
          assetName,
          bundle: bundle,
          package: package,
        ),
        assert(maximumScale != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ImageCropState();

  static ImageCropState of(BuildContext context) {
    return context.findAncestorStateOfType();
  }
}

class ImageCropState extends State<ImageCrop> with TickerProviderStateMixin {
  final _surfaceKey = GlobalKey();
  AnimationController _activeController;
  AnimationController _settleController;
  ImageStream _imageStream;
  ui.Image _image;
  double _scale;
  double _ratio;
  Rect _view;
  Rect _area;
  Offset _lastFocalPoint;
  _CropAction _action;
  double _startScale;
  Rect _startView;
  Tween<Rect> _viewTween;
  Tween<double> _scaleTween;
  ImageStreamListener _imageListener;

  double get scale => _area.shortestSide / _scale;

  Rect get area {
    return _view.isEmpty
        ? null
        : Rect.fromLTWH(
            _area.left * _view.width / _scale - _view.left,
            _area.top * _view.height / _scale - _view.top,
            _area.width * _view.width / _scale,
            _area.height * _view.height / _scale,
          );
  }

  bool get _isEnabled => !_view.isEmpty && _image != null;

  Future<Uint8List> cropImage() async {
    if (_image == null) {
      return Future.error('图片解析失败');
    }
    var byteData = await _image.toByteData(format: ui.ImageByteFormat.png);
    var cropInfos = _CropInfos(
      srcWidth: _image.width,
      srcHeight: _image.height,
      bytes: Uint8List.view(byteData.buffer),
      area: area,
      scale: scale,
    );
    return _cropImage(cropInfos);
  }

  @override
  void initState() {
    super.initState();
    _area = Rect.zero;
    _view = Rect.zero;
    _scale = 1.0;
    _ratio = 1.0;
    _lastFocalPoint = Offset.zero;
    _action = _CropAction.none;
    _activeController = AnimationController(
      vsync: this,
      value: 0.0,
    )..addListener(() => setState(() {}));
    _settleController = AnimationController(
      vsync: this,
    )..addListener(_settleAnimationChanged);
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageListener);
    _activeController.dispose();
    _settleController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getImage();
  }

  @override
  void didUpdateWidget(ImageCrop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _getImage();
    }
    _activate(0.0);
  }

  void _getImage({bool force: false}) {
    final oldImageStream = _imageStream;
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
    if (_imageStream.key != oldImageStream?.key || force) {
      oldImageStream?.removeListener(_imageListener);
      _imageListener = ImageStreamListener(_updateImage, onError: widget.onImageError);
      _imageStream.addListener(_imageListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: GestureDetector(
        key: _surfaceKey,
        behavior: HitTestBehavior.opaque,
        onScaleStart: _isEnabled ? _handleScaleStart : null,
        onScaleUpdate: _isEnabled ? _handleScaleUpdate : null,
        onScaleEnd: _isEnabled ? _handleScaleEnd : null,
        child: CustomPaint(
          painter: _CropPainter(
            image: _image,
            ratio: _ratio,
            view: _view,
            area: _area,
            scale: _scale,
            active: _activeController.value,
            chipShape: widget.chipShape,
            borderColor: CupertinoTheme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  void _activate(double val) {
    _activeController.animateTo(
      val,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 250),
    );
  }

  Size get _boundaries => _surfaceKey.currentContext.size;

  void _settleAnimationChanged() {
    setState(() {
      _scale = _scaleTween.transform(_settleController.value);
      _view = _viewTween.transform(_settleController.value);
    });
  }

  Rect _calculateDefaultArea({
    int imageWidth,
    int imageHeight,
    double viewWidth,
    double viewHeight,
  }) {
    if (imageWidth == null || imageHeight == null) {
      return Rect.zero;
    }

    final _deviceWidth = MediaQuery.of(context).size.width;
    final _areaOffset = (_deviceWidth - (widget.chipRadius * 2));
    final _areaOffsetRadio = _areaOffset / _deviceWidth;
    final width = 1.0 - _areaOffsetRadio;

    final height = (imageWidth * viewWidth * width) / (imageHeight * viewHeight * 1.0);
    return Rect.fromLTWH((1.0 - width) / 2, (1.0 - height) / 2, width, height);
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _image = imageInfo.image;
        _scale = imageInfo.scale;

        var imageWidth = _image.width;
        var imageHeight = _image.height;

        var boundariesWidth = _boundaries.width;
        var boundariesHeight = _boundaries.height;

        final chipDiameter = widget.chipRadius * 2;
        _ratio = max(
          max(
            chipDiameter / imageWidth,
            chipDiameter / imageHeight,
          ),
          min(
            boundariesWidth / imageWidth,
            boundariesHeight / imageHeight,
          ),
        );

        final viewWidth = boundariesWidth / (imageWidth * _scale * _ratio);
        final viewHeight = boundariesHeight / (imageHeight * _scale * _ratio);
        _area = _calculateDefaultArea(
          viewWidth: viewWidth,
          viewHeight: viewHeight,
          imageWidth: imageWidth,
          imageHeight: imageHeight,
        );

        _view = Rect.fromLTWH(
          (viewWidth - 1.0) / 2,
          (viewHeight - 1.0) / 2,
          viewWidth,
          viewHeight,
        );
      });
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _activate(1.0);
    _scale = _scaleTween?.transform(1.0) ?? _scale;
    _view = _viewTween?.transform(1.0) ?? _view;
    _settleController.stop(canceled: false);
    _lastFocalPoint = details.focalPoint;
    _action = _CropAction.none;
    _startScale = _scale;
    _startView = _view;
  }

  Rect _getViewInBoundaries(double scale, Rect view) {
    var left = min(view.left, _area.left * view.width / scale);
    var right = _area.right * view.width / scale - 1.0;
    var top = min(view.top, _area.top * view.height / scale);
    var bottom = _area.bottom * view.height / scale - 1.0;
    return Offset(max(left, right), max(top, bottom)) & view.size;
  }

  double get _maximumScale {
    var ratioAsScreen = max(
      _boundaries.width / _image.width,
      _boundaries.height / _image.height,
    );
    final initialScale = ratioAsScreen / _ratio;
    return max(widget.maximumScale, initialScale);
  }

  double get _minimumScale {
    final scaleX = _boundaries.width * _area.width / (_image.width * _ratio);
    final scaleY = _boundaries.height * _area.height / (_image.height * _ratio);
    return min(_maximumScale, max(scaleX, scaleY));
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _activate(0);
    if (_action == _CropAction.none) {
      return;
    }

    var targetScale;
    var targetView;
    if (_scale < _minimumScale) {
      targetScale = _minimumScale;
      targetView = _calculateView(targetScale);
    } else if (_scale > _maximumScale) {
      targetScale = _maximumScale;
      targetView = _calculateView(targetScale);
    } else {
      targetScale = _scale;
      targetView = _view;
    }

    _scaleTween = Tween<double>(
      begin: _scale,
      end: targetScale,
    );

    _startView = _view;
    _viewTween = RectTween(
      begin: _view,
      end: _getViewInBoundaries(targetScale, targetView),
    );

    _settleController.value = 0.0;
    _settleController.animateTo(
      1.0,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 350),
    );
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    _action = details.rotation == 0.0 && details.scale == 1.0 ? _CropAction.moving : _CropAction.scaling;

    if (_action == _CropAction.moving) {
      final delta = details.focalPoint - _lastFocalPoint;
      _lastFocalPoint = details.focalPoint;

      setState(() {
        _view = _view.translate(
          delta.dx / (_image.width * _scale * _ratio),
          delta.dy / (_image.height * _scale * _ratio),
        );
      });
    } else if (_action == _CropAction.scaling) {
      setState(() {
        _scale = _startScale * details.scale;
        _view = _calculateView(_scale);
      });
    }
  }

  _calculateView(double targetScale) {
    var scale = targetScale / _startScale;
    final dx = _boundaries.width * (1.0 - scale) / (_image.width * targetScale * _ratio);
    final dy = _boundaries.height * (1.0 - scale) / (_image.height * targetScale * _ratio);

    return Rect.fromLTWH(
      _startView.left + dx / 2,
      _startView.top + dy / 2,
      _startView.width,
      _startView.height,
    );
  }
}

class _CropPainter extends CustomPainter {
  final ui.Image image;
  final Rect view;
  final double ratio;
  final Rect area;
  final double scale;
  final double active;
  final BoxShape chipShape;
  final Color borderColor;

  _CropPainter({
    this.image,
    this.view,
    this.ratio,
    this.area,
    this.scale,
    this.active,
    this.chipShape,
    this.borderColor,
  });

  @override
  bool shouldRepaint(_CropPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.view != view ||
        oldDelegate.ratio != ratio ||
        oldDelegate.area != area ||
        oldDelegate.active != active ||
        oldDelegate.scale != scale;
  }

  Rect currentRect(size) {
    return Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height,
    );
  }

  Rect currentBoundaries(size) {
    var rect = currentRect(size);
    return Rect.fromLTWH(
      rect.width * area.left,
      rect.height * area.top,
      rect.width * area.width,
      rect.height * area.height,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = currentRect(size);

    canvas.save();
    canvas.translate(rect.left, rect.top);

    final paint = Paint()..isAntiAlias = false;

    if (image != null) {
      var imageWidth = image.width.toDouble();
      var imageHeight = image.height.toDouble();

      final src = Rect.fromLTWH(
        0.0,
        0.0,
        imageWidth,
        imageHeight,
      );
      final dst = Rect.fromLTWH(
        view.left * imageWidth * scale * ratio,
        view.top * imageHeight * scale * ratio,
        imageWidth * scale * ratio,
        imageHeight * scale * ratio,
      );

      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0.0, 0.0, rect.width, rect.height));
      canvas.drawImageRect(image, src, dst, paint);
      canvas.restore();
    }

    paint.color = Color.fromRGBO(0x0, 0x0, 0x0, _kCropOverlayActiveOpacity * active + _kCropOverlayInactiveOpacity * (1.0 - active));
    final boundaries = currentBoundaries(size);
    final _path1 = Path()..addRect(Rect.fromLTRB(0.0, 0.0, rect.width, rect.height));
    Path _path2;
    if (chipShape == BoxShape.rectangle) {
      _path2 = Path()..addRect(boundaries);
    } else {
      _path2 = Path()
        ..addRRect(RRect.fromLTRBR(
          boundaries.left,
          boundaries.top,
          boundaries.right,
          boundaries.bottom,
          Radius.circular(boundaries.height / 2),
        ));
    }
    canvas.clipPath(Path.combine(PathOperation.difference, _path1, _path2));
    canvas.drawRect(Rect.fromLTRB(0.0, 0.0, rect.width, rect.height), paint);
    paint
      ..isAntiAlias = true
      ..color = borderColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    if (chipShape == BoxShape.rectangle) {
      canvas.drawRect(
        Rect.fromLTRB(
          boundaries.left - 1,
          boundaries.top - 1,
          boundaries.right + 1,
          boundaries.bottom + 1,
        ),
        paint,
      );
    } else {
      canvas.drawRRect(
        RRect.fromLTRBR(
          boundaries.left - 1,
          boundaries.top - 1,
          boundaries.right + 1,
          boundaries.bottom + 1,
          Radius.circular(boundaries.height / 2),
        ),
        paint,
      );
    }

    canvas.restore();
  }
}
