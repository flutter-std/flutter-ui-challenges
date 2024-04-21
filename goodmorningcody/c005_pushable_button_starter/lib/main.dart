import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          // Use Center as layout has unconstrained width (loose constraints),
          // together with SizedBox to specify the max width (tight constraints)
          // See this thread for more info:
          // https://twitter.com/biz84/status/1445400059894542337
          child: Center(
            child: SizedBox(
              width: 400, // max allowed width
              child: PushableButtonPage(),
            ),
          ),
        ),
      ),
    );
  }
}

class PushableButtonPage extends StatefulWidget {
  const PushableButtonPage({super.key});

  @override
  State<PushableButtonPage> createState() => _PushableButtonPageState();
}

class _PushableButtonPageState extends State<PushableButtonPage> {
  String _selection = 'none';

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    final shadow = BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 4,
      offset: const Offset(0, 2),
    );
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PushableButton(
                height: 60,
                elevation: 8,
                hslColor: const HSLColor.fromAHSL(1.0, 356, 1.0, 0.43),
                shadow: shadow,
                onPressed: () => setState(() => _selection = '1'),
                child: const Text('PUSH ME', style: textStyle),
              ),
              const SizedBox(height: 32),
              PushableButton(
                height: 60,
                elevation: 8,
                hslColor: const HSLColor.fromAHSL(1.0, 120, 1.0, 0.37),
                shadow: shadow,
                onPressed: () => setState(() => _selection = '2'),
                child: const Text('ENROLL NOW', style: textStyle),
              ),
              const SizedBox(height: 32),
              PushableButton(
                height: 60,
                elevation: 8,
                hslColor: const HSLColor.fromAHSL(1.0, 195, 1.0, 0.43),
                shadow: shadow,
                onPressed: () => setState(() => _selection = '3'),
                child: const Text('ADD TO BASKET', style: textStyle),
              ),
              const SizedBox(height: 32),
              Text(
                'Pushed: $_selection',
                style: textStyle.copyWith(color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget to show a "3D" pushable button
class PushableButton extends StatefulWidget {
  const PushableButton({
    super.key,
    this.child,
    required this.hslColor,
    required this.height,
    this.elevation = 8.0,
    this.shadow,
    this.onPressed,
  }) : assert(height > 0);

  /// child widget (normally a Text or Icon)
  final Widget? child;

  /// Color of the top layer
  /// The color of the bottom layer is derived by decreasing the luminosity by 0.15
  final HSLColor hslColor;

  /// height of the top layer
  final double height;

  /// elevation or "gap" between the top and bottom layer
  final double elevation;

  /// An optional shadow to make the button look better
  /// This is added to the bottom layer only
  final BoxShadow? shadow;

  /// button pressed callback
  final VoidCallback? onPressed;

  @override
  State<PushableButton> createState() => _PushableButtonState();
}

class _PushableButtonState extends State<PushableButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: 0,
      duration: const Duration(milliseconds: 50),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  _stopIfAnimating() {
    if (_animationController.isAnimating) {
      _animationController.stop();
    }
  }

  _playButtonDown() {
    _stopIfAnimating();
    _animationController.forward();
  }

  _playButtonUp() {
    _stopIfAnimating();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _playButtonDown();
        widget.onPressed?.call();
      },
      onTapUp: (details) => _playButtonUp(),
      onPanEnd: (details) => _playButtonUp(),
      child: Stack(
        children: [
          Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.hslColor.withLightness(0.3).toColor(),
              borderRadius: BorderRadius.circular(widget.height / 2),
              boxShadow:
                  widget.shadow == null ? List.empty() : [widget.shadow!],
            ),
          ),
          AnimatedBuilder(
            animation: _animationController,
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.hslColor.toColor(),
                borderRadius: BorderRadius.circular(widget.height / 2),
              ),
              child: Center(
                child: widget.child,
              ),
            ),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -widget.elevation +
                      _animationController.value * widget.elevation,
                ),
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}
