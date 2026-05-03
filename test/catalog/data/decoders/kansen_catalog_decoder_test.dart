import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/catalog/catalog.dart';

void main() {
  test('decodes a valid generated catalog shape', () {
    final catalog = KansenCatalogDecoder().decode(_catalogJson());

    expect(catalog.schemaVersion, 1);
    expect(catalog.scope.faction, 'iron_blood');
    expect(catalog.entries.single.displayName, 'Bismarck Zwei');
    expect(catalog.entries.single.rarity, KansenRarity.ultraRare);
    expect(catalog.entries.single.variantFamily, KansenVariantFamily.zwei);
    expect(catalog.entries.single.parentKansenId, isNull);
    expect(catalog.skills.single.description, isNotEmpty);
    expect(
      catalog.assetsById['bismarck_zwei_portrait']?.kind,
      GeneratedAssetKind.portrait,
    );
    expect(
      catalog.assetsById['bismarck_zwei_portrait']?.format,
      GeneratedAssetFormat.webp,
    );
    expect(
      catalog.assetsById['bismarck_zwei_portrait']?.path,
      'research/generated_images/portraits/bismarck_zwei.webp',
    );
  });

  test('rejects unresolved skill references', () {
    final json = _catalogJson();
    final entries = json['entries']! as List<Map<String, Object?>>;
    entries.single['skillIds'] = ['missing_skill'];

    expect(
      () => KansenCatalogDecoder().decode(json),
      throwsA(isA<CatalogFormatException>()),
    );
  });

  test('rejects source paths in generated assets', () {
    final json = _catalogJson();
    final assets = json['assets']! as List<Map<String, Object?>>;
    assets.first['path'] =
        'research/koumakan/sample_pages/Bismarck Zwei_files/Bismarck_Zwei.png';

    expect(
      () => KansenCatalogDecoder().decode(json),
      throwsA(isA<CatalogFormatException>()),
    );
  });
}

Map<String, Object?> _catalogJson() {
  return {
    'schemaVersion': 1,
    'generatedAt': '2026-05-03T00:00:00.000Z',
    'scope': {'faction': 'iron_blood', 'entryCount': 1},
    'entries': [
      {
        'id': 'bismarck_zwei',
        'displayName': 'Bismarck Zwei',
        'answerName': 'Bismarck Zwei',
        'factionId': 'iron_blood',
        'rarityId': 'ultra_rare',
        'rarityLabel': 'Ultra Rare',
        'shipTypeId': 'battleship',
        'shipTypeLabel': 'Battleship',
        'variantFamily': 'zwei',
        'parentKansenId': null,
        'assetSetId': 'bismarck_zwei',
        'skillIds': ['bismarck_zwei_skill_1'],
        'hints': {
          'variantFamily': 'zwei',
          'rarity': 'Ultra Rare',
          'shipType': 'Battleship',
        },
        'detail': {
          'summaryFields': [
            {'id': 'class', 'label': 'Class', 'value': 'Bismarck'},
          ],
          'statBlocks': <Object?>[],
          'acquisition': [
            {'label': 'Construction Time', 'value': '06:00:00'},
          ],
        },
        'sortOrder': 1,
      },
    ],
    'skills': [
      {
        'id': 'bismarck_zwei_skill_1',
        'name': 'Calamitous Voidflame',
        'iconAssetId': 'bismarck_zwei_skill_1_icon',
        'description': 'Increases this ship FP.',
      },
    ],
    'assetSets': [
      {
        'id': 'bismarck_zwei',
        'portraitAssetId': 'bismarck_zwei_portrait',
        'thumbnailAssetId': 'bismarck_zwei_thumbnail',
        'skillIconAssetIds': ['bismarck_zwei_skill_1_icon'],
      },
    ],
    'assets': [
      {
        'id': 'bismarck_zwei_portrait',
        'kind': 'portrait',
        'path': 'research/generated_images/portraits/bismarck_zwei.webp',
        'width': 2048,
        'height': 1536,
        'format': 'webp',
        'bytes': 450000,
      },
      {
        'id': 'bismarck_zwei_thumbnail',
        'kind': 'thumbnail',
        'path': 'research/generated_images/thumbnails/bismarck_zwei.webp',
        'width': 192,
        'height': 256,
        'format': 'webp',
        'bytes': 30000,
      },
      {
        'id': 'bismarck_zwei_skill_1_icon',
        'kind': 'skill_icon',
        'path':
            'research/generated_images/skill_icons/bismarck_zwei_skill_1.webp',
        'width': 128,
        'height': 128,
        'format': 'webp',
        'bytes': 12000,
      },
    ],
  };
}
