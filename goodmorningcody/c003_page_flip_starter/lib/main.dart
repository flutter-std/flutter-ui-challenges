import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

Future<void> preloadSVGs() async {
  final svgList = [
    'assets/forest-day.svg',
    'assets/forest-night.svg',
    'assets/man.svg',
  ];
  for (final asset in svgList) {
    final loader = SvgAssetLoader(asset);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preloadSVGs();
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
              width: 500, // max allowed width
              child: HomePage(),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum PageTheme {
  light,
  dark,
}

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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  PageTheme homeTheme = PageTheme.light;

  void _onFlip() {
    if (_animationController.isAnimating) {
      return;
    }

    if (homeTheme == PageTheme.light) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onChangedAnimation() {
    if (_animationController.value >= 0 && homeTheme == PageTheme.light) {
      setState(() => homeTheme = PageTheme.dark);
    } else if (_animationController.value < 0 && homeTheme == PageTheme.dark) {
      setState(() => homeTheme = PageTheme.light);
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
      child: homeTheme == PageTheme.light
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
            flipX: homeTheme == PageTheme.dark,
            child: child,
          ),
        );
      },
    );
  }
}

class LightHomePage extends StatelessWidget {
  const LightHomePage({super.key, this.onFlip});
  final VoidCallback? onFlip;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        textTheme: TextTheme(
          displaySmall: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 5),
          ),
          child: Column(
            children: [
              const ProfileHeader(prompt: 'Hello,\nsunshine!'),
              const Spacer(),
              SvgPicture.asset(
                'assets/forest-day.svg',
                semanticsLabel: 'Forest',
                width: 300,
                height: 300,
              ),
              const Spacer(),
              BottomFlipIconButton(onFlip: onFlip),
            ],
          ),
        ),
      ),
    );
  }
}

class DarkHomePage extends StatelessWidget {
  const DarkHomePage({super.key, this.onFlip});
  final VoidCallback? onFlip;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          brightness: Brightness.dark,
          textTheme: TextTheme(
            displaySmall: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          )),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 5),
          ),
          child: Column(
            children: [
              const ProfileHeader(prompt: 'Good night,\nsleep tight!'),
              const Spacer(),
              SvgPicture.asset(
                'assets/forest-night.svg',
                semanticsLabel: 'Forest',
                width: 300,
                height: 300,
              ),
              const Spacer(),
              BottomFlipIconButton(onFlip: onFlip),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.prompt});
  final String prompt;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          Text(prompt, style: Theme.of(context).textTheme.displaySmall),
          const Spacer(),
          SvgPicture.asset(
            'assets/man.svg',
            semanticsLabel: 'Profile',
            width: 50,
            height: 50,
          ),
        ],
      ),
    );
  }
}

class BottomFlipIconButton extends StatelessWidget {
  const BottomFlipIconButton({super.key, this.onFlip});
  final VoidCallback? onFlip;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onFlip,
          icon: const Icon(Icons.flip),
        )
      ],
    );
  }
}
