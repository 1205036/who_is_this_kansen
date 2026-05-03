class KansenCatalog {
  const KansenCatalog({
    required this.schemaVersion,
    required this.generatedAt,
    required this.scope,
    required this.entries,
    required this.skills,
    required this.assetSets,
    required this.assets,
  });

  final int schemaVersion;
  final DateTime generatedAt;
  final KansenCatalogScope scope;
  final List<KansenEntry> entries;
  final List<KansenSkill> skills;
  final List<KansenAssetSet> assetSets;
  final List<GeneratedCatalogAsset> assets;

  Map<String, KansenEntry> get entriesById => {
    for (final entry in entries) entry.id: entry,
  };

  Map<String, KansenSkill> get skillsById => {
    for (final skill in skills) skill.id: skill,
  };

  Map<String, KansenAssetSet> get assetSetsById => {
    for (final assetSet in assetSets) assetSet.id: assetSet,
  };

  Map<String, GeneratedCatalogAsset> get assetsById => {
    for (final asset in assets) asset.id: asset,
  };
}

class KansenCatalogScope {
  const KansenCatalogScope({required this.faction, required this.entryCount});

  final String faction;
  final int entryCount;
}

class KansenEntry {
  const KansenEntry({
    required this.id,
    required this.displayName,
    required this.answerName,
    required this.factionId,
    required this.rarity,
    required this.rarityLabel,
    required this.shipTypeId,
    required this.shipTypeLabel,
    required this.variantFamily,
    required this.parentKansenId,
    required this.assetSetId,
    required this.skillIds,
    required this.hints,
    required this.detail,
    required this.sortOrder,
    required this.relatedVariantIds,
    required this.availability,
    required this.artist,
    required this.voiceActor,
  });

  final String id;
  final String displayName;
  final String answerName;
  final String factionId;
  final KansenRarity rarity;
  final String rarityLabel;
  final String shipTypeId;
  final String shipTypeLabel;
  final KansenVariantFamily variantFamily;
  final String? parentKansenId;
  final String assetSetId;
  final List<String> skillIds;
  final KansenHints hints;
  final KansenDetail detail;
  final int? sortOrder;
  final List<String> relatedVariantIds;
  final List<String> availability;
  final String? artist;
  final String? voiceActor;
}

class KansenHints {
  const KansenHints({
    required this.variantFamily,
    required this.rarity,
    required this.shipType,
  });

  final String variantFamily;
  final String rarity;
  final String shipType;
}

class KansenDetail {
  const KansenDetail({
    required this.summaryFields,
    required this.statBlocks,
    required this.acquisition,
  });

  final List<KansenDetailField> summaryFields;
  final List<KansenStatBlock> statBlocks;
  final List<KansenDetailField> acquisition;
}

class KansenDetailField {
  const KansenDetailField({
    required this.id,
    required this.label,
    required this.value,
  });

  final String id;
  final String label;
  final String value;
}

class KansenStatBlock {
  const KansenStatBlock({required this.label, required this.stats});

  final String label;
  final List<KansenStat> stats;
}

class KansenStat {
  const KansenStat({
    required this.id,
    required this.label,
    required this.value,
  });

  final String id;
  final String label;
  final String value;
}

class KansenSkill {
  const KansenSkill({
    required this.id,
    required this.name,
    required this.iconAssetId,
    required this.description,
    required this.levelText,
    required this.colorHint,
  });

  final String id;
  final String name;
  final String iconAssetId;
  final String description;
  final String? levelText;
  final String? colorHint;
}

class KansenAssetSet {
  const KansenAssetSet({
    required this.id,
    required this.portraitAssetId,
    required this.thumbnailAssetId,
    required this.skillIconAssetIds,
    required this.galleryAssetIds,
    required this.retrofitPortraitAssetId,
  });

  final String id;
  final String portraitAssetId;
  final String thumbnailAssetId;
  final List<String> skillIconAssetIds;
  final List<String> galleryAssetIds;
  final String? retrofitPortraitAssetId;
}

class GeneratedCatalogAsset {
  const GeneratedCatalogAsset({
    required this.id,
    required this.kind,
    required this.path,
    required this.width,
    required this.height,
    required this.format,
    required this.bytes,
  });

  final String id;
  final GeneratedAssetKind kind;
  final String path;
  final int width;
  final int height;
  final GeneratedAssetFormat format;
  final int bytes;
}

enum KansenRarity {
  decisive(id: 'decisive', label: 'Decisive'),
  priority(id: 'priority', label: 'Priority'),
  ultraRare(id: 'ultra_rare', label: 'Ultra Rare'),
  superRare(id: 'super_rare', label: 'Super Rare'),
  elite(id: 'elite', label: 'Elite'),
  rare(id: 'rare', label: 'Rare'),
  common(id: 'common', label: 'Common'),
  unknown(id: 'unknown', label: 'Unknown');

  const KansenRarity({required this.id, required this.label});

  final String id;
  final String label;
}

enum KansenVariantFamily {
  base(id: 'base', label: 'Base'),
  muse(id: 'muse', label: 'Muse'),
  little(id: 'little', label: 'Little'),
  zwei(id: 'zwei', label: 'Zwei'),
  retrofit(id: 'retrofit', label: 'Retrofit'),
  meta(id: 'meta', label: 'META'),
  other(id: 'other', label: 'Other');

  const KansenVariantFamily({required this.id, required this.label});

  final String id;
  final String label;
}

enum GeneratedAssetKind {
  portrait(id: 'portrait'),
  thumbnail(id: 'thumbnail'),
  skillIcon(id: 'skill_icon'),
  gallery(id: 'gallery');

  const GeneratedAssetKind({required this.id});

  final String id;
}

enum GeneratedAssetFormat {
  webp(id: 'webp'),
  png(id: 'png');

  const GeneratedAssetFormat({required this.id});

  final String id;
}

class CatalogFormatException implements Exception {
  const CatalogFormatException(this.message);

  final String message;

  @override
  String toString() => 'CatalogFormatException: $message';
}
