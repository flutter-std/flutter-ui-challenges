import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CircleColors {
  static const Color background = Color.fromRGBO(120, 89, 188, 1);
  static const Color foreground = Color.fromRGBO(76, 47, 162, 1);
}

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
        body: Center(
          child: SizedBox(
            width: 300,
            child: CountdownAndRestart(),
          ),
        ),
      ),
    );
  }
}

class CountdownAndRestart extends StatefulWidget {
  const CountdownAndRestart({super.key});

  @override
  CountdownAndRestartState createState() => CountdownAndRestartState();
}

class CountdownAndRestartState extends State<CountdownAndRestart>
    with SingleTickerProviderStateMixin {
  static const _maxWidth = 300.0;
  static const _circleStrokeWidth = 20.0;
  static const _maxDuration = Duration(seconds: 10);
  late Ticker _ticker;
  Duration _elapsed = Duration.zero;
  double get _countDownProgress =>
      (_maxDuration.inMilliseconds - _elapsed.inMilliseconds) /
      _maxDuration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _startCountdown();
  }

  @override
  void dispose() {
    super.dispose();
    _ticker.dispose();
  }

  void _startCountdown() {
    _elapsed = Duration.zero;
    _ticker.stop();
    _ticker.start();
  }

  void _onTick(Duration duration) {
    setState(() {
      _elapsed = duration;
      if (_elapsed.inMilliseconds >= _maxDuration.inMilliseconds) {
        _ticker.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const circleRatio = _maxWidth - _circleStrokeWidth;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                CircleHolder(
                    builder: (context) {
                      return Center(
                        child: Text(
                          "${_maxDuration.inSeconds - _elapsed.inSeconds}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 100,
                            color: CircleColors.foreground,
                          ),
                        ),
                      );
                    },
                    ratio: circleRatio),
                CircleHolder(
                  builder: (context) {
                    return const CircularProgressIndicator(
                      color: CircleColors.background,
                      strokeWidth: _circleStrokeWidth,
                      value: 1,
                    );
                  },
                  ratio: circleRatio,
                ),
                CircleHolder(
                  builder: (context) {
                    return CircularProgressIndicator(
                      color: CircleColors.foreground,
                      strokeWidth: _circleStrokeWidth,
                      value: _countDownProgress,
                    );
                  },
                  ratio: circleRatio,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _startCountdown,
            child: const Text(
              'Restart',
              style: TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class CircleHolder extends StatelessWidget {
  final WidgetBuilder builder;
  final double ratio;
  const CircleHolder({super.key, required this.builder, required this.ratio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ratio,
      child: AspectRatio(
        aspectRatio: 1,
        child: builder(context),
      ),
    );
  }
}
