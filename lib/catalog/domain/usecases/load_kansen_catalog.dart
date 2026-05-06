import 'package:injectable/injectable.dart';

import '../entities/kansen_catalog.dart';
import '../repositories/kansen_catalog_repository.dart';

@injectable
class LoadKansenCatalog {
  const LoadKansenCatalog(this._repository);

  final KansenCatalogRepository _repository;

  Future<KansenCatalog> call() {
    return _repository.loadCatalog();
  }
}
