import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_is_this_kansen/app/presentation/router/app_routes.dart';
import 'package:who_is_this_kansen/app/presentation/router/screens/dex_route_screen.dart';
import 'package:who_is_this_kansen/app/presentation/router/screens/quiz_route_screen.dart';
import 'package:who_is_this_kansen/app/presentation/shell/app_shell.dart';
import 'package:who_is_this_kansen/app/presentation/shell/screens/difficulty_screen.dart';
import 'package:who_is_this_kansen/app/presentation/shell/screens/landing_screen.dart';
import 'package:who_is_this_kansen/app/presentation/splash/kansendex_boot_splash.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/kansen_detail/presentation/screens/kansen_detail_screen.dart';

/// Builds the application's `GoRouter`.
///
/// The shell wraps every "main" route (landing / difficulty / quiz / dex)
/// with the shared top bar, backdrop, and unlock toast. The splash and the
/// detail screens are top-level routes outside the shell so they can claim
/// the full viewport.
GoRouter createAppRouter({
  Duration splashDuration = const Duration(milliseconds: 1800),
}) {
  final showSplash = splashDuration > Duration.zero;
  // Cross-fade transition matching the AnimatedSwitcher we used to wrap the
  // shell-internal AnimatedSwitcher; keeps tab-style nav feeling consistent
  // now that the actual transitions are owned by go_router.
  CustomTransitionPage<void> shellPage(Widget child, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 360),
      transitionsBuilder: (context, anim, sec, child) =>
          FadeTransition(opacity: anim, child: child),
      child: child,
    );
  }

  return GoRouter(
    initialLocation: showSplash ? AppRoutes.splash : AppRoutes.landing,
    routes: [
      if (showSplash)
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => KansendexBootSplashScreen(
            duration: splashDuration,
            onComplete: () => context.go(AppRoutes.landing),
          ),
        ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.landing,
            pageBuilder: (context, state) =>
                shellPage(const LandingScreen(), state),
          ),
          GoRoute(
            path: AppRoutes.difficulty,
            pageBuilder: (context, state) {
              final extra = state.extra;
              if (extra is! DifficultySelectionExtra) {
                // Direct deep-link without a mode falls back to landing.
                return shellPage(const LandingScreen(), state);
              }
              return shellPage(DifficultyScreen(mode: extra.mode), state);
            },
          ),
          GoRoute(
            path: AppRoutes.quiz,
            pageBuilder: (context, state) {
              final extra = state.extra;
              if (extra is! QuizSessionExtra) {
                return shellPage(const LandingScreen(), state);
              }
              return shellPage(QuizRouteScreen(session: extra), state);
            },
          ),
          GoRoute(
            path: AppRoutes.dex,
            pageBuilder: (context, state) =>
                shellPage(const DexRouteScreen(), state),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.detail,
        pageBuilder: (context, state) {
          final extra = state.extra;
          if (extra is! KansenViewModel) {
            // Detail can only be entered with the full view-model carried
            // through `extra`; deep links without it bounce back to dex.
            return shellPage(const DexRouteScreen(), state);
          }
          return CustomTransitionPage<void>(
            key: state.pageKey,
            opaque: false,
            barrierColor: Colors.black.withValues(alpha: 0.34),
            transitionsBuilder: (context, anim, sec, child) =>
                FadeTransition(opacity: anim, child: child),
            child: KansenDetailScreen(kansen: extra),
          );
        },
      ),
    ],
  );
}
