import 'package:injectable/injectable.dart';
import 'package:who_is_this_kansen/catalog/domain/usecases/load_kansen_catalog.dart';
import 'package:who_is_this_kansen/kansen/presentation/mappers/kansen_catalog_mapper.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';

/// Memoizes the catalog `Future` so every route resolves the same load.
/// Held as a `@lazySingleton` in the locator; routes call `.future` and
/// hand it to a `FutureBuilder` without re-triggering the asset read.
@lazySingleton
class KansenCatalogProvider {
  KansenCatalogProvider(this._loadCatalog, this._mapper);

  final LoadKansenCatalog _loadCatalog;
  final KansenCatalogMapper _mapper;
  List<KansenViewModel>? _cachedResult;

  /// Caches the *result* (not the Future) so every `.future` access returns
  /// a fresh `Future` rooted in the current zone. Caching the Future itself
  /// works in production but trips widget tests when a previous test's
  /// binding has been torn down — the Future object survives but its
  /// completion never reaches subscribers in the new binding.
  Future<List<KansenViewModel>> get future async {
    final cached = _cachedResult;
    if (cached != null) return cached;
    final catalog = await _loadCatalog();
    final result = _mapper.fromCatalog(catalog);
    _cachedResult = result;
    return result;
  }
}
