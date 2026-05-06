import 'package:injectable/injectable.dart';
import 'package:who_is_this_kansen/settings/domain/entities/app_theme_mode.dart';
import 'package:who_is_this_kansen/settings/domain/repositories/app_settings_repository.dart';

@injectable
class LoadThemeModePreference {
  const LoadThemeModePreference(this._repository);

  final AppSettingsRepository _repository;

  Future<AppThemeMode> call() {
    return _repository.loadThemeMode();
  }
}
