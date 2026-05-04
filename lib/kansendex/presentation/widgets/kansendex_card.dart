import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/core/theme/kansen_theme_colors.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/kansen_art.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/rarity_edge.dart';

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
              if (widget.locked)
                _LockedKansenOverlay(accentColor: rarityAccent),
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
              if (widget.locked) _LockedCenterIcon(accentColor: rarityAccent),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: widget.locked
                    ? _LockedCardLabel(tokens: tokens)
                    : _UnlockedCardLabel(
                        tokens: tokens,
                        name: widget.kansen.name,
                        metadata:
                            '${widget.kansen.rarityLabel}  ${widget.kansen.shipClass}',
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
    return Opacity(opacity: 0.68, child: KansenSilhouetteImage(asset: asset));
  }
}

class _LockedKansenOverlay extends StatelessWidget {
  const _LockedKansenOverlay({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            tokens.cardSurface.withValues(alpha: 0.1),
            tokens.cardSurface.withValues(alpha: 0.52),
            Colors.black.withValues(alpha: 0.46),
          ],
        ),
      ),
      child: CustomPaint(
        painter: LockedScanlinePainter(
          lineColor: accentColor.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}

class _LockedCenterIcon extends StatelessWidget {
  const _LockedCenterIcon({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);

    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.34),
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
          'Identify to unlock',
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
