import '../../domain/entities/kansen_catalog.dart';

class KansenCatalogDecoder {
  KansenCatalog decode(Map<String, Object?> json) {
    final catalog = KansenCatalog(
      schemaVersion: _requiredInt(json, 'schemaVersion'),
      generatedAt: DateTime.parse(_requiredString(json, 'generatedAt')),
      scope: _decodeScope(_requiredMap(json, 'scope')),
      entries: _requiredList(
        json,
        'entries',
      ).map((item) => _decodeEntry(_asMap(item, 'entries item'))).toList(),
      skills: _requiredList(
        json,
        'skills',
      ).map((item) => _decodeSkill(_asMap(item, 'skills item'))).toList(),
      assetSets: _requiredList(
        json,
        'assetSets',
      ).map((item) => _decodeAssetSet(_asMap(item, 'assetSets item'))).toList(),
      assets: _requiredList(
        json,
        'assets',
      ).map((item) => _decodeAsset(_asMap(item, 'assets item'))).toList(),
    );
    _validateCatalog(catalog);
    return catalog;
  }

  KansenCatalogScope _decodeScope(Map<String, Object?> json) {
    return KansenCatalogScope(
      faction: _requiredString(json, 'faction'),
      entryCount: _requiredInt(json, 'entryCount'),
    );
  }

  KansenEntry _decodeEntry(Map<String, Object?> json) {
    return KansenEntry(
      id: _requiredString(json, 'id'),
      displayName: _requiredString(json, 'displayName'),
      answerName: _requiredString(json, 'answerName'),
      factionId: _requiredString(json, 'factionId'),
      rarity: _enumById(
        KansenRarity.values,
        _requiredString(json, 'rarityId'),
        (rarity) => rarity.id,
        'rarityId',
      ),
      rarityLabel: _requiredString(json, 'rarityLabel'),
      shipTypeId: _requiredString(json, 'shipTypeId'),
      shipTypeLabel: _requiredString(json, 'shipTypeLabel'),
      variantFamily: _enumById(
        KansenVariantFamily.values,
        _requiredString(json, 'variantFamily'),
        (family) => family.id,
        'variantFamily',
      ),
      parentKansenId: _optionalString(json, 'parentKansenId'),
      assetSetId: _requiredString(json, 'assetSetId'),
      skillIds: _stringList(json, 'skillIds'),
      hints: _decodeHints(_requiredMap(json, 'hints')),
      detail: _decodeDetail(_requiredMap(json, 'detail')),
      sortOrder: _optionalInt(json, 'sortOrder'),
      relatedVariantIds: _stringList(json, 'relatedVariantIds', optional: true),
      availability: _stringList(json, 'availability', optional: true),
      artist: _optionalString(json, 'artist'),
      voiceActor: _optionalString(json, 'voiceActor'),
    );
  }

  KansenHints _decodeHints(Map<String, Object?> json) {
    return KansenHints(
      variantFamily: _enumById(
        KansenVariantFamily.values,
        _requiredString(json, 'variantFamily'),
        (family) => family.id,
        'hints.variantFamily',
      ).label,
      rarity: _requiredString(json, 'rarity'),
      shipType: _requiredString(json, 'shipType'),
    );
  }

  KansenDetail _decodeDetail(Map<String, Object?> json) {
    return KansenDetail(
      summaryFields: _requiredList(json, 'summaryFields')
          .map((item) => _decodeDetailField(_asMap(item, 'summaryFields item')))
          .toList(),
      statBlocks: _requiredList(json, 'statBlocks')
          .map((item) => _decodeStatBlock(_asMap(item, 'statBlocks item')))
          .toList(),
      acquisition: _requiredList(json, 'acquisition')
          .map((item) => _decodeDetailField(_asMap(item, 'acquisition item')))
          .toList(),
    );
  }

  KansenDetailField _decodeDetailField(Map<String, Object?> json) {
    return KansenDetailField(
      id: _optionalString(json, 'id') ?? _normalizedFieldId(json),
      label: _requiredString(json, 'label'),
      value: _requiredString(json, 'value'),
    );
  }

  KansenStatBlock _decodeStatBlock(Map<String, Object?> json) {
    return KansenStatBlock(
      label: _requiredString(json, 'label'),
      stats: _requiredList(
        json,
        'stats',
      ).map((item) => _decodeStat(_asMap(item, 'stats item'))).toList(),
    );
  }

  KansenStat _decodeStat(Map<String, Object?> json) {
    return KansenStat(
      id: _requiredString(json, 'id'),
      label: _requiredString(json, 'label'),
      value: _requiredString(json, 'value'),
    );
  }

  KansenSkill _decodeSkill(Map<String, Object?> json) {
    return KansenSkill(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      iconAssetId: _requiredString(json, 'iconAssetId'),
      description: _requiredString(json, 'description'),
      levelText: _optionalString(json, 'levelText'),
      colorHint: _optionalString(json, 'colorHint'),
    );
  }

  KansenAssetSet _decodeAssetSet(Map<String, Object?> json) {
    return KansenAssetSet(
      id: _requiredString(json, 'id'),
      portraitAssetId: _requiredString(json, 'portraitAssetId'),
      thumbnailAssetId: _requiredString(json, 'thumbnailAssetId'),
      skillIconAssetIds: _stringList(json, 'skillIconAssetIds'),
      galleryAssetIds: _stringList(json, 'galleryAssetIds', optional: true),
      retrofitPortraitAssetId: _optionalString(json, 'retrofitPortraitAssetId'),
    );
  }

