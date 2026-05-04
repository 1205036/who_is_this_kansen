import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = isDark ? KansenThemeTokens.dark : KansenThemeTokens.light;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: tokens.backdropGradient,
        ),
      ),
      child: CustomPaint(
        painter: AppBackdropPainter(isDark: isDark),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class AppBackdropPainter extends CustomPainter {
  const AppBackdropPainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final tokens = isDark ? KansenThemeTokens.dark : KansenThemeTokens.light;
    final paint = Paint()
      ..color = tokens.backdropLine.withValues(alpha: isDark ? 0.035 : 0.045);
    for (var x = -size.height; x < size.width; x += 34) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AppBackdropPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
