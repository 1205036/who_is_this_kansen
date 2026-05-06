import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_this_kansen/progress/domain/entities/unlock_progress.dart';
import 'package:who_is_this_kansen/progress/domain/repositories/unlock_progress_repository.dart';

@LazySingleton(as: UnlockProgressRepository)
class SharedPreferencesUnlockProgressRepository
    implements UnlockProgressRepository {
  const SharedPreferencesUnlockProgressRepository({
    required SharedPreferencesAsync preferences,
  }) : _preferences = preferences;

  static const String _storageKey = 'unlock_progress.unlocked_kansen_ids';

  final SharedPreferencesAsync _preferences;

  @override
  Future<UnlockProgress> loadProgress() async {
    final unlockedIds = await _preferences.getStringList(_storageKey);
    return UnlockProgress(unlockedKansenIds: unlockedIds?.toSet() ?? const {});
  }

  @override
  Future<void> saveProgress(UnlockProgress progress) {
    final sortedIds = progress.unlockedKansenIds.toList()..sort();
    return _preferences.setStringList(_storageKey, sortedIds);
  }
}
