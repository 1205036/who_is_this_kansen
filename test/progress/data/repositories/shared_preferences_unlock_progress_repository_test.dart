import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:who_is_this_kansen/progress/progress.dart';

void main() {
  const storageKey = 'test.unlocked_ids';

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('loads empty progress when storage has no value', () async {
    final repository = SharedPreferencesUnlockProgressRepository(
      preferences: SharedPreferencesAsync(),
      storageKey: storageKey,
    );

    final progress = await repository.loadProgress();

    expect(progress.unlockedKansenIds, isEmpty);
  });

  test('loads unlocked IDs from storage', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData({
          storageKey: <String>['z23', 'bismarck_zwei'],
        });
    final repository = SharedPreferencesUnlockProgressRepository(
      preferences: SharedPreferencesAsync(),
      storageKey: storageKey,
    );

    final progress = await repository.loadProgress();

    expect(progress.unlockedKansenIds, {'z23', 'bismarck_zwei'});
  });

  test('saves unlocked IDs in stable sorted order', () async {
    final preferences = SharedPreferencesAsync();
    final repository = SharedPreferencesUnlockProgressRepository(
      preferences: preferences,
      storageKey: storageKey,
    );

    await repository.saveProgress(
      const UnlockProgress(unlockedKansenIds: {'z23', 'bismarck_zwei', 'agir'}),
    );

    expect(await preferences.getStringList(storageKey), [
      'agir',
      'bismarck_zwei',
      'z23',
    ]);
  });
}
