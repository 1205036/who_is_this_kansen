import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_this_kansen/app/presentation/shell/app_shell.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/settings/settings.dart';

class KansenApp extends StatefulWidget {
  const KansenApp({super.key});

  @override
  State<KansenApp> createState() => _KansenAppState();
}

class _KansenAppState extends State<KansenApp> {
  late final ThemeModeCubit _themeModeCubit;

  @override
  void initState() {
    super.initState();
    final settingsRepository = SharedPreferencesAppSettingsRepository(
      preferences: SharedPreferencesAsync(),
    );
    _themeModeCubit = ThemeModeCubit(
      loadThemeModePreference: LoadThemeModePreference(settingsRepository),
      saveThemeModePreference: SaveThemeModePreference(settingsRepository),
    )..load();
  }

  @override
  void dispose() {
    _themeModeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _themeModeCubit,
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Who Is This Kansen',
            debugShowCheckedModeBanner: false,
            themeMode: state.materialThemeMode,
            theme: KansenAppTheme.light(),
            darkTheme: KansenAppTheme.dark(),
            home: AppShell(
              themeMode: state.materialThemeMode,
              onThemeModeChanged: context.read<ThemeModeCubit>().setThemeMode,
            ),
          );
        },
      ),
    );
  }
}
