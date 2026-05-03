import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/catalog/catalog.dart';

void main() {
  test('loads catalog through repository abstraction', () async {
    final catalog = _catalog();
    final repository = _FakeCatalogRepository(catalog);
    final useCase = LoadKansenCatalog(repository);

    final result = await useCase();

    expect(result, same(catalog));
    expect(repository.loadCount, 1);
  });
}

class _FakeCatalogRepository implements KansenCatalogRepository {
  _FakeCatalogRepository(this.catalog);

  final KansenCatalog catalog;
  var loadCount = 0;

  @override
  Future<KansenCatalog> loadCatalog() async {
    loadCount += 1;
    return catalog;
  }
}

KansenCatalog _catalog() {
  return KansenCatalog(
    schemaVersion: 1,
    generatedAt: DateTime.utc(2026, 5, 3),
    scope: const KansenCatalogScope(faction: 'iron_blood', entryCount: 0),
    entries: const [],
    skills: const [],
    assetSets: const [],
    assets: const [],
  );
}
