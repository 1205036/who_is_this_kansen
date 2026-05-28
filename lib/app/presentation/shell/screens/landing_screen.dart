import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:who_is_this_kansen/app/presentation/router/app_routes.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/landing_mode_button.dart';
import 'package:who_is_this_kansen/app/presentation/shell/widgets/landing_title_art.dart';
import 'package:who_is_this_kansen/catalog/presentation/kansen_catalog_provider.dart';
import 'package:who_is_this_kansen/core/di/service_locator.dart';
import 'package:who_is_this_kansen/core/presentation/widgets/catalog_load_state.dart';
import 'package:who_is_this_kansen/i18n/strings.g.dart';
import 'package:who_is_this_kansen/kansen/presentation/models/kansen_view_model.dart';
import 'package:who_is_this_kansen/progress/progress.dart';
import 'package:who_is_this_kansen/quiz/presentation/bloc/quiz_prompt_cubit.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KansenViewModel>>(
      future: getIt<KansenCatalogProvider>().future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CatalogLoadError(error: snapshot.error);
        }
        final kansen = snapshot.data;
        if (kansen == null || kansen.isEmpty) {
          return const CatalogLoading();
        }
        return BlocBuilder<UnlockProgressCubit, UnlockProgressState>(
          builder: (context, progressState) {
            final hasLocked = kansen.any(
              (item) => !progressState.isUnlocked(item.id),
            );
            return _LandingScreenContent(showDiscovery: hasLocked);
          },
        );
      },
    );
  }
}

class _LandingScreenContent extends StatelessWidget {
  const _LandingScreenContent({required this.showDiscovery});

  final bool showDiscovery;

  void _enterDifficulty(BuildContext context, QuizMode mode) {
    context.go(
      AppRoutes.difficulty,
      extra: DifficultySelectionExtra(mode: mode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 34),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                SizedBox(width: constraints.maxWidth, child: LandingTitleArt()),
                Padding(
                  padding: const EdgeInsets.only(top: 260),
                  child: Column(
                    children: [
                      if (showDiscovery) ...[
                        LandingModeButton(
                          key: const ValueKey('landing-discovery-button'),
                          label: t.quiz.modeDiscovery,
                          icon: CupertinoIcons.play_fill,
                          onPressed: () => _enterDifficulty(
                            context,
                            QuizMode.discovery,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      LandingModeButton(
                        key: const ValueKey('landing-random-button'),
                        label: t.quiz.modeRandom,
                        icon: CupertinoIcons.shuffle,
                        onPressed: () => _enterDifficulty(
                          context,
                          QuizMode.random,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LandingModeButton(
                        key: const ValueKey('landing-dex-button'),
                        label: t.quiz.modeDex,
                        icon: CupertinoIcons.square_grid_2x2_fill,
                        onPressed: () => context.go(AppRoutes.dex),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
