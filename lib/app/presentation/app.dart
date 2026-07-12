import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:who_is_this_kansen/app/presentation/router/app_router.dart';
import 'package:who_is_this_kansen/core/di/service_locator.dart';
import 'package:who_is_this_kansen/core/feature_flags/domain/feature_flags_repository.dart';
import 'package:who_is_this_kansen/core/theme/kansen_app_theme.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/progress/progress.dart';
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
  late final GoRouter _router;
  late final ThemeModeCubit _themeModeCubit;
  late final UnlockProgressCubit _unlockProgressCubit;

  @override
  void initState() {
    super.initState();
    _themeModeCubit = getIt<ThemeModeCubit>()..load();
    _unlockProgressCubit = getIt<UnlockProgressCubit>()..load();
    unawaited(getIt<FeatureFlagsRepository>().load());
    _router = createAppRouter(splashDuration: widget.bootSplashDuration);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _themeModeCubit),
        BlocProvider.value(value: _unlockProgressCubit),
      ],
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        builder: (context, state) {
          return MaterialApp.router(
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
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
