import 'dart:math' as math;

import 'package:flutter/material.dart';

class LandingTitleArt extends StatefulWidget {
  const LandingTitleArt({super.key});

  static const assetPath = 'assets/kansen/ui/kansendex_landing_title.webp';

  @override
  State<LandingTitleArt> createState() => _LandingTitleArtState();
}

class _LandingTitleArtState extends State<LandingTitleArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motionController;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();
  }

  @override
  void dispose() {
    _motionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _motionController,
      builder: (context, child) {
        final phase = _motionController.value * math.pi * 2;
        final bob = math.sin(phase) * 5;
        final sway = math.sin(phase + math.pi / 3) * 0.012;
        final scale = 1 + math.sin(phase + math.pi) * 0.012;

        return Transform.translate(
          offset: Offset(0, bob),
          child: Transform.rotate(
            angle: sway,
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
      child: Image.asset(
        LandingTitleArt.assetPath,
        key: const ValueKey('landing-title-art'),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
