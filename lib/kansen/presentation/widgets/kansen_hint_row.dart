import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/kansen_hint_type.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/gloss_painter.dart';

class KansenHintRow extends StatelessWidget {
  const KansenHintRow({
    super.key,
    required this.kansen,
    this.visibleHints = KansenHintType.values,
    this.startRevealed = false,
  });

  final KansenViewModel kansen;
  final List<KansenHintType> visibleHints;

  /// When `true`, every chip is rendered already revealed (no tap required).
  /// Used by the Kansen detail screen where the answer is already known —
  /// the chip motion is reserved for the quiz, where revealing a hint is a
  /// gameplay choice.
  final bool startRevealed;

  @override
  Widget build(BuildContext context) {
    if (visibleHints.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final hint in visibleHints)
          switch (hint) {
            KansenHintType.variantFamily => KansenHintChip(
              key: ValueKey('hint-${kansen.id}-variantFamily'),
              icon: CupertinoIcons.square_stack_3d_up,
              label: kansen.family.label,
              startRevealed: startRevealed,
            ),
            KansenHintType.rarity => KansenHintChip(
              key: ValueKey('hint-${kansen.id}-rarity'),
              icon: CupertinoIcons.star_fill,
              label: kansen.rarityLabel,
              startRevealed: startRevealed,
            ),
            KansenHintType.shipClass => KansenHintChip(
              key: ValueKey('hint-${kansen.id}-shipClass'),
              icon: CupertinoIcons.shield_lefthalf_fill,
              label: kansen.shipClass,
              startRevealed: startRevealed,
            ),
            KansenHintType.faction => KansenHintChip(
              key: ValueKey('hint-${kansen.id}-faction'),
              icon: CupertinoIcons.flag_fill,
              label: kansen.factionLabel,
              startRevealed: startRevealed,
            ),
          },
      ],
    );
  }
}

class KansenHintChip extends StatefulWidget {
  const KansenHintChip({
    super.key,
    required this.icon,
    required this.label,
    this.startRevealed = false,
  });

  final IconData icon;
  final String label;
  final bool startRevealed;

  @override
  State<KansenHintChip> createState() => _KansenHintChipState();
}

class _KansenHintChipState extends State<KansenHintChip>
    with TickerProviderStateMixin {
  late final AnimationController _revealController;
  late final AnimationController _glossController;
  late final AnimationController _punchController;
  late final Listenable _allAnimations;
  late bool _revealed;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 540),
      value: widget.startRevealed ? 1 : 0,
    );
    _glossController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _punchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _allAnimations = Listenable.merge([
      _revealController,
      _glossController,
      _punchController,
    ]);
    _revealed = widget.startRevealed;
  }

  @override
  void dispose() {
    _revealController.dispose();
    _glossController.dispose();
    _punchController.dispose();
    super.dispose();
  }

  Future<void> _reveal() async {
    if (_revealed) return;
    setState(() => _revealed = true);
    _revealController.forward(from: 0);
    await _punchController.forward(from: 0);
    if (!mounted) return;
    await _punchController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = KansenThemeTokens.of(context);
    final accent = Theme.of(context).colorScheme.primary;

    return Semantics(
      button: !_revealed,
      label: _revealed ? widget.label : 'Tap to reveal hint',
      child: GestureDetector(
        onTap: _revealed ? null : _reveal,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _allAnimations,
          builder: (context, _) {
            final reveal = Curves.easeOutCubic.transform(
              _revealController.value,
            );
            final mask = 1 - Curves.easeInCubic.transform(
              _revealController.value,
            );
            // Tiny scale punch when the chip flips from masked to revealed.
            final punch = Curves.easeOutBack.transform(_punchController.value);
            return Transform.scale(
              scale: 1 + punch * 0.05,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: isDark ? 0.08 : 0.62,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: tokens.hairline.withValues(alpha: 0.12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.icon,
                        size: 15,
                        color: tokens.ink.withValues(
                          alpha: 0.42 + 0.30 * reveal,
                        ),
                      ),
                      const SizedBox(width: 6),
                      _LabelArea(
                        label: widget.label,
                        revealOpacity: reveal,
                        maskOpacity: mask,
                        glossValue: _glossController.value,
                        tokens: tokens,
                        accent: accent,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LabelArea extends StatelessWidget {
  const _LabelArea({
    required this.label,
    required this.revealOpacity,
    required this.maskOpacity,
    required this.glossValue,
    required this.tokens,
    required this.accent,
    required this.isDark,
  });

  final String label;
  final double revealOpacity;
  final double maskOpacity;
  final double glossValue;
  final KansenThemeTokens tokens;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Layout-driving label — always present so the chip's width matches
        // the revealed shape, but its opacity is tied to the reveal animation
        // so the answer never bleeds through the mask.
        Opacity(
          opacity: revealOpacity,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
        if (maskOpacity > 0)
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: maskOpacity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: _HintMaskFace(
                    glossValue: glossValue,
                    tokens: tokens,
                    accent: accent,
                    isDark: isDark,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HintMaskFace extends StatelessWidget {
  const _HintMaskFace({
    required this.glossValue,
    required this.tokens,
    required this.accent,
    required this.isDark,
  });

  final double glossValue;
  final KansenThemeTokens tokens;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color.lerp(tokens.cardSurface, Colors.white, 0.10) ??
                      tokens.cardSurface,
                  Color.lerp(tokens.cardSurface, Colors.black, 0.20) ??
                      tokens.cardSurface,
                ]
              : [
                  Color.lerp(tokens.cardSurface, Colors.white, 0.50) ??
                      tokens.cardSurface,
                  Color.lerp(tokens.cardSurface, Colors.black, 0.06) ??
                      tokens.cardSurface,
                ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GlossPainter(progress: glossValue, color: accent),
            ),
          ),
          Text(
            '?',
            style: TextStyle(
              color: tokens.ink.withValues(alpha: 0.66),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
