import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/catalog/catalog.dart';
import 'package:who_is_this_kansen/core/theme/kansen_theme_colors.dart';

void main() {
  test('decisive and ultra rare share the same rarity palette', () {
    expect(
      KansenThemeColors.rarityPalette(KansenRarity.decisive),
      KansenThemeColors.rarityPalette(KansenRarity.ultraRare),
    );
  });

  test('priority and super rare share the same rarity palette', () {
    expect(
      KansenThemeColors.rarityPalette(KansenRarity.priority),
      KansenThemeColors.rarityPalette(KansenRarity.superRare),
    );
  });
}
