import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/kansendex/presentation/models/kansendex_filter.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/gloss_painter.dart';

class KansendexStickyHeader extends StatelessWidget {
  const KansendexStickyHeader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(
      context,
    ).scaffoldBackgroundColor.withValues(alpha: isDark ? 0.86 : 0.9);

    // The header height is driven by the inner content so it can shrink
    // smoothly when the progress row is hidden on the Locked tab.
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: DecoratedBox(
          decoration: BoxDecoration(color: backgroundColor),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            child: child,
          ),
        ),
      ),
    );
  }
}

class KansendexProgressHeader extends StatefulWidget {
  const KansendexProgressHeader({
    super.key,
    required this.unlockedCount,
    required this.totalCount,
    required this.searchController,
    required this.filter,
    required this.onFilterChanged,
  });

  final int unlockedCount;
  final int totalCount;
  final TextEditingController searchController;
  final KansendexFilter filter;
  final ValueChanged<KansendexFilter> onFilterChanged;

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
      duration: const Duration(milliseconds: 2200),
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
    final searchVisible = widget.filter != KansendexFilter.locked;
    final progress = widget.totalCount == 0
        ? 0.0
        : widget.unlockedCount / widget.totalCount;
    final percent = (progress * 100).round();

    final progressVisible = widget.filter != KansendexFilter.locked;

    return Semantics(
      label: t.kansendex.semanticProgress(
        percent: '$percent',
        unlocked: '${widget.unlockedCount}',
        total: '${widget.totalCount}',
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search + segment row sits above the progress bar so the
          // controls the user actually interacts with stay closer to the
          // top of the screen.
          SizedBox(
            height: 38,
            child: Row(
              children: [
                Expanded(
                  child: IgnorePointer(
                    ignoring: !searchVisible,
                    child: AnimatedOpacity(
                      opacity: searchVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: TextField(
                        key: const ValueKey('kansendex-search-field'),
                        controller: widget.searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: tokens.cardSurface.withValues(alpha: 0.72),
                          hintText: t.kansendex.search,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 18,
                            color: tokens.ink.withValues(alpha: 0.58),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 9,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide(
                              color: tokens.hairline.withValues(alpha: 0.12),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide(
                              color: tokens.hairline.withValues(alpha: 0.12),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(999),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.56),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 214,
                  child: _KansendexFilterSegment(
                    filter: widget.filter,
                    onChanged: widget.onFilterChanged,
                  ),
                ),
              ],
            ),
          ),
          // Progress bar's contents fade out on the Locked tab but the slot
          // stays reserved — same pattern as the search field above — so the
          // grid below does not shift when the user switches tabs.
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 32,
              child: IgnorePointer(
                ignoring: !progressVisible,
                child: AnimatedOpacity(
                  opacity: progressVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 14,
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 750),
                            curve: Curves.easeOutCubic,
                            tween: Tween(begin: 0, end: progress),
                            builder: (context, animatedProgress, _) {
                              return AnimatedBuilder(
                                animation: _glossController,
                                builder: (context, child) {
                                  return SizedBox.expand(
                                    child: CustomPaint(
                                      key: const ValueKey(
                                        'kansendex-progress-bar',
                                      ),
                                      painter: KansendexProgressPainter(
                                        progress: animatedProgress,
                                        glossProgress: _glossController.value,
                                        trackColor: tokens.hairline.withValues(
                                          alpha: 0.18,
                                        ),
                                        fillColor: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        edgeColor: tokens.hairline.withValues(
                                          alpha: 0.28,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Center(
                        child: Text(
                          '$percent%',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.baloo2(
                            color: tokens.ink,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KansendexFilterSegment extends StatelessWidget {
  const _KansendexFilterSegment({
    required this.filter,
    required this.onChanged,
  });

  final KansendexFilter filter;
  final ValueChanged<KansendexFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SegmentedButton<KansendexFilter>(
      key: const ValueKey('kansendex-filter-segment'),
      showSelectedIcon: false,
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.standard,
        minimumSize: const WidgetStatePropertyAll(Size(0, 38)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 6),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return tokens.segmentThumb;
          }
          return Colors.white.withValues(alpha: isDark ? 0.08 : 0.42);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (isDark && states.contains(WidgetState.selected)) {
            return Colors.black;
          }
          return tokens.ink;
        }),
        side: WidgetStatePropertyAll(
          BorderSide(color: tokens.hairline.withValues(alpha: 0.12)),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
        ),
      ),
      segments: [
        ButtonSegment(
          value: KansendexFilter.all,
          label: Text(t.kansendex.segmentAll),
        ),
        ButtonSegment(
          value: KansendexFilter.locked,
          label: Text(t.kansendex.segmentLocked),
        ),
        ButtonSegment(
          value: KansendexFilter.unlocked,
          label: Text(t.kansendex.segmentUnlocked),
        ),
      ],
      selected: {filter},
      onSelectionChanged: (selected) => onChanged(selected.single),
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
    final fullRect = Offset.zero & size;
    final trackRRect = RRect.fromRectAndRadius(fullRect, radius);

    canvas.drawRRect(
      trackRRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            trackColor.withValues(alpha: 0.55),
            trackColor,
          ],
        ).createShader(fullRect),
    );

    canvas.save();
    canvas.clipRRect(trackRRect);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.45),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.22),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromLTWH(0, 0, size.width, size.height * 0.45),
        ),
    );
    canvas.restore();

    final clampedProgress = progress.clamp(0.0, 1.0);
    if (clampedProgress > 0) {
      final minVisibleWidth = size.height * 1.05;
      final rawFillWidth = size.width * clampedProgress;
      final fillWidth = rawFillWidth < minVisibleWidth
          ? minVisibleWidth.clamp(0.0, size.width)
          : rawFillWidth;
      final fillRect = Rect.fromLTWH(0, 0, fillWidth, size.height);
      final fillRRect = RRect.fromRectAndRadius(fillRect, radius);

      canvas.drawRRect(
        fillRRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.lerp(fillColor, Colors.white, 0.45) ?? fillColor,
              fillColor,
              Color.lerp(fillColor, Colors.black, 0.22) ?? fillColor,
            ],
            stops: const [0.0, 0.55, 1.0],
          ).createShader(fillRect),
      );

      canvas.save();
      canvas.clipRRect(fillRRect);

      final highlightRect = Rect.fromLTWH(
        0,
        0,
        fillWidth,
        size.height * 0.5,
      );
      canvas.drawRect(
        highlightRect,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.55),
              Colors.transparent,
            ],
          ).createShader(highlightRect),
      );

      // Reuse the same `GlossPainter` the cards use, scaled to the fill area
      // so direction, slant, and gradient stay visually unified across the
      // Kansendex surfaces.
      GlossPainter(
        progress: glossProgress,
        color: fillColor,
      ).paint(canvas, Size(fillWidth, size.height));

      canvas.restore();

      if (fillWidth < size.width - 0.5) {
        final glowCenter = Offset(
          fillWidth - size.height * 0.18,
          size.height / 2,
        );
        canvas.drawCircle(
          glowCenter,
          size.height * 0.32,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.6)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
      }
    }

    canvas.drawRRect(
      trackRRect.deflate(0.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = edgeColor,
    );
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
