import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/core/theme/kansen_theme_colors.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/kansen_art.dart';
import 'package:who_is_this_kansen/quiz/presentation/widgets/reveal_effects.dart';

class PromptStage extends StatefulWidget {
  const PromptStage({
    super.key,
    required this.kansen,
    required this.revealed,
    required this.revealAnimation,
  });

  final KansenViewModel kansen;
  final bool revealed;
  final Animation<double> revealAnimation;

  @override
  State<PromptStage> createState() => _PromptStageState();
}

class _PromptStageState extends State<PromptStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _idleController;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);

    return AspectRatio(
      aspectRatio: 0.82,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: tokens.hairline.withValues(alpha: 0.12)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: tokens.stageGradient,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: _idleController,
                builder: (context, child) {
                  final drift = math.sin(_idleController.value * math.pi) * 8;
                  return Transform.translate(
                    offset: Offset(drift * 0.25, -drift * 0.18),
                    child: child,
                  );
                },
                child: CustomPaint(painter: StageLightPainter()),
              ),
              AnimatedBuilder(
                animation: Listenable.merge([
                  _idleController,
                  widget.revealAnimation,
                ]),
                builder: (context, child) {
                  final pulse =
                      1 + math.sin(_idleController.value * math.pi) * 0.018;
                  final artOpacity = Curves.easeInOutCubic.transform(
                    widget.revealAnimation.value.clamp(0, 1),
                  );
                  return Transform.scale(
                    scale: pulse,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        KansenSilhouetteImage(
                          asset: widget.kansen.portraitAsset,
                        ),
                        ClipPath(
                          clipper: RevealClipper(widget.revealAnimation.value),
                          child: Opacity(
                            opacity: widget.revealed ? 1 : artOpacity,
                            child: KansenArt(
                              asset: widget.kansen.portraitAsset,
                            ),
                          ),
                        ),
                        IgnorePointer(
                          child: CustomPaint(
                            painter: UnlockBurstPainter(
                              progress: widget.revealAnimation.value,
                              colors: KansenThemeColors.rarityGradient(
                                widget.kansen.rarity,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: AnimatedOpacity(
                  opacity: widget.revealed ? 1 : 0,
                  duration: const Duration(milliseconds: 420),
                  child: Text(
                    widget.kansen.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
