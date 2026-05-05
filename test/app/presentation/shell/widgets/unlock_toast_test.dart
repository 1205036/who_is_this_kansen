import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/unlock_toast.dart';
import 'package:who_is_this_kansen/catalog/catalog.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';

void main() {
  testWidgets('shows added to Dex toast copy', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: KansenAppTheme.light(),
        home: const Scaffold(body: UnlockToast(kansen: _z23)),
      ),
    );

    expect(find.text('Z23 added to Dex'), findsOneWidget);
  });
}

const _z23 = KansenViewModel(
  id: 'z23',
  name: 'Z23',
  family: KansenVariantFamily.base,
  rarity: KansenRarity.elite,
  rarityLabel: 'Elite',
  shipClass: 'Destroyer',
  portraitAsset: 'assets/kansen/portraits/z28.webp',
  skillAssets: [],
);
