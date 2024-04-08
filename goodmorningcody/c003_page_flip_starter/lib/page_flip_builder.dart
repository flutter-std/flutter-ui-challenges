import 'package:flutter/material.dart';
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

enum FlipState {
  front,
  back,
}

class PageFlipBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, FlipState flipState) builder;
  const PageFlipBuilder({super.key, required this.builder});

  @override
  State<PageFlipBuilder> createState() => PageFlipBuilderState();
}

class PageFlipBuilderState extends State<PageFlipBuilder>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  FlipState flipState = FlipState.front;

  void flip() {
    if (_animationController.isAnimating) {
      return;
    }

    if (flipState == FlipState.front) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onChangedAnimation() {
    if (_animationController.value >= 0 && flipState == FlipState.front) {
      setState(() => flipState = FlipState.back);
    } else if (_animationController.value < 0 && flipState == FlipState.back) {
      setState(() => flipState = FlipState.front);
    }
  }

  double _lerpDegree(
    LerpValue min,
    LerpValue max,
  ) {
    final value = _animationController.value;
    return min.value +
        (value - min.range) * (max.value - min.value) / (max.range - min.range);
  }

  double _lerpScale(
    LerpValue p1,
    LerpValue p2,
    LerpValue p3,
  ) {
    final value = _animationController.value;
    double scaleLinear;
    if (value == p1.range) {
      scaleLinear = p1.value;
    } else if (value == p3.range) {
      scaleLinear = p3.value;
    } else if (value == p2.range) {
      scaleLinear = p2.value;
    } else if (value < p2.range) {
      scaleLinear = -((p1.value - p2.value) + value);
    } else {
      scaleLinear = (p2.value - p3.value) + value;
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
      child: widget.builder(context, flipState),
      builder: (BuildContext context, Widget? child) {
        var scale = _lerpScale(
          LerpValue(range: -1, value: 0),
          LerpValue(range: 0, value: -1),
          LerpValue(range: 1, value: 0),
        );
        var radian = NumConverter.toRadian(
          _lerpDegree(
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
            flipX: flipState == FlipState.back,
            child: child,
          ),
        );
      },
    );
  }
}
