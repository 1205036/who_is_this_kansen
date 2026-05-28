import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:who_is_this_kansen/app/presentation/notifications/unlock_toast_cubit.dart';
import 'package:who_is_this_kansen/app/presentation/router/app_routes.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/app_backdrop.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/app_top_bar.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/unlock_toast.dart';
import 'package:who_is_this_kansen/core/di/service_locator.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';
import 'package:who_is_this_kansen/settings/settings.dart';

/// Shell that hosts the persistent top bar, backdrop, and unlock toast for
/// the four main routes (landing, difficulty, quiz, dex). Pure presentation
/// — all state lives in the route extras / the locator-resolved cubits.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  String? _topBarTitle(GoRouterState state) {
    final path = state.uri.path;
    if (path == AppRoutes.landing) return null;
    if (path == AppRoutes.dex) return t.quiz.modeDex;
    if (path == AppRoutes.difficulty) {
      final extra = state.extra;
      if (extra is DifficultySelectionExtra) {
        return _modeLabel(extra.mode);
      }
      return null;
    }
    if (path == AppRoutes.quiz) {
      final extra = state.extra;
      if (extra is QuizSessionExtra) {
        return '${_modeLabel(extra.mode)} • ${_difficultyLabel(extra.difficulty)}';
      }
      return null;
    }
    return null;
  }

  String _modeLabel(QuizMode mode) => switch (mode) {
    QuizMode.discovery => t.quiz.modeDiscovery,
    QuizMode.random => t.quiz.modeRandom,
  };

  String _difficultyLabel(QuizDifficulty difficulty) => switch (difficulty) {
    QuizDifficulty.easy => t.quiz.difficultyEasy,
    QuizDifficulty.medium => t.quiz.difficultyMedium,
    QuizDifficulty.hard => t.quiz.difficultyHard,
  };

  @override
  Widget build(BuildContext context) {
    final routerState = GoRouterState.of(context);
    final isLanding = routerState.uri.path == AppRoutes.landing;

    // ThemeModeCubit and UnlockProgressCubit are already provided at the
    // root by KansenApp; the shell only adds the transient toast cubit
    // because routes underneath need to listen to it.
    return BlocProvider.value(
      value: getIt<UnlockToastCubit>(),
      child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
        // Theme mode flows through `KansenApp.materialTheme` already;
        // the shell only needs the cubit's setter for the appearance
        // popover that AppTopBar drives.
        builder: (context, _) {
          final themeCubit = context.read<ThemeModeCubit>();
          return Scaffold(
              body: Stack(
                children: [
                  const AppBackdrop(),
                  SafeArea(
                    child: Column(
                      children: [
                        AppTopBar(
                          themeMode: themeCubit.state.materialThemeMode,
                          onThemeModeChanged: themeCubit.setThemeMode,
                          showHome: !isLanding,
                          onHome: () => context.go(AppRoutes.landing),
                          title: _topBarTitle(routerState),
                        ),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.paddingOf(context).top + 58,
                    left: 18,
                    right: 18,
                    child: IgnorePointer(
                      child: BlocBuilder<UnlockToastCubit, UnlockToastState>(
                        builder: (context, toastState) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: toastState.kansen == null
                                ? const SizedBox.shrink()
                                : Align(
                                    key: ValueKey(toastState.generation),
                                    alignment: Alignment.topCenter,
                                    child: UnlockToast(
                                      kansen: toastState.kansen!,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
      ),
    );
  }
}
