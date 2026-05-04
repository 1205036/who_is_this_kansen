import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/catalog/catalog.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansendex/presentation/screens/kansendex_screen.dart';
import 'package:who_is_this_kansen/kansendex/presentation/widgets/kansendex_card.dart';
import 'package:who_is_this_kansen/progress/progress.dart';

void main() {
  setUpAll(() {
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  testWidgets('filters dex cards by search text', (tester) async {
    final repository = _FakeUnlockProgressRepository(
      const UnlockProgress(unlockedKansenIds: {'z23', 'z28'}),
    );
    final cubit = UnlockProgressCubit(
      loadUnlockProgress: LoadUnlockProgress(repository),
      unlockKansen: UnlockKansen(repository),
    )..load();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      TranslationProvider(
        child: BlocProvider.value(
          value: cubit,
          child: MaterialApp(
            theme: KansenAppTheme.light(),
            home: Scaffold(
              body: KansendexScreen(
                kansenFuture: Future.value(const [_z23, _z28, _bismarck]),
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Z23'), findsOneWidget);
    expect(find.text('Z28'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('kansendex-search-field')),
      'bismarck',
    );
    await tester.pump();

    expect(find.byType(KansendexCard), findsNothing);

    await tester.enterText(
      find.byKey(const ValueKey('kansendex-search-field')),
      '28',
    );
    await tester.pump();

    expect(find.text('Z23'), findsNothing);
    expect(find.text('Z28'), findsOneWidget);

    await tester.tap(find.text(t.kansendex.segmentLocked));
    await tester.pump(const Duration(milliseconds: 320));

    // Search field stays in the tree but fades to hidden + becomes
    // non-interactive when the Locked tab is selected. find.ancestor
    // returns ancestors closest-first, so .first matches the wrapper
    // we add directly around the search field.
    final searchOpacity = tester.firstWidget<AnimatedOpacity>(
      find.ancestor(
        of: find.byKey(const ValueKey('kansendex-search-field')),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    expect(searchOpacity.opacity, 0.0);
    final searchIgnore = tester.firstWidget<IgnorePointer>(
      find.ancestor(
        of: find.byKey(const ValueKey('kansendex-search-field')),
        matching: find.byType(IgnorePointer),
      ),
    );
    expect(searchIgnore.ignoring, isTrue);
  });
}

const _z23 = KansenViewModel(
  id: 'z23',
  name: 'Z23',
  family: KansenVariantFamily.base,
  rarity: KansenRarity.elite,
  rarityLabel: 'Elite',
  shipClass: 'Destroyer',
  portraitAsset: 'research/generated_images/portraits/z28.webp',
  skillAssets: [],
);

const _z28 = KansenViewModel(
  id: 'z28',
  name: 'Z28',
  family: KansenVariantFamily.base,
  rarity: KansenRarity.rare,
  rarityLabel: 'Rare',
  shipClass: 'Destroyer',
  portraitAsset: 'research/generated_images/portraits/z28.webp',
  skillAssets: [],
);

const _bismarck = KansenViewModel(
  id: 'bismarck',
  name: 'Bismarck',
  family: KansenVariantFamily.base,
  rarity: KansenRarity.superRare,
  rarityLabel: 'Super Rare',
  shipClass: 'Battleship',
  portraitAsset: 'research/generated_images/portraits/z28.webp',
  skillAssets: [],
);

class _FakeUnlockProgressRepository implements UnlockProgressRepository {
  _FakeUnlockProgressRepository(this.progress);

  UnlockProgress progress;

  @override
  Future<UnlockProgress> loadProgress() async {
    return progress;
  }

  @override
  Future<void> saveProgress(UnlockProgress progress) async {
    this.progress = progress;
  }
}
