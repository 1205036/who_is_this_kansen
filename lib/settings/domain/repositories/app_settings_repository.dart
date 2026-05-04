import 'package:who_is_this_kansen/settings/domain/entities/app_theme_mode.dart';

abstract interface class AppSettingsRepository {
  Future<AppThemeMode> loadThemeMode();

  Future<void> saveThemeMode(AppThemeMode themeMode);
}
