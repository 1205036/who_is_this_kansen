import 'package:injectable/injectable.dart';
import 'package:who_is_this_kansen/settings/domain/entities/app_theme_mode.dart';
import 'package:who_is_this_kansen/settings/domain/repositories/app_settings_repository.dart';

@injectable
class SaveThemeModePreference {
  const SaveThemeModePreference(this._repository);

  final AppSettingsRepository _repository;

  Future<void> call(AppThemeMode themeMode) {
    return _repository.saveThemeMode(themeMode);
  }
}
