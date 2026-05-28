import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/kansendex_empty_state.dart';

class KansendexBootSplashScreen extends StatefulWidget {
  const KansendexBootSplashScreen({
    super.key,
    this.duration = const Duration(milliseconds: 1800),
    this.onComplete,
  });

  /// How long the splash stays on screen before [onComplete] fires. Tests
  /// can pass `Duration.zero` to skip the animation pause.
  final Duration duration;

  /// Called once `duration` has elapsed and the widget is still mounted.
  /// The router uses this to navigate to the landing route.
  final VoidCallback? onComplete;

  @override
  State<KansendexBootSplashScreen> createState() =>
      _KansendexBootSplashScreenState();
}

class _KansendexBootSplashScreenState extends State<KansendexBootSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _runnerController;
  late final AnimationController _stepController;

  @override
  void initState() {
    super.initState();
    _runnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    )..repeat();
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    )..repeat(reverse: true);
    if (widget.onComplete != null) {
      if (widget.duration <= Duration.zero) {
        // Fire after the first frame is rendered so the navigation runs
        // without depending on Timer scheduling. This keeps `Duration.zero`
        // deterministic under widget-test fake clocks.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          widget.onComplete?.call();
        });
      } else {
        Future<void>.delayed(widget.duration, () {
          if (!mounted) return;
          widget.onComplete?.call();
        });
      }
    }
  }

  @override
  void dispose() {
    _runnerController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);

    return Scaffold(
      backgroundColor: tokens.stageGradient.last,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _BootBackdrop(animation: _runnerController),
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                _SplashTitle(tokens: tokens),
                const Spacer(),
                _RunnerStage(
                  runnerAnimation: _runnerController,
                  stepAnimation: _stepController,
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashTitle extends StatelessWidget {
  const _SplashTitle({required this.tokens});

  final KansenThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Text(
      t.app.title,
      key: const ValueKey('kansendex-boot-title'),
      textAlign: TextAlign.center,
      style: GoogleFonts.baloo2(
        color: tokens.ink,
        fontSize: 36,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _RunnerStage extends StatelessWidget {
  const _RunnerStage({
    required this.runnerAnimation,
    required this.stepAnimation,
  });

  final Animation<double> runnerAnimation;
  final Animation<double> stepAnimation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: Listenable.merge([runnerAnimation, stepAnimation]),
        builder: (context, child) {
          return CustomPaint(
            painter: _RunnerGroundPainter(progress: runnerAnimation.value),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final travel = width + 260;
                final left = -210 + travel * runnerAnimation.value;
                final bob = math.sin(stepAnimation.value * math.pi * 2) * 7.0;
                final tilt =
                    math.sin(stepAnimation.value * math.pi * 2) * 0.025;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: left,
                      bottom: 28 + bob,
                      child: Transform.rotate(angle: tilt, child: child),
                    ),
                  ],
                );
              },
            ),
          );
        },
        child: const _RunningMascot(),
      ),
    );
  }
}

class _RunningMascot extends StatelessWidget {
  const _RunningMascot();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      KansendexEmptyState.assetPath,
      key: const ValueKey('kansendex-boot-runner'),
      width: 230,
      fit: BoxFit.contain,
    );
  }
}

class _BootBackdrop extends StatelessWidget {
  const _BootBackdrop({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: tokens.stageGradient,
        ),
      ),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _BootBackdropPainter(
              progress: animation.value,
              tokens: tokens,
            ),
            child: child,
          );
        },
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BootBackdropPainter extends CustomPainter {
  const _BootBackdropPainter({required this.progress, required this.tokens});

  final double progress;
  final KansenThemeTokens tokens;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.48);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = tokens.hairline.withValues(alpha: 0.07);
    for (var index = 0; index < 4; index += 1) {
      final radius = 72 + index * 54 + progress * 18;
      canvas.drawCircle(center, radius, ringPaint);
    }

    final sparklePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xffd8474c).withValues(alpha: 0.42);
    for (var index = 0; index < 8; index += 1) {
      final seed = index / 8;
      final x = (seed * size.width * 1.7 - progress * size.width) % size.width;
      final y = size.height * (0.18 + (index % 5) * 0.11);
      canvas.drawLine(Offset(x, y), Offset(x + 12, y - 5), sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BootBackdropPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.tokens != tokens;
  }
}

class _RunnerGroundPainter extends CustomPainter {
  const _RunnerGroundPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height - 18;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.18);
    canvas.drawLine(
      Offset(28, baseY),
      Offset(size.width - 28, baseY),
      linePaint,
    );

    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xffd8474c).withValues(alpha: 0.48);
    for (var index = 0; index < 8; index += 1) {
      final x = (index * 92 - progress * 184) % (size.width + 92);
      canvas.drawLine(
        Offset(x, baseY + 12),
        Offset(x + 34, baseY + 12),
        dashPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RunnerGroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
