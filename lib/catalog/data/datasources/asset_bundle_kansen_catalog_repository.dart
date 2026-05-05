import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/kansen_catalog.dart';
import '../../domain/repositories/kansen_catalog_repository.dart';
import '../decoders/kansen_catalog_decoder.dart';

class AssetBundleKansenCatalogRepository implements KansenCatalogRepository {
  AssetBundleKansenCatalogRepository({
    required AssetBundle assetBundle,
    this.assetPath = 'assets/kansen/kansen_catalog.json',
  }) : _assetBundle = assetBundle;

  final AssetBundle _assetBundle;
  final String assetPath;

  @override
  Future<KansenCatalog> loadCatalog() async {
    final jsonText = await _assetBundle.loadString(assetPath);
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, Object?>) {
      throw const CatalogFormatException('Catalog root must be an object.');
    }
    return KansenCatalogDecoder().decode(decoded);
  }
}
