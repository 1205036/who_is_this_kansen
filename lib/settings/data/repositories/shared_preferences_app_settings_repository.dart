import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_this_kansen/settings/domain/entities/app_theme_mode.dart';
import 'package:who_is_this_kansen/settings/domain/repositories/app_settings_repository.dart';

class SharedPreferencesAppSettingsRepository implements AppSettingsRepository {
  const SharedPreferencesAppSettingsRepository({
    required SharedPreferencesAsync preferences,
    this.themeModeKey = 'app_settings.theme_mode',
  }) : _preferences = preferences;

  final SharedPreferencesAsync _preferences;
  final String themeModeKey;

  @override
  Future<AppThemeMode> loadThemeMode() async {
    final storedThemeMode = await _preferences.getString(themeModeKey);
    return AppThemeMode.fromStorageValue(storedThemeMode);
  }

  @override
  Future<void> saveThemeMode(AppThemeMode themeMode) {
    return _preferences.setString(themeModeKey, themeMode.storageValue);
  }
}
