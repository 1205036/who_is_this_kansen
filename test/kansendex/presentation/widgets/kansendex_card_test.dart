import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/catalog/catalog.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/kansendex_card.dart';

void main() {
  testWidgets('locked card hides identity behind undiscovered state', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: KansenAppTheme.light(),
        home: Scaffold(
          body: SizedBox(
            width: 180,
            height: 250,
            child: KansendexCard(kansen: _z23, locked: true, onTap: null),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.lock), findsNothing);
    expect(find.byIcon(CupertinoIcons.lock_fill), findsOneWidget);
    expect(find.text('Undiscovered'), findsNothing);
    expect(find.text('Identify to unlock'), findsOneWidget);
    expect(find.text('Z23'), findsNothing);
    expect(find.text('Elite  Destroyer'), findsNothing);
    expect(find.text('????'), findsNothing);
  });
}

const _z23 = KansenViewModel(
  id: 'z23',
  name: 'Z23',
  family: KansenVariantFamily.base,
  rarity: KansenRarity.elite,
  rarityLabel: 'Elite',
  shipClass: 'Destroyer',
  factionLabel: 'Iron Blood',
  portraitAsset: 'assets/kansen/portraits/z28.webp',
  skillAssets: [],
);
