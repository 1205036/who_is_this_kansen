// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/services.dart' as _i281;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../app/presentation/notifications/unlock_toast_cubit.dart' as _i823;
import '../../catalog/data/datasources/asset_bundle_kansen_catalog_repository.dart'
    as _i749;
import '../../catalog/domain/repositories/kansen_catalog_repository.dart'
    as _i389;
import '../../catalog/domain/usecases/load_kansen_catalog.dart' as _i542;
import '../../catalog/presentation/kansen_catalog_provider.dart' as _i719;
import '../../kansen/presentation/mappers/kansen_catalog_mapper.dart' as _i719;
import '../../progress/data/repositories/shared_preferences_unlock_progress_repository.dart'
    as _i586;
import '../../progress/domain/repositories/unlock_progress_repository.dart'
    as _i745;
import '../../progress/domain/usecases/load_unlock_progress.dart' as _i595;
import '../../progress/domain/usecases/unlock_kansen.dart' as _i521;
import '../../progress/presentation/bloc/unlock_progress_cubit.dart' as _i763;
import '../../quiz/presentation/bloc/quiz_prompt_cubit_factory.dart' as _i267;
import '../../settings/data/repositories/shared_preferences_app_settings_repository.dart'
    as _i21;
import '../../settings/domain/repositories/app_settings_repository.dart'
    as _i516;
import '../../settings/domain/usecases/load_theme_mode_preference.dart'
    as _i610;
import '../../settings/domain/usecases/save_theme_mode_preference.dart'
    as _i209;
import '../../settings/presentation/bloc/theme_mode_cubit.dart' as _i250;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i823.UnlockToastCubit>(() => _i823.UnlockToastCubit());
    gh.lazySingleton<_i460.SharedPreferencesAsync>(
      () => appModule.sharedPreferences,
    );
    gh.lazySingleton<_i281.AssetBundle>(() => appModule.assetBundle);
    gh.lazySingleton<_i719.KansenCatalogMapper>(
      () => const _i719.KansenCatalogMapper(),
    );
    gh.lazySingleton<_i267.QuizPromptCubitFactory>(
      () => const _i267.QuizPromptCubitFactory(),
    );
    gh.lazySingleton<_i745.UnlockProgressRepository>(
      () => _i586.SharedPreferencesUnlockProgressRepository(
        preferences: gh<_i460.SharedPreferencesAsync>(),
      ),
    );
    gh.lazySingleton<_i516.AppSettingsRepository>(
      () => _i21.SharedPreferencesAppSettingsRepository(
        preferences: gh<_i460.SharedPreferencesAsync>(),
      ),
    );
    gh.lazySingleton<_i389.KansenCatalogRepository>(
      () => _i749.AssetBundleKansenCatalogRepository(
        assetBundle: gh<_i281.AssetBundle>(),
      ),
    );
    gh.factory<_i610.LoadThemeModePreference>(
      () => _i610.LoadThemeModePreference(gh<_i516.AppSettingsRepository>()),
    );
    gh.factory<_i209.SaveThemeModePreference>(
      () => _i209.SaveThemeModePreference(gh<_i516.AppSettingsRepository>()),
    );
    gh.lazySingleton<_i250.ThemeModeCubit>(
      () => _i250.ThemeModeCubit(
        loadThemeModePreference: gh<_i610.LoadThemeModePreference>(),
        saveThemeModePreference: gh<_i209.SaveThemeModePreference>(),
      ),
    );
    gh.factory<_i595.LoadUnlockProgress>(
      () => _i595.LoadUnlockProgress(gh<_i745.UnlockProgressRepository>()),
    );
    gh.factory<_i521.UnlockKansen>(
      () => _i521.UnlockKansen(gh<_i745.UnlockProgressRepository>()),
    );
    gh.factory<_i542.LoadKansenCatalog>(
      () => _i542.LoadKansenCatalog(gh<_i389.KansenCatalogRepository>()),
    );
    gh.lazySingleton<_i763.UnlockProgressCubit>(
      () => _i763.UnlockProgressCubit(
        loadUnlockProgress: gh<_i595.LoadUnlockProgress>(),
        unlockKansen: gh<_i521.UnlockKansen>(),
      ),
    );
    gh.lazySingleton<_i719.KansenCatalogProvider>(
      () => _i719.KansenCatalogProvider(
        gh<_i542.LoadKansenCatalog>(),
        gh<_i719.KansenCatalogMapper>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
