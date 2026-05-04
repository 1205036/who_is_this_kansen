import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:who_is_this_kansen/settings/settings.dart';

void main() {
  test('loads system theme mode when no preference is stored', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    final repository = SharedPreferencesAppSettingsRepository(
      preferences: SharedPreferencesAsync(),
    );

    final themeMode = await repository.loadThemeMode();

    expect(themeMode, AppThemeMode.system);
  });

  test('saves and loads theme mode preference', () async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    final repository = SharedPreferencesAppSettingsRepository(
      preferences: SharedPreferencesAsync(),
    );

    await repository.saveThemeMode(AppThemeMode.dark);

    expect(await repository.loadThemeMode(), AppThemeMode.dark);
  });
}
