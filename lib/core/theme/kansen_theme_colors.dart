import 'package:flutter/material.dart';
import 'package:who_is_this_kansen/catalog/catalog.dart';

class KansenThemeColors {
  const KansenThemeColors._();

  static Color rarityAccent(KansenRarity rarity) {
    return rarityPalette(rarity).accent;
  }

  static List<Color> rarityGradient(KansenRarity rarity) {
    return rarityPalette(rarity).gradient;
  }

  static KansenRarityPalette rarityPalette(KansenRarity rarity) {
    return switch (rarity) {
      KansenRarity.decisive ||
      KansenRarity.ultraRare => KansenRarityPalette.highest,
      KansenRarity.priority ||
      KansenRarity.superRare => KansenRarityPalette.superRare,
      KansenRarity.elite => KansenRarityPalette.elite,
      KansenRarity.rare => KansenRarityPalette.rare,
      KansenRarity.common => KansenRarityPalette.common,
      KansenRarity.unknown => KansenRarityPalette.unknown,
    };
  }
}

enum KansenRarityPalette {
  highest(
    accent: Color(0xffc9a7ff),
    gradient: [
      Color(0xffffaebc),
      Color(0xffffe18f),
      Color(0xff91e6d1),
      Color(0xffbca7ff),
    ],
  ),
  superRare(
    accent: Color(0xffe4bd67),
    gradient: [Color(0xfff0d083), Color(0xffba8744)],
  ),
  elite(
    accent: Color(0xffb7a3d9),
    gradient: [Color(0xffd1c1ee), Color(0xff9279c2)],
  ),
  rare(
    accent: Color(0xff86aee8),
    gradient: [Color(0xffa8c6f3), Color(0xff638fd2)],
  ),
  common(
    accent: Color(0xffa7b0b8),
    gradient: [Color(0xffc0c7ce), Color(0xff848e98)],
  ),
  unknown(
    accent: Color(0xffaeb8c2),
    gradient: [Color(0xffc2ccd4), Color(0xff8d98a2)],
  );

  const KansenRarityPalette({required this.accent, required this.gradient});

  final Color accent;
  final List<Color> gradient;
}
