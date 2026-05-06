import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:who_is_this_kansen/settings/domain/entities/app_theme_mode.dart';
import 'package:who_is_this_kansen/settings/domain/usecases/load_theme_mode_preference.dart';
import 'package:who_is_this_kansen/settings/domain/usecases/save_theme_mode_preference.dart';
import 'package:who_is_this_kansen/settings/presentation/bloc/theme_mode_state.dart';

export 'package:who_is_this_kansen/settings/presentation/bloc/theme_mode_state.dart';

@lazySingleton
class ThemeModeCubit extends Cubit<ThemeModeState> {
  ThemeModeCubit({
    required LoadThemeModePreference loadThemeModePreference,
    required SaveThemeModePreference saveThemeModePreference,
  }) : _loadThemeModePreference = loadThemeModePreference,
       _saveThemeModePreference = saveThemeModePreference,
       super(const ThemeModeState());

  final LoadThemeModePreference _loadThemeModePreference;
  final SaveThemeModePreference _saveThemeModePreference;

  Future<void> load() async {
    emit(state.copyWith(status: ThemeModeStatus.loading));
    try {
      final preference = await _loadThemeModePreference();
      emit(
        state.copyWith(
          preference: preference,
          status: ThemeModeStatus.ready,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ThemeModeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) {
    final preference = switch (themeMode) {
      ThemeMode.system => AppThemeMode.system,
      ThemeMode.light => AppThemeMode.light,
      ThemeMode.dark => AppThemeMode.dark,
    };
    return setPreference(preference);
  }

  Future<void> setPreference(AppThemeMode preference) async {
    emit(
      state.copyWith(
        preference: preference,
        status: ThemeModeStatus.saving,
        errorMessage: null,
      ),
    );
    try {
      await _saveThemeModePreference(preference);
      emit(
        state.copyWith(
          preference: preference,
          status: ThemeModeStatus.ready,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ThemeModeStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