  GeneratedCatalogAsset _decodeAsset(Map<String, Object?> json) {
    return GeneratedCatalogAsset(
      id: _requiredString(json, 'id'),
      kind: _enumById(
        GeneratedAssetKind.values,
        _requiredString(json, 'kind'),
        (kind) => kind.id,
        'kind',
      ),
      path: _requiredString(json, 'path'),
      width: _requiredInt(json, 'width'),
      height: _requiredInt(json, 'height'),
      format: _enumById(
        GeneratedAssetFormat.values,
        _requiredString(json, 'format'),
        (format) => format.id,
        'format',
      ),
      bytes: _requiredInt(json, 'bytes'),
    );
  }

  void _validateCatalog(KansenCatalog catalog) {
    if (catalog.schemaVersion != 1) {
      throw CatalogFormatException(
        'Unsupported catalog schemaVersion ${catalog.schemaVersion}.',
      );
    }
    if (catalog.entries.length != catalog.scope.entryCount) {
      throw CatalogFormatException(
        'Catalog entry count ${catalog.entries.length} does not match '
        'scope.entryCount ${catalog.scope.entryCount}.',
      );
    }

    final entryIds = _uniqueIds(catalog.entries.map((entry) => entry.id));
    final skillIds = _uniqueIds(catalog.skills.map((skill) => skill.id));
    final assetSetIds = _uniqueIds(catalog.assetSets.map((set) => set.id));
    final assetIds = _uniqueIds(catalog.assets.map((asset) => asset.id));

    for (final entry in catalog.entries) {
      if (!assetSetIds.contains(entry.assetSetId)) {
        throw CatalogFormatException(
          'Entry ${entry.id} references missing asset set ${entry.assetSetId}.',
        );
      }
      if (entry.parentKansenId case final parentId?) {
        if (!entryIds.contains(parentId)) {
          throw CatalogFormatException(
            'Entry ${entry.id} references missing parent $parentId.',
          );
        }
      }
      for (final skillId in entry.skillIds) {
        if (!skillIds.contains(skillId)) {
          throw CatalogFormatException(
            'Entry ${entry.id} references missing skill $skillId.',
          );
        }
      }
    }

    for (final skill in catalog.skills) {
      if (!assetIds.contains(skill.iconAssetId)) {
        throw CatalogFormatException(
          'Skill ${skill.id} references missing icon ${skill.iconAssetId}.',
        );
      }
    }

    for (final assetSet in catalog.assetSets) {
      if (!assetIds.contains(assetSet.portraitAssetId)) {
        throw CatalogFormatException(
          'Asset set ${assetSet.id} references missing portrait '
          '${assetSet.portraitAssetId}.',
        );
      }
      if (!assetIds.contains(assetSet.thumbnailAssetId)) {
        throw CatalogFormatException(
          'Asset set ${assetSet.id} references missing thumbnail '
          '${assetSet.thumbnailAssetId}.',
        );
      }
      for (final assetId in assetSet.skillIconAssetIds) {
        if (!assetIds.contains(assetId)) {
          throw CatalogFormatException(
            'Asset set ${assetSet.id} references missing skill icon $assetId.',
          );
        }
      }
    }

    for (final asset in catalog.assets) {
      if (!asset.path.startsWith('research/generated_images/')) {
        throw CatalogFormatException(
          'Asset ${asset.id} has a non-generated path ${asset.path}.',
        );
      }
      if (asset.path.contains('sample_pages') ||
          asset.path.contains('koumakan') ||
          asset.path.contains('http://') ||
          asset.path.contains('https://')) {
        throw CatalogFormatException(
          'Asset ${asset.id} exposes source/provenance path ${asset.path}.',
        );
      }
    }
  }

  Set<String> _uniqueIds(Iterable<String> ids) {
    final seen = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) {
        throw CatalogFormatException('Duplicate catalog ID $id.');
      }
    }
    return seen;
  }

  String _normalizedFieldId(Map<String, Object?> json) {
    final label = _requiredString(json, 'label');
    return label
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');
  }

  String _requiredString(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) return value;
    throw CatalogFormatException('Missing required string "$key".');
  }

  String? _optionalString(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is String) return value.trim().isEmpty ? null : value;
    throw CatalogFormatException('Expected optional string "$key".');
  }

  int _requiredInt(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is int) return value;
    throw CatalogFormatException('Missing required int "$key".');
  }

  int? _optionalInt(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value == null) return null;
    if (value is int) return value;
    throw CatalogFormatException('Expected optional int "$key".');
  }

  Map<String, Object?> _requiredMap(Map<String, Object?> json, String key) {
    return _asMap(json[key], key);
  }

  Map<String, Object?> _asMap(Object? value, String label) {
    if (value is Map<String, Object?>) return value;
    if (value is Map) return value.cast<String, Object?>();
    throw CatalogFormatException('Expected object "$label".');
  }

  List<Object?> _requiredList(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is List) return value.cast<Object?>();
    throw CatalogFormatException('Missing required list "$key".');
  }

  List<String> _stringList(
    Map<String, Object?> json,
    String key, {
    bool optional = false,
  }) {
    final value = json[key];
    if (value == null && optional) return const [];
    if (value is! List) {
      throw CatalogFormatException('Missing required string list "$key".');
    }
    return value.map((item) {
      if (item is String && item.trim().isNotEmpty) return item;
      throw CatalogFormatException('Invalid item in string list "$key".');
    }).toList();
  }

  T _enumById<T>(
    List<T> values,
    String id,
    String Function(T value) idOf,
    String fieldName,
  ) {
    for (final value in values) {
      if (idOf(value) == id) return value;
    }
    throw CatalogFormatException('Unsupported $fieldName "$id".');
  }
}
