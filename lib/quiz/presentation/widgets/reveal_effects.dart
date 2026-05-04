import 'dart:math' as math;

import 'package:flutter/material.dart';

class RevealClipper extends CustomClipper<Path> {
  const RevealClipper(this.progress);

  final double progress;

  @override
  Path getClip(Size size) {
    final eased = Curves.easeInOutCubicEmphasized.transform(
      progress.clamp(0, 1),
    );
    final radius =
        math.sqrt(size.width * size.width + size.height * size.height) * eased;
    return Path()..addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.48),
        radius: radius,
      ),
    );
  }

  @override
  bool shouldReclip(covariant RevealClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

class StageLightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.24),
        radius: 0.72,
        colors: [
          const Color(0xff4bb4ff).withValues(alpha: 0.24),
          const Color(0xff33d0a7).withValues(alpha: 0.09),
          Colors.transparent,
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..strokeWidth = 1;
    for (var y = size.height * 0.14; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 18), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class UnlockBurstPainter extends CustomPainter {
  const UnlockBurstPainter({required this.progress, required this.colors});

  final double progress;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final eased = Curves.easeOutCubic.transform(progress.clamp(0, 1));
    final fade = math.sin(progress * math.pi);
    final center = Offset(size.width * 0.5, size.height * 0.46);
    final radius = math.max(size.width, size.height) * (0.18 + eased * 0.62);
    final accent = colors.first;

    final bloom = Paint()
      ..shader = RadialGradient(
        colors: [
          accent.withValues(alpha: 0.18 * fade),
          colors.last.withValues(alpha: 0.1 * fade),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bloom);

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 + 3 * fade
      ..color = accent.withValues(alpha: 0.36 * fade);
    canvas.drawCircle(center, radius * 0.78, ring);

    final sparklePaint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 18; i += 1) {
      final seed = i * 0.61803398875;
      final angle = seed * math.pi * 2 + eased * math.pi * 0.45;
      final distance =
          radius * (0.22 + (i % 5) * 0.115 + eased * (0.18 + (i % 3) * 0.04));
      final position =
          center + Offset(math.cos(angle), math.sin(angle)) * distance;
      final localPhase = ((progress * 1.55) - (i % 6) * 0.08).clamp(0.0, 1.0);
      final sparkleFade = math.sin(localPhase * math.pi).clamp(0.0, 1.0);
      if (sparkleFade <= 0) continue;

      final color = colors[i % colors.length];
      final sparkleSize = (2.2 + (i % 4) * 0.75) * sparkleFade;
      sparklePaint.color = color.withValues(alpha: 0.72 * sparkleFade);
      canvas.drawPath(
        SparklePath(center: position, radius: sparkleSize).path,
        sparklePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant UnlockBurstPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.colors != colors;
  }
}

class SparklePath {
  SparklePath({required this.center, required this.radius});

  final Offset center;
  final double radius;

  Path get path {
    return Path()
      ..moveTo(center.dx, center.dy - radius * 1.75)
      ..lineTo(center.dx + radius * 0.42, center.dy - radius * 0.42)
      ..lineTo(center.dx + radius * 1.75, center.dy)
      ..lineTo(center.dx + radius * 0.42, center.dy + radius * 0.42)
      ..lineTo(center.dx, center.dy + radius * 1.75)
      ..lineTo(center.dx - radius * 0.42, center.dy + radius * 0.42)
      ..lineTo(center.dx - radius * 1.75, center.dy)
      ..lineTo(center.dx - radius * 0.42, center.dy - radius * 0.42)
      ..close();
  }
}
