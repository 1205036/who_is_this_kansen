import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_is_this_kansen/app/presentation/splash/kansendex_boot_splash.dart';
import 'package:who_is_this_kansen/app/presentation/shell/app_shell.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/settings/settings.dart';

class KansenApp extends StatefulWidget {
  const KansenApp({
    super.key,
    this.bootSplashDuration = const Duration(milliseconds: 1800),
  });

  final Duration bootSplashDuration;

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
            title: t.app.title,
            debugShowCheckedModeBanner: false,
            themeMode: state.materialThemeMode,
            theme: KansenAppTheme.light(),
            darkTheme: KansenAppTheme.dark(),
            locale: TranslationProvider.of(context).flutterLocale,
            supportedLocales: AppLocaleUtils.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: KansendexBootSplashGate(
              duration: widget.bootSplashDuration,
              child: AppShell(
                themeMode: state.materialThemeMode,
                onThemeModeChanged: context.read<ThemeModeCubit>().setThemeMode,
              ),
            ),
          );
        },
      ),
    );
  }
}
