import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/core/theme/kansen_theme_colors.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';

class UnlockToast extends StatelessWidget {
  const UnlockToast({super.key, required this.kansen});

  final KansenViewModel kansen;

  @override
  Widget build(BuildContext context) {
    final tokens = KansenThemeTokens.of(context);
    final accent = KansenThemeColors.rarityAccent(kansen.rarity);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.cardSurface.withValues(alpha: 0.92),
        border: Border.all(color: accent.withValues(alpha: 0.32)),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(11, 8, 13, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.square_grid_2x2_fill, size: 16, color: accent),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                t.kansendex.unlockToast(name: kansen.name),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: tokens.ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
