import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:who_is_this_kansen/settings/domain/entities/app_theme_mode.dart';

part 'theme_mode_state.freezed.dart';

@freezed
abstract class ThemeModeState with _$ThemeModeState {
  const ThemeModeState._();

  const factory ThemeModeState({
    @Default(AppThemeMode.system) AppThemeMode preference,
    @Default(ThemeModeStatus.initial) ThemeModeStatus status,
    String? errorMessage,
  }) = _ThemeModeState;

  ThemeMode get materialThemeMode {
    return switch (preference) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };
  }
}

enum ThemeModeStatus { initial, loading, ready, saving, failure }
