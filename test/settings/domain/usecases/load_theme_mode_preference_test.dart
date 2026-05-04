import 'package:flutter_test/flutter_test.dart';
import 'package:who_is_this_kansen/settings/settings.dart';

void main() {
  test('loads theme preference through repository abstraction', () async {
    final repository = _FakeAppSettingsRepository(AppThemeMode.dark);
    final useCase = LoadThemeModePreference(repository);

    final result = await useCase();

    expect(result, AppThemeMode.dark);
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
