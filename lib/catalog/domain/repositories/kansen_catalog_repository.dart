import '../entities/kansen_catalog.dart';

abstract interface class KansenCatalogRepository {
  Future<KansenCatalog> loadCatalog();
}
