import 'package:flutter/material.dart';

class GlossPainter extends CustomPainter {
  const GlossPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final x = (size.width * 2.4 * progress) - size.width * 0.8;
    final path = Path()
      ..moveTo(x, 0)
      ..lineTo(x + size.width * 0.32, 0)
      ..lineTo(x - size.width * 0.08, size.height)
      ..lineTo(x - size.width * 0.4, size.height)
      ..close();
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          color.withValues(alpha: 0.18),
          Colors.white.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(path.getBounds());
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant GlossPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
