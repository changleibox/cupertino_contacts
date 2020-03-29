/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/material.dart';

/**
 * Created by box on 2020/3/24.
 */
/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class AnimatedFadeIn extends ImplicitlyAnimatedWidget {
  const AnimatedFadeIn({
    Key key,
    @required this.target,
    @required this.placeholder,
    @required this.isTargetLoaded,
    @required this.fadeInDuration,
    @required this.fadeInCurve,
  })  : assert(target != null),
        assert(placeholder != null),
        assert(isTargetLoaded != null),
        assert(fadeInDuration != null),
        assert(fadeInCurve != null),
        super(key: key, duration: fadeInDuration);

  final Widget target;
  final Widget placeholder;
  final bool isTargetLoaded;
  final Duration fadeInDuration;
  final Curve fadeInCurve;

  @override
  _AnimatedFadeOutFadeInState createState() => _AnimatedFadeOutFadeInState();
}

class _AnimatedFadeOutFadeInState extends ImplicitlyAnimatedWidgetState<AnimatedFadeIn> {
  Tween<double> _targetOpacity;
  Animation<double> _targetOpacityAnimation;
  Widget _placeHolder;

  @override
  void initState() {
    _placeHolder = widget.placeholder;
    super.initState();
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _targetOpacity = visitor(
      _targetOpacity,
      widget.isTargetLoaded ? 1.0 : 0.0,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>;
  }

  @override
  void didUpdateTweens() {
    _targetOpacityAnimation = animation.drive(_targetOpacity.chain(CurveTween(curve: widget.fadeInCurve)))
      ..addStatusListener((status) {
        if (_targetOpacityAnimation.isCompleted) {
          _placeHolder = widget.target;
          setState(() {});
        }
      });
    if (!widget.isTargetLoaded && _isValid(_targetOpacity)) {
      // Jump (don't fade) back to the placeholder image, so as to be ready
      // for the full animation when the new target image becomes ready.
      controller.value = controller.upperBound;
    }
  }

  bool _isValid(Tween<double> tween) {
    return tween.begin != null && tween.end != null;
  }

  @override
  Widget build(BuildContext context) {
    final Widget target = FadeTransition(
      opacity: _targetOpacityAnimation,
      child: widget.target,
    );

    if (_targetOpacityAnimation.isCompleted) {
      return _placeHolder;
    }

    return Stack(
      fit: StackFit.passthrough,
      alignment: AlignmentDirectional.center,
      // Text direction is irrelevant here since we're using center alignment,
      // but it allows the Stack to avoid a call to Directionality.of()
      textDirection: TextDirection.ltr,
      children: <Widget>[
        _placeHolder,
        target,
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Animation<double>>('targetOpacity', _targetOpacityAnimation));
  }
}
