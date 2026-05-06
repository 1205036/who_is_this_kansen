import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/kansen_catalog.dart';
import '../../domain/repositories/kansen_catalog_repository.dart';
import '../decoders/kansen_catalog_decoder.dart';

@LazySingleton(as: KansenCatalogRepository)
class AssetBundleKansenCatalogRepository implements KansenCatalogRepository {
  AssetBundleKansenCatalogRepository({required AssetBundle assetBundle})
    : _assetBundle = assetBundle;

  static const String _assetPath = 'assets/kansen/kansen_catalog.json';

  final AssetBundle _assetBundle;

  @override
  Future<KansenCatalog> loadCatalog() async {
    final jsonText = await _assetBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, Object?>) {
      throw const CatalogFormatException('Catalog root must be an object.');
    }
    return KansenCatalogDecoder().decode(decoded);
  }
}
