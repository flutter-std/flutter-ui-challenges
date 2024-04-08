import 'package:flutter/material.dart';
import 'package:page_flip/main.dart';
import 'dart:math' as math;

class NumConverter {
  static double toRadian(double degrees) {
    return degrees * (math.pi / 180);
  }
}

class LerpValue {
  final double range;
  final double value;

  LerpValue({required this.range, required this.value});
}

enum PageTheme {
  light,
  dark,
}

class PageFlipBuilder extends StatefulWidget {
  const PageFlipBuilder({super.key});

  @override
  State<PageFlipBuilder> createState() => _PageFlipBuilderState();
}

class _PageFlipBuilderState extends State<PageFlipBuilder>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  PageTheme pageTheme = PageTheme.light;

  void _onFlip() {
    if (_animationController.isAnimating) {
      return;
    }

    if (pageTheme == PageTheme.light) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onChangedAnimation() {
    if (_animationController.value >= 0 && pageTheme == PageTheme.light) {
      setState(() => pageTheme = PageTheme.dark);
    } else if (_animationController.value < 0 && pageTheme == PageTheme.dark) {
      setState(() => pageTheme = PageTheme.light);
    }
  }

  double _lerpDegree(
    double degree,
    LerpValue min,
    LerpValue max,
  ) {
    return min.value +
        (degree - min.range) *
            (max.value - min.value) /
            (max.range - min.range);
  }

  double _lerpScale(double scale) {
    double scaleLinear;
    if (scale == -1 || scale == 1) {
      scaleLinear = 0;
    } else if (scale == 0) {
      scaleLinear = -1.0;
    } else if (scale < 0) {
      scaleLinear = -(1 + scale);
    } else {
      scaleLinear = -1 + scale;
    }
    return 1 + scaleLinear * 0.1;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: -1,
      lowerBound: -1,
      upperBound: 1,
    );

    _animationController.addListener(_onChangedAnimation);
  }

  @override
  void dispose() {
    _animationController.removeListener(_onChangedAnimation);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: pageTheme == PageTheme.light
          ? LightHomePage(onFlip: _onFlip)
          : DarkHomePage(onFlip: _onFlip),
      builder: (BuildContext context, Widget? child) {
        var scale = _lerpScale(_animationController.value);
        var radian = NumConverter.toRadian(
          _lerpDegree(
            _animationController.value,
            LerpValue(range: -1, value: 0),
            LerpValue(range: 1, value: -180),
          ),
        );
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..scale(scale, scale, scale)
            ..rotateY(radian),
          alignment: FractionalOffset.center,
          child: Transform.flip(
            flipX: pageTheme == PageTheme.dark,
            child: child,
          ),
        );
      },
    );
  }
}
