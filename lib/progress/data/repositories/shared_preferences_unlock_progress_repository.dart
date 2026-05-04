import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_this_kansen/progress/domain/entities/unlock_progress.dart';
import 'package:who_is_this_kansen/progress/domain/repositories/unlock_progress_repository.dart';

class SharedPreferencesUnlockProgressRepository
    implements UnlockProgressRepository {
  const SharedPreferencesUnlockProgressRepository({
    required SharedPreferencesAsync preferences,
    this.storageKey = 'unlock_progress.unlocked_kansen_ids',
  }) : _preferences = preferences;

  final SharedPreferencesAsync _preferences;
  final String storageKey;

  @override
  Future<UnlockProgress> loadProgress() async {
    final unlockedIds = await _preferences.getStringList(storageKey);
    return UnlockProgress(unlockedKansenIds: unlockedIds?.toSet() ?? const {});
  }

  @override
  Future<void> saveProgress(UnlockProgress progress) {
    final sortedIds = progress.unlockedKansenIds.toList()..sort();
    return _preferences.setStringList(storageKey, sortedIds);
  }
}
