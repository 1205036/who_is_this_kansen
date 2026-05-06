import 'package:who_is_this_kansen/catalog/catalog.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';

class KansenCatalogMapper {
  const KansenCatalogMapper();

  List<KansenViewModel> fromCatalog(KansenCatalog catalog) {
    final assetSetsById = catalog.assetSetsById;
    final assetsById = catalog.assetsById;

    return catalog.entries.map((entry) {
      final assetSet = assetSetsById[entry.assetSetId];
      final portraitAsset = assetsById[assetSet?.portraitAssetId]?.path;
      final skillAssets = assetSet?.skillIconAssetIds
          .map((assetId) => assetsById[assetId]?.path)
          .whereType<String>()
          .toList();

      return KansenViewModel(
        id: entry.id,
        name: entry.answerName,
        family: entry.variantFamily,
        rarity: entry.rarity,
        rarityLabel: entry.rarityLabel,
        shipClass: entry.shipTypeLabel,
        factionLabel: _factionLabel(entry.factionId),
        portraitAsset: portraitAsset ?? '',
        skillAssets: skillAssets ?? const [],
      );
    }).toList();
  }

  // The catalog stores faction as a stable id (e.g. `iron_blood`); the UI
  // wants the human-readable label. Title-case the underscore-separated id
  // so future factions (e.g. `eagle_union`) work without explicit mapping.
  String _factionLabel(String factionId) {
    if (factionId.isEmpty) return '';
    return factionId
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join(' ');
  }
}
