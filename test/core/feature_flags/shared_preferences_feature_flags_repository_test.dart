import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:who_is_this_kansen/core/feature_flags/data/shared_preferences_feature_flags_repository.dart';
import 'package:who_is_this_kansen/core/feature_flags/domain/feature_flags.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  SharedPreferencesFeatureFlagsRepository buildRepo() =>
      SharedPreferencesFeatureFlagsRepository(SharedPreferencesAsync());

  test('resolves flag defaults when no override is set', () async {
    final repo = buildRepo();
    await repo.load();

    expect(
      repo.valueOf(FeatureFlags.newKansenDetailScreen),
      FeatureFlags.newKansenDetailScreen.defaultValue,
    );
    expect(repo.valueOf(FeatureFlags.revealStyle), RevealStyle.dissolve);
    expect(repo.hasOverride(FeatureFlags.newKansenDetailScreen), isFalse);
  });

  test('applies a bool override and notifies listeners', () async {
    final repo = buildRepo();
    await repo.load();
    var notifications = 0;
    repo.addListener(() => notifications++);

    await repo.setOverride(FeatureFlags.newKansenDetailScreen, true);

    expect(repo.valueOf(FeatureFlags.newKansenDetailScreen), isTrue);
    expect(repo.hasOverride(FeatureFlags.newKansenDetailScreen), isTrue);
    expect(notifications, greaterThan(0));
  });

  test('applies a multi-value (enum) override', () async {
    final repo = buildRepo();

    await repo.setOverride(FeatureFlags.revealStyle, RevealStyle.wipe);

    expect(repo.valueOf(FeatureFlags.revealStyle), RevealStyle.wipe);
  });

  test('persists overrides across reloads', () async {
    final prefs = SharedPreferencesAsync();
    await SharedPreferencesFeatureFlagsRepository(
      prefs,
    ).setOverride(FeatureFlags.revealStyle, RevealStyle.fade);

    final reloaded = SharedPreferencesFeatureFlagsRepository(prefs);
    await reloaded.load();

    expect(reloaded.valueOf(FeatureFlags.revealStyle), RevealStyle.fade);
  });

  test('clearOverride reverts to default', () async {
    final repo = buildRepo();
    await repo.setOverride(FeatureFlags.newKansenDetailScreen, true);

    await repo.clearOverride(FeatureFlags.newKansenDetailScreen);

    expect(
      repo.valueOf(FeatureFlags.newKansenDetailScreen),
      FeatureFlags.newKansenDetailScreen.defaultValue,
    );
    expect(repo.hasOverride(FeatureFlags.newKansenDetailScreen), isFalse);
  });

  test('clearAllOverrides removes every override', () async {
    final repo = buildRepo();
    await repo.setOverride(FeatureFlags.newKansenDetailScreen, true);
    await repo.setOverride(FeatureFlags.revealStyle, RevealStyle.wipe);

    await repo.clearAllOverrides();

    expect(repo.hasOverride(FeatureFlags.newKansenDetailScreen), isFalse);
    expect(repo.hasOverride(FeatureFlags.revealStyle), isFalse);
    expect(repo.valueOf(FeatureFlags.revealStyle), RevealStyle.dissolve);
  });
}
