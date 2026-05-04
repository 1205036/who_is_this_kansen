import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';

class KansendexProgressHeaderDelegate extends SliverPersistentHeaderDelegate {
  const KansendexProgressHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 58;

  @override
  double get maxExtent => 58;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(
      context,
    ).scaffoldBackgroundColor.withValues(alpha: isDark ? 0.86 : 0.9);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(color: backgroundColor),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant KansendexProgressHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

class KansendexProgressHeader extends StatefulWidget {
  const KansendexProgressHeader({
    super.key,
    required this.unlockedCount,
    required this.totalCount,
  });

  final int unlockedCount;
  final int totalCount;

  @override
  State<KansendexProgressHeader> createState() =>
      _KansendexProgressHeaderState();
}

class _KansendexProgressHeaderState extends State<KansendexProgressHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glossController;

  @override
  void initState() {
    super.initState();
    _glossController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    )..repeat();
  }

  @override
  void dispose() {
    _glossController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);
    final progress = widget.totalCount == 0
        ? 0.0
        : widget.unlockedCount / widget.totalCount;
    final percent = (progress * 100).round();

    return Semantics(
      label:
          'Kansendex progress $percent percent, ${widget.unlockedCount} of ${widget.totalCount} unlocked',
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _glossController,
                builder: (context, child) {
                  return CustomPaint(
                    key: const ValueKey('kansendex-progress-bar'),
                    painter: KansendexProgressPainter(
                      progress: progress,
                      glossProgress: _glossController.value,
                      trackColor: tokens.hairline.withValues(alpha: 0.12),
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.74),
                      edgeColor: tokens.hairline.withValues(alpha: 0.2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$percent%',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: tokens.ink,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KansendexProgressPainter extends CustomPainter {
  const KansendexProgressPainter({
    required this.progress,
    required this.glossProgress,
    required this.trackColor,
    required this.fillColor,
    required this.edgeColor,
  });

  final double progress;
  final double glossProgress;
  final Color trackColor;
  final Color fillColor;
  final Color edgeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.height / 2);
    final trackRect = RRect.fromRectAndRadius(Offset.zero & size, radius);

    canvas.drawRRect(trackRect, Paint()..color = trackColor);

    final clampedProgress = progress.clamp(0.0, 1.0);
    if (clampedProgress > 0) {
      final fillWidth = size.width * clampedProgress;
      final fillRect = Rect.fromLTWH(0, 0, fillWidth, size.height);
      final fillRRect = RRect.fromRectAndRadius(fillRect, radius);
      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            fillColor.withValues(alpha: 0.72),
            fillColor,
            Colors.white.withValues(alpha: 0.32),
          ],
        ).createShader(fillRect);

      canvas.drawRRect(fillRRect, fillPaint);

      canvas.save();
      canvas.clipRRect(fillRRect);
      final glossWidth = size.width * 0.34;
      final glossX = (size.width + glossWidth) * glossProgress - glossWidth;
      final glossPath = Path()
        ..moveTo(glossX, 0)
        ..lineTo(glossX + glossWidth * 0.46, 0)
        ..lineTo(glossX + glossWidth, size.height)
        ..lineTo(glossX + glossWidth * 0.54, size.height)
        ..close();
      canvas.drawPath(
        glossPath,
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.transparent,
              Colors.white.withValues(alpha: 0.4),
              Colors.transparent,
            ],
          ).createShader(glossPath.getBounds()),
      );
      canvas.restore();
    }

    canvas.drawRRect(
      trackRect.deflate(0.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = edgeColor,
    );

    final notchPaint = Paint()..color = Colors.white.withValues(alpha: 0.14);
    const notchCount = 7;
    for (var index = 1; index < notchCount; index += 1) {
      final x = size.width * index / notchCount;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, size.height / 2),
            width: 2,
            height: size.height * 0.42,
          ),
          const Radius.circular(999),
        ),
        notchPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant KansendexProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.glossProgress != glossProgress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.edgeColor != edgeColor;
  }
}
