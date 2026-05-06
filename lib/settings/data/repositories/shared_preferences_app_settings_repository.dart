import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_this_kansen/settings/domain/entities/app_theme_mode.dart';
import 'package:who_is_this_kansen/settings/domain/repositories/app_settings_repository.dart';

@LazySingleton(as: AppSettingsRepository)
class SharedPreferencesAppSettingsRepository implements AppSettingsRepository {
  const SharedPreferencesAppSettingsRepository({
    required SharedPreferencesAsync preferences,
  }) : _preferences = preferences;

  static const String _themeModeKey = 'app_settings.theme_mode';

  final SharedPreferencesAsync _preferences;

  @override
  Future<AppThemeMode> loadThemeMode() async {
    final storedThemeMode = await _preferences.getString(_themeModeKey);
    return AppThemeMode.fromStorageValue(storedThemeMode);
  }

  @override
  Future<void> saveThemeMode(AppThemeMode themeMode) {
    return _preferences.setString(_themeModeKey, themeMode.storageValue);
  }
}
