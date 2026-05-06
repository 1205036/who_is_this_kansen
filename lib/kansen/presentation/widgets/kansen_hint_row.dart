import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansen/presentation/widgets/kansen_hint_type.dart';

class KansenHintRow extends StatelessWidget {
  const KansenHintRow({
    super.key,
    required this.kansen,
    this.visibleHints = KansenHintType.values,
  });

  final KansenViewModel kansen;
  final List<KansenHintType> visibleHints;

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
              icon: CupertinoIcons.square_stack_3d_up,
              label: kansen.family.label,
            ),
            KansenHintType.rarity => KansenHintChip(
              icon: CupertinoIcons.star_fill,
              label: kansen.rarityLabel,
            ),
            KansenHintType.shipClass => KansenHintChip(
              icon: CupertinoIcons.shield_lefthalf_fill,
              label: kansen.shipClass,
            ),
          },
      ],
    );
  }
}

class KansenHintChip extends StatelessWidget {
  const KansenHintChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tokens = KansenThemeTokens.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.62),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: tokens.hairline.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: tokens.ink.withValues(alpha: 0.72)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
