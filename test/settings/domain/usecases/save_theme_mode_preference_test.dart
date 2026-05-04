import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/settings/settings.dart';

void main() {
  test('saves theme preference through repository abstraction', () async {
    final repository = _FakeAppSettingsRepository(AppThemeMode.system);
    final useCase = SaveThemeModePreference(repository);

    await useCase(AppThemeMode.light);

    expect(repository.themeMode, AppThemeMode.light);
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
