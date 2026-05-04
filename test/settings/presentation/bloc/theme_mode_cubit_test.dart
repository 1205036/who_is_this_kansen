import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/settings/settings.dart';

void main() {
  test('loads stored theme preference', () async {
    final repository = _FakeAppSettingsRepository(AppThemeMode.dark);
    final cubit = ThemeModeCubit(
      loadThemeModePreference: LoadThemeModePreference(repository),
      saveThemeModePreference: SaveThemeModePreference(repository),
    );

    await cubit.load();

    expect(cubit.state.preference, AppThemeMode.dark);
    expect(cubit.state.materialThemeMode, ThemeMode.dark);
    expect(cubit.state.status, ThemeModeStatus.ready);

    await cubit.close();
  });

  test('saves selected material theme mode', () async {
    final repository = _FakeAppSettingsRepository(AppThemeMode.system);
    final cubit = ThemeModeCubit(
      loadThemeModePreference: LoadThemeModePreference(repository),
      saveThemeModePreference: SaveThemeModePreference(repository),
    );

    await cubit.setThemeMode(ThemeMode.light);

    expect(repository.themeMode, AppThemeMode.light);
    expect(cubit.state.preference, AppThemeMode.light);
    expect(cubit.state.materialThemeMode, ThemeMode.light);

    await cubit.close();
  });
}

class _FakeAppSettingsRepository implements AppSettingsRepository {
  _FakeAppSettingsRepository(this.themeMode);

  AppThemeMode themeMode;

  @override
  Future<AppThemeMode> loadThemeMode() async {
    return themeMode;
  }

  @override
  Future<void> saveThemeMode(AppThemeMode themeMode) async {
    this.themeMode = themeMode;
  }
}
