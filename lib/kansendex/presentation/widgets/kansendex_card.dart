import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/core/theme/kansen_theme_colors.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/kansen_art.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/rarity_edge.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/gloss_painter.dart';

class KansendexCard extends StatefulWidget {
  const KansendexCard({
    super.key,
    required this.kansen,
    required this.locked,
    required this.onTap,
  });

  final KansenViewModel kansen;
  final bool locked;
  final VoidCallback? onTap;

  @override
  State<KansendexCard> createState() => _KansendexCardState();
}

class _KansendexCardState extends State<KansendexCard>
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
    final rarityAccent = KansenThemeColors.rarityAccent(widget.kansen.rarity);

    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: tokens.hairline.withValues(alpha: 0.12)),
            color: tokens.cardSurface,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.locked
                  ? _LockedKansenArt(asset: widget.kansen.portraitAsset)
                  : Hero(
                      tag: widget.kansen.name,
                      child: KansenArt(asset: widget.kansen.portraitAsset),
                    ),
              if (!widget.locked)
                AnimatedBuilder(
                  animation: _glossController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: GlossPainter(
                        progress: _glossController.value,
                        color: rarityAccent,
                      ),
                    );
                  },
                ),
              if (widget.locked) const _LockedKansenOverlay(),
              // Rarity-coloured edge accent leaks the rarity hint on locked
              // cards, so it is rendered only for unlocked entries.
              if (!widget.locked)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: RarityEdge(
                    colors: KansenThemeColors.rarityGradient(
                      widget.kansen.rarity,
                    ),
                  ),
                ),
              if (widget.locked) const _LockedCenterIcon(),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: widget.locked
                    ? _LockedCardLabel(tokens: tokens)
                    : _UnlockedCardLabel(
                        tokens: tokens,
                        name: widget.kansen.name,
                        metadata: widget.kansen.shipClass,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LockedKansenArt extends StatelessWidget {
  const _LockedKansenArt({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Opacity(
      opacity: isDark ? 0.38 : 0.18,
      child: KansenSilhouetteImage(asset: asset),
    );
  }
}

class _LockedKansenOverlay extends StatelessWidget {
  const _LockedKansenOverlay();

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            tokens.cardSurface.withValues(alpha: isDark ? 0.26 : 0.96),
            tokens.cardSurface.withValues(alpha: isDark ? 0.58 : 0.99),
            Colors.black.withValues(alpha: isDark ? 0.5 : 0.86),
          ],
        ),
      ),
      // Scanline uses a neutral ink colour so the overlay does not telegraph
      // the kansen's rarity through its tint.
      child: CustomPaint(
        painter: LockedScanlinePainter(
          lineColor: tokens.ink.withValues(alpha: 0.06),
        ),
      ),
    );
  }
}

class _LockedCenterIcon extends StatelessWidget {
  const _LockedCenterIcon();

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);

    // Halo around the lock icon used to be tinted with the kansen's rarity
    // accent, which gave away the rarity hint at a glance. The bloom is now a
    // neutral ink wash so locked cards look identical regardless of rarity.
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: tokens.ink.withValues(alpha: 0.18),
              blurRadius: 30,
              spreadRadius: 6,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.56),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Icon(
          CupertinoIcons.lock_fill,
          size: 54,
          color: tokens.ink.withValues(alpha: 0.78),
        ),
      ),
    );
  }
}

class _LockedCardLabel extends StatelessWidget {
  const _LockedCardLabel({required this.tokens});

  final KansenThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          t.kansendex.lockedCardLabel,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: tokens.ink.withValues(alpha: 0.82),
            fontFamily: '.SF Pro Rounded',
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.32),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnlockedCardLabel extends StatelessWidget {
  const _UnlockedCardLabel({
    required this.tokens,
    required this.name,
    required this.metadata,
  });

  final KansenThemeTokens tokens;
  final String name;
  final String metadata;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        Text(
          metadata,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: tokens.ink.withValues(alpha: 0.62),
          ),
        ),
      ],
    );
  }
}

class LockedScanlinePainter extends CustomPainter {
  const LockedScanlinePainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    for (var y = 0.0; y < size.height; y += 9) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant LockedScanlinePainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}
